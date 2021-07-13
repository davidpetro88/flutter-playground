import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int counterValue;
  final bool wasIncremented;

  CounterState({
    required this.counterValue,
    required this.wasIncremented,
  });

  @override
  List<Object?> get props => [this.counterValue, this.wasIncremented];
}
