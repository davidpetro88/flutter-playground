import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  final String message;

  Progress({
    this.message = 'Loading',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Loading',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressView extends StatelessWidget {
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
