/*
 * Originally derived from the Bloc package:
 * https://github.com/felangel/bloc
 * Copyright (c) 2019-present Felix Angelov
 * Modified for Streamless Blocs.
 */

import 'dart:async';

import 'package:diff_match_patch/diff_match_patch.dart';
import 'package:meta/meta.dart';
import 'package:streamless_bloc/bloc.dart';
import 'package:streamless_bloc/src/bloc_observer.dart';
import 'package:test/test.dart' as test;

/// Creates a new streamless bloc-specific test case with the given [description].
/// [blocTest] will handle asserting that the bloc emits the [expect]ed
/// states (in order) after [act] is executed.
/// [blocTest] also handles ensuring that no additional states are emitted
/// by closing the bloc before evaluating the [expect]ation.
@isTest
void blocTest<B extends BlocBase<State>, State>(
  String description, {
  required B Function() build,
  FutureOr<void> Function()? setUp,
  State Function()? seed,
  dynamic Function(B bloc)? act,
  Duration? wait,
  int skip = 0,
  dynamic Function()? expect,
  dynamic Function(B bloc)? verify,
  dynamic Function()? errors,
  FutureOr<void> Function()? tearDown,
  dynamic tags,
}) {
  test.test(
    description,
    () async {
      await testBloc<B, State>(
        setUp: setUp,
        build: build,
        seed: seed,
        act: act,
        wait: wait,
        skip: skip,
        expect: expect,
        verify: verify,
        errors: errors,
        tearDown: tearDown,
      );
    },
    tags: tags,
  );
}

/// Internal [blocTest] runner which is only visible for testing.
/// This should never be used directly -- please use [blocTest] instead.
@visibleForTesting
Future<void> testBloc<B extends BlocBase<State>, State>({
  required B Function() build,
  FutureOr<void> Function()? setUp,
  State Function()? seed,
  dynamic Function(B bloc)? act,
  Duration? wait,
  int skip = 0,
  dynamic Function()? expect,
  dynamic Function(B bloc)? verify,
  dynamic Function()? errors,
  FutureOr<void> Function()? tearDown,
}) async {
  var shallowEquality = false;
  final unhandledErrors = <Object>[];
  final localBlocObserver = BlocBase.observer;
  final testObserver = _TestBlocObserver(
    localBlocObserver,
    unhandledErrors.add,
  );
  BlocBase.observer = testObserver;

  try {
    await _runZonedGuarded(() async {
      await setUp?.call();
      final states = <State>[];
      final bloc = build();
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      if (seed != null) bloc.emit(seed());
      var skipped = 0;
      void listener(State state) {
        if (skipped < skip) {
          skipped++;
          return;
        }
        states.add(state);
      }

      bloc.addListener(listener);
      await Future<void>.delayed(Duration.zero);
      try {
        await act?.call(bloc);
      } catch (error) {
        if (errors == null) rethrow;
        unhandledErrors.add(error);
      }
      if (wait != null) await Future<void>.delayed(wait);
      await Future<void>.delayed(Duration.zero);
      await bloc.close();
      if (expect != null) {
        final dynamic expected = await expect();
        shallowEquality = '$states' == '$expected';
        try {
          test.expect(states, test.wrapMatcher(expected));
        } on test.TestFailure catch (e) {
          if (shallowEquality || expected is! List<State>) rethrow;
          final diff = _diff(expected: expected, actual: states);
          final message = '${e.message}\n$diff';
          // ignore: only_throw_errors
          throw test.TestFailure(message);
        }
      }
      bloc.removeListener(listener);
      await verify?.call(bloc);
      await tearDown?.call();
    });
  } catch (error) {
    if (shallowEquality && error is test.TestFailure) {
      // ignore: only_throw_errors
      throw test.TestFailure(
        '''
${error.message}
WARNING: Please ensure state instances extend Equatable, override == and hashCode, or implement Comparable.
Alternatively, consider using Matchers in the expect of the blocTest rather than concrete state instances.\n''',
      );
    }
    if (errors == null || !unhandledErrors.contains(error)) {
      rethrow;
    }
  }

  if (errors != null) test.expect(unhandledErrors, test.wrapMatcher(errors()));
}

Future<void> _runZonedGuarded(Future<void> Function() body) {
  final completer = Completer<void>();
  runZonedGuarded(() async {
    await body();
    if (!completer.isCompleted) completer.complete();
  }, (error, stackTrace) {
    if (!completer.isCompleted) completer.completeError(error, stackTrace);
  });
  return completer.future;
}

class _TestBlocObserver extends BlocObserver {
  const _TestBlocObserver(this._localObserver, this._onError);

  final BlocObserver _localObserver;
  final void Function(Object error) _onError;

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _localObserver.onError(bloc, error, stackTrace);
    _onError(error);
    super.onError(bloc, error, stackTrace);
  }
}

String _diff({required dynamic expected, required dynamic actual}) {
  final buffer = StringBuffer();
  final differences = diff(expected.toString(), actual.toString());
  buffer
    ..writeln('${"=" * 4} diff ${"=" * 40}')
    ..writeln()
    ..writeln(differences.toPrettyString())
    ..writeln()
    ..writeln('${"=" * 4} end diff ${"=" * 36}');
  return buffer.toString();
}

extension on List<Diff> {
  String toPrettyString() {
    String identical(String str) => '\u001b[90m$str\u001B[0m';
    String deletion(String str) => '\u001b[31m[-$str-]\u001B[0m';
    String insertion(String str) => '\u001b[32m{+$str+}\u001B[0m';

    final buffer = StringBuffer();
    for (final difference in this) {
      switch (difference.operation) {
        case DIFF_EQUAL:
          buffer.write(identical(difference.text));
          break;
        case DIFF_DELETE:
          buffer.write(deletion(difference.text));
          break;
        case DIFF_INSERT:
          buffer.write(insertion(difference.text));
          break;
      }
    }
    return buffer.toString();
  }
}
