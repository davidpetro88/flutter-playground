import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_concepts/presentation/router/app_router.dart';
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
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: _appRouter.onGenerateRoute,
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
    _appRouter.dispose();
    super.dispose();
  }
}
