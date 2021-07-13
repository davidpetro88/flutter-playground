import 'dart:convert';

import 'package:bytebank_06/models/transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../webclient.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic json)  => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    // Future.delayed(Duration(seconds: 10));

    final Response response = await client.post(baseUrl,
        headers: {
          'Content-type': 'application/json',
          'password': password,
        },
        body: transactionJson);

    if (response.statusCode == 200) {
      debugPrint('caiu no 200 com sucesso!');
      return Transaction.fromJson(jsonDecode(response.body));
    }

    debugPrint('deu erro! ${response.statusCode }');

    throw HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode]!;
    }
    return 'Unknow Error';
  }

  static final Map<int, String> _statusCodeResponses = {
    400: 'there was an error submitting transaction',
    401: 'authentication failed',
    409: 'transaction always exists'
  };

}

class HttpException implements Exception {
  final String? message;

  HttpException(this.message);
}
