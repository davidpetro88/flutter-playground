import 'package:bytebank_06/components/container.dart';
import 'package:bytebank_06/models/name.dart';
import 'package:bytebank_06/screens/dasboard/dashboard_feature_item.dart';
import 'package:bytebank_06/screens/dasboard/dashboard_i18n.dart';
import 'package:bytebank_06/screens/name.dart';
import 'package:bytebank_06/screens/transferencia/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../transferencia/contacts_list.dart';


class DashboardView extends StatelessWidget {
  final DashboardViewLazyI18N _i18n;

  DashboardView(this._i18n);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // misturando um blocbuilder (que é um observer de eventos) com URI nao é boa pratica
        title: BlocBuilder<NameCubit, String>(
          builder: (context, state) => Text('Welconme $state'),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          SingleChildScrollView(
            child: Container(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  FeatureItem(
                    _i18n.transfer,
                    Icons.monetization_on,
                    onClick: () => _showContactsList(context),
                  ),
                  FeatureItem(
                    _i18n.transactionFeed,
                    Icons.description,
                    onClick: () => _showTransactionsList(context),
                  ),
                  FeatureItem(
                    _i18n.changeName,
                    Icons.person_outline,
                    onClick: () => _showChangeName(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showContactsList(BuildContext blocContext) {
  push(blocContext, ContactsListContainer());
}

void _showTransactionsList(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => TransactionsList(),
    ),
  );
}

void _showChangeName(BuildContext clocContext) {
  Navigator.of(clocContext).push(
    MaterialPageRoute(
      builder: (context) => BlocProvider.value(
        value: BlocProvider.of<NameCubit>(clocContext),
        child: NameContainer(),
      ),
    ),
  );
}
