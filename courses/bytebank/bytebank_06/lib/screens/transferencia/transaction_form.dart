import 'dart:async';

import 'package:bytebank_06/components/container.dart';
import 'package:bytebank_06/components/error_view.dart';
import 'package:bytebank_06/components/progress/progress.dart';
import 'package:bytebank_06/components/progress/progress_view.dart';
import 'package:bytebank_06/components/response_dialog.dart';
import 'package:bytebank_06/components/transaction_auth_dialog.dart';
import 'package:bytebank_06/http/webclients/transaction_webclient.dart';
import 'package:bytebank_06/models/contact.dart';
import 'package:bytebank_06/models/transaction.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class SendingState extends TransactionFormState {
  const SendingState();
}

@immutable
class ShowFormState extends TransactionFormState {
  const ShowFormState();
}

@immutable
class SentState extends TransactionFormState {
  const SentState();
}

@immutable
class FatalErrorTransactionFormState extends TransactionFormState {
  final String _message;

  const FatalErrorTransactionFormState(this._message);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormState());

  void save(Transaction transactionCreated, String password,
      BuildContext context) async {
    emit(SendingState());
    await _send(
      transactionCreated,
      password,
      context,
    );
  }

  _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    await TransactionWebClient()
        .save(transactionCreated, password)
        .then((transaction) => emit(SentState()))
        .catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exeption', e.toString());
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e, null);
      }
      emit(FatalErrorTransactionFormState(e.message));
    }, test: (e) => e is HttpException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exeption', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e, null);
      }
      emit(FatalErrorTransactionFormState(e.message));
    }, test: (e) => e is TimeoutException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exeption', e.toString());
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e, null);
      }
      emit(FatalErrorTransactionFormState(e.message));
    });
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact _contact;

  TransactionFormContainer(this._contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
        create: (BuildContext) {
          return TransactionFormCubit();
        },
        child: BlocListener<TransactionFormCubit, TransactionFormState>(
          listener: (context, state) {
            if (state is SentState) {
              Navigator.pop(context);
            }
          },
          child: TransactionFormStateless(_contact),
        ));
  }
}

class TransactionFormStateless extends StatelessWidget {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String transactionId = Uuid().v4();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _sending = false;
  final Contact _contact;

  TransactionFormStateless(this._contact);

  @override
  Widget build(BuildContext context) {
    print('Transaction form id $transactionId');
    // return Scaffold(
    //   key: _scaffoldKey,
    //   appBar: AppBar(
    //     title: Text('New transaction'),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Visibility(
    //             child: Padding(
    //               padding: const EdgeInsets.all(8.0),
    //               child: Progress(
    //                 message: 'Sending ...',
    //               ),
    //             ),
    //             visible: _sending,
    //           ),
    //           Text(
    //             _contact.name,
    //             style: TextStyle(
    //               fontSize: 24.0,
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 16.0),
    //             child: Text(
    //               _contact.accountNumber.toString(),
    //               style: TextStyle(
    //                 fontSize: 32.0,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 16.0),
    //             child: TextField(
    //               controller: _valueController,
    //               style: TextStyle(fontSize: 24.0),
    //               decoration: InputDecoration(labelText: 'Value'),
    //               keyboardType: TextInputType.numberWithOptions(decimal: true),
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 16.0),
    //             child: SizedBox(
    //               width: double.maxFinite,
    //               child: ElevatedButton(
    //                 child: Text('Transfer'),
    //                 onPressed: () {
    //                   final double? value =
    //                       double.tryParse(_valueController.text);
    //                   if (value != null) {
    //                     final transactionCreated =
    //                         Transaction(transactionId, value, _contact);
    //                     showDialog(
    //                         context: context,
    //                         builder: (contextDialog) => TransactionAuthDialog(
    //                               onConfirm: (String password) {
    //                                 _save(
    //                                     transactionCreated, password, context);
    //                               },
    //                             ));
    //                   }
    //                 },
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
        builder: (context, state) {
      if (state is ShowFormState) {
        return _BasicForm(_contact);
      }
      if (state is SendingState || state is SentState) {
        return ProgressView();
      }
      if (state is FatalErrorTransactionFormState) {
        return ErrorView(state._message);
      }
      return ErrorView("Unknow error");
    });
  }

  void _save(
    Transaction transactionCreated,
    String password,
    BuildContext context,
  ) async {
    Transaction transaction = await _send(
      transactionCreated,
      password,
      context,
    );
    _showSuccessfulMessage(transaction, context);
  }

  Future _showSuccessfulMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
          context: context,
          builder: (contextDialog) {
            return SuccessDialog('successful transaction');
          });
      Navigator.pop(context);
    }
  }

  Future<Transaction> _send(Transaction transactionCreated, String password,
      BuildContext context) async {
    // @TODO
    // setState(() {
    //   _sending = true;
    // });
    final Transaction transaction =
        await _webClient.save(transactionCreated, password).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exeption', e.toString());
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e, null);
      }
      _showFailureMessage(context, message: e.message);
    }, test: (e) => e is HttpException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exeption', e.toString());
        FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e, null);
      }
      _showFailureMessage(context,
          message: 'timeout submitting the transaction');
    }, test: (e) => e is TimeoutException).catchError((e) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
        FirebaseCrashlytics.instance.setCustomKey('exeption', e.toString());
        FirebaseCrashlytics.instance
            .setCustomKey('http_body', transactionCreated.toString());
        FirebaseCrashlytics.instance.recordError(e, null);
      }

      _showFailureMessage(context);
    }).whenComplete(() {
      //@TODO
      // setState(() {
      //   _sending = false;
      // });
    });
    return transaction;
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknow error'}) {
    // Example Error with diaglog
    // showDialog(
    //     context: context,
    //     builder: (contextDialog) {
    //       return FailureDialog(message);
    //     });

    // Example Error with snackBar
    // final snackBar = SnackBar(content: Text(message));
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Example Error with Toast
    // showToast(message, gravity: Toast.BOTTOM);

    // Example Error with giffy_dialog
    showDialog(
        context: context,
        builder: (_) => NetworkGiffyDialog(
              image: Image.asset('images/error.gif'),
              title: Text('OPS',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
              description: Text(
                message,
                textAlign: TextAlign.center,
              ),
              entryAnimation: EntryAnimation.BOTTOM,
              onOkButtonPressed: () {},
            ));
  }

// void showToast(String msg, {int duration = 5, required int gravity}) {
//   Toast.show(msg, context, duration: duration, gravity: gravity);
// }
}

class _BasicForm extends StatelessWidget {
  final Contact _contact;
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = Uuid().v4();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _BasicForm(this._contact);

  // final TransactionWebClient _webClient = TransactionWebClient();

  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      if (value != null) {
                        final transactionCreated =
                            Transaction(transactionId, value, _contact);
                        showDialog(
                            context: context,
                            builder: (contextDialog) => TransactionAuthDialog(
                                  onConfirm: (String password) {
                                    BlocProvider.of<TransactionFormCubit>(
                                            context)
                                        .save(transactionCreated, password,
                                            context);
                                  },
                                ));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
