import 'package:bytebank_03/screens/dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BytbankApp());
  // findAll().then((transactions) => print('new Transactions $transactions'));
  // save(Contact(0, 'david', 1000)).then((id) {
  //   findAll().then((contacts) => debugPrint(contacts.toString()));
  // });
}

class BytbankApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.green[900],
          accentColor: Colors.blueAccent[700],
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent[700],
            textTheme: ButtonTextTheme.primary,
          )),
      // home: TransactionAuthDialog(), //Scaffold
      home: Dashboard(), //Scaffold
    );
  }
}
