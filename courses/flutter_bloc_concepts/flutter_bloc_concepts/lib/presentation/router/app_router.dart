import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_concepts/presentation/screens/home_screen.dart';
import 'package:flutter_bloc_concepts/presentation/screens/second_screen.dart';
import 'package:flutter_bloc_concepts/presentation/screens/settings_screen.dart';
import 'package:flutter_bloc_concepts/presentation/screens/third_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => HomeScreen(
                  title: 'Flutter Demo Home Page',
                  color: Colors.blueAccent,
                ));
      case '/second':
        return MaterialPageRoute(
            builder: (_) => SecondScreen(
                  title: 'Second Screen',
                  color: Colors.redAccent,
                ));
      case '/third':
        return MaterialPageRoute(
            builder: (_) => ThirdScreen(
                  title: 'ThirdScreen Screen',
                  color: Colors.greenAccent,
                ));
      case '/settings':
        return MaterialPageRoute(
          builder: (_) => SettingsScreen(),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => HomeScreen(
                  title: 'Flutter Demo Home Page',
                  color: Colors.blueAccent,
                ));
    }
  }
}
