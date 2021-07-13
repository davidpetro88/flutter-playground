import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> with HydratedMixin {
  CounterCubit() : super(CounterState(counterValue: 0, wasIncremented: false));

  void increment() => emit(
      CounterState(counterValue: state.counterValue + 1, wasIncremented: true));

  void decrement() => emit(CounterState(
      counterValue: state.counterValue - 1, wasIncremented: false));

  @override
  CounterState? fromJson(Map<String, dynamic> json) {
    // addError(Exception('Couldn' ' write to storage!'), StackTrace.current);
    return CounterState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(CounterState state) {
    return state.toMap();
  }

  //cubit
  @override
  void onChange(Change<CounterState> change) {
    print("current" +
        change.currentState.toString() +
        "next: " +
        change.nextState.counterValue.toString());
    super.onChange(change);
  }

  //cubit
  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}
