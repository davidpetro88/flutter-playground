import 'package:bytebank_06/components/progress/progress.dart';
import 'package:flutter/material.dart';

class ProgressView extends StatelessWidget {
  late String message;


  ProgressView({String message = "Sending..."}) {
    this.message = message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progressing'),
      ),
      body: Progress(
        message: 'Sending ...',
      ),
    );
  }
}