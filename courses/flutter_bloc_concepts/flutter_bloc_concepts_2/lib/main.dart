import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_concepts/presentation/screens/second_screen.dart';

import 'logic/cubit/counter_cubit.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/third_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CounterCubit _counterCubit = CounterCubit();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => BlocProvider.value(
              value: _counterCubit,
              child: HomeScreen(
                title: 'Flutter Demo Home Page',
                color: Colors.blueAccent,
              ),
            ),
        '/second': (context) => BlocProvider.value(
          value: _counterCubit,
              child: SecondScreen(
                title: 'Second Screen',
                color: Colors.redAccent,
              ),
            ),
        '/third': (context) => BlocProvider.value(
          value: _counterCubit,
              child: ThirdScreen(
                title: 'ThirdScreen Screen',
                color: Colors.greenAccent,
              ),
            ),
      },
      // home: BlocProvider<CounterCubit>(
      //   create: (context) => CounterCubit(),
      //   child: HomeScreen(
      //     title: 'Flutter Demo Home Page',
      //     color: Colors.blueAccent,
      //   ),
      // ),
    );
  }

  @override
  void dispose() {
    _counterCubit.close();
    super.dispose();
  }
}
