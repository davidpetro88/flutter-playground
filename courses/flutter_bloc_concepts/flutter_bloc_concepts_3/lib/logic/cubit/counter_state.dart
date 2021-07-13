import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  late int counterValue;
  late bool wasIncremented;

  CounterState({
    required this.counterValue,
    required this.wasIncremented,
  });

  @override
  List<Object?> get props => [this.counterValue, this.wasIncremented];
}
