import 'dart:async';

import 'package:bytebank_03/components/theme.dart';
import 'package:bytebank_03/screens/counter.dart';
import 'package:bytebank_03/screens/name.dart';
import 'package:bytebank_03/screens/transferencia/dashboard.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (kDebugMode) {
    // Force disable Crashytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FirebaseCrashlytics.instance.setUserIdentifier('davidpetro');
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  //sempre que tiver problema aqui ele vai notificar, caso de um erro que o flutter nao percebe o runApp vai saber
  // blinda a aplicacao de possiveis erros de dart
  runZonedGuarded<Future<void>>(() async {
    runApp(BytbankApp());
  }, FirebaseCrashlytics.instance.recordError);

  // findAll().then((transactions) => print('new Transactions $transactions'));
  // save(Contact(0, 'david', 1000)).then((id) {
  //   findAll().then((contacts) => debugPrint(contacts.toString()));
  // });
}

class LogObserver extends BlocObserver {

  @override
  void onChange(Cubit cubit, Change change) {
    print("${cubit.runtimeType} > $change");
    super.onChange(cubit, change);
  }
}
class BytbankApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    //Evitar log do genero
    Bloc.observer = LogObserver();

    return MaterialApp(
      theme: bytebakTheme,
      // home: TransactionAuthDialog(), //Scaffold
      home: DashboardContainer(), //Scaffold
      // home: CounterContainer(), //Scaffold
      // home: NameContainer()
    );
  }
}
