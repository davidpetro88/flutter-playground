import 'dart:convert';

import 'package:equatable/equatable.dart';

class CounterState extends Equatable {
  final int counterValue;
  final bool wasIncremented;

  CounterState({
    required this.counterValue,
    required this.wasIncremented,
  });

  factory CounterState.fromMap(Map<String, dynamic> map) {
    return new CounterState(
      counterValue: map['counterValue'] as int,
      wasIncremented: map['wasIncremented'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'counterValue': this.counterValue,
      'wasIncremented': this.wasIncremented,
    } as Map<String, dynamic>;
  }

  String toJson() => json.encode(toMap());

  factory CounterState.fromJson(String source) =>
      CounterState.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CounterState{counterValue: $counterValue, wasIncremented: $wasIncremented}';
  }

  @override
  List<Object?> get props => [this.counterValue, this.wasIncremented];
}
