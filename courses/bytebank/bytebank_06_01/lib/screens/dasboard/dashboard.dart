import 'package:bytebank_06/models/saldo.dart';
import 'package:bytebank_06/screens/dasboard/saldo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('ByteBank')),
      body: SaldoCard(Saldo(30.00)),
    );
  }
}
