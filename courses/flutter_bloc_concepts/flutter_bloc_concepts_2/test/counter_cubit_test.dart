import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_concepts/logic/cubit/counter_cubit.dart';
import 'package:flutter_bloc_concepts/logic/cubit/counter_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterCubit', () {
    late CounterCubit counterCubit;

    setUp(() {
      counterCubit = CounterCubit();
    });

    tearDown(() {
      counterCubit.close();
    });

    //This test failed because this 2 instance was storage in different part of memory
    // and dart compare location of memory instead values.
    // So for fix this teste with add "Equatable"
    // Expected: <Instance of 'CounterState'>
    // Actual: <Instance of 'CounterState'>
    /*
        class CounterState extends Equatable {
          late int counterValue;
          late bool wasIncrmented;

          CounterState({
            required this.counterValue,
            required this.wasIncrmented,
          });

          @override
          List<Object?> get props => [this.counterValue, this.wasIncrmented];
        }
     */
    test('initial state of CounterCubit is CounterState(counterValue:0)', () {
      expect(counterCubit.state,
          CounterState(counterValue: 0, wasIncremented: false));
    });

    blocTest(
        'the CounterCubit should emit a CounterState(counterValue:1, wasIncremented:true) when the increment function is called',
        build: () => counterCubit,
        act: (cubit) => counterCubit.increment(),
        expect: () => [CounterState(counterValue: 1, wasIncremented: true)]);

    blocTest(
        'the CounterCubit should emit a CounterState(counterValue:-1, wasIncremented:false) when the decrement function is called',
        build: () => counterCubit,
        act: (cubit) => counterCubit.decrement(),
        expect: () => [CounterState(counterValue: -1, wasIncremented: false)]);
  });
}
