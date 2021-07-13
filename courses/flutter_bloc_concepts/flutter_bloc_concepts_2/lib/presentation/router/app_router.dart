import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_concepts/logic/cubit/counter_cubit.dart';
import 'package:flutter_bloc_concepts/presentation/screens/home_screen.dart';
import 'package:flutter_bloc_concepts/presentation/screens/second_screen.dart';
import 'package:flutter_bloc_concepts/presentation/screens/third_screen.dart';

class AppRouter {
  final CounterCubit _counterCubit = CounterCubit();

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _counterCubit,
                  child: HomeScreen(
                    title: 'Flutter Demo Home Page',
                    color: Colors.blueAccent,
                  ),
                ));
      case '/second':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _counterCubit,
                  child: SecondScreen(
                    title: 'Second Screen',
                    color: Colors.redAccent,
                  ),
                ));
      case '/thrid':
        return MaterialPageRoute(
            builder: (_) => BlocProvider.value(
                  value: _counterCubit,
                  child: ThirdScreen(
                    title: 'ThirdScreen Screen',
                    color: Colors.greenAccent,
                  ),
                ));
      default:
        return null;
    }
  }
}
