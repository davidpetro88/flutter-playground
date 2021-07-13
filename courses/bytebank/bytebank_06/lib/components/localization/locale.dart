import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../container.dart';

class LocalizationContainer extends BlocContainer {
  final Widget child;

  LocalizationContainer({required Widget this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: CurrentLocaleCubit(),
      child: this.child,
    );
  }
}

class CurrentLocaleCubit extends Cubit<String> {
  CurrentLocaleCubit() : super("pt-br");
}