import 'package:bytebank_06/components/container.dart';
import 'package:bytebank_06/components/localization.dart';
import 'package:bytebank_06/models/name.dart';
import 'package:bytebank_06/screens/name.dart';
import 'package:bytebank_06/screens/transferencia/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'contacts_list.dart';

class DashboardContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NameCubit("David"),
      child: I18NLoadingContainer(
        viewKey: "dashboard",
        creator: (I18NMessages messages) => DashboardView(DashboardViewLazyI18N(messages))
      ),
    );
  }
}

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
                  _FeatureItem(
                    _i18n.transfer,
                    Icons.monetization_on,
                    onClick: () => _showContactsList(context),
                  ),
                  _FeatureItem(
                    _i18n.transactionFeed,
                    Icons.description,
                    onClick: () => _showTransactionsList(context),
                  ),
                  _FeatureItem(
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

class DashboardViewLazyI18N {
  final I18NMessages _messages;

  DashboardViewLazyI18N(this._messages);

  String get transfer => _messages.get("transfer");

  String get transactionFeed => _messages.get("transaction_feed");

  String get changeName =>  _messages.get("change_name");
}

class DashboardViewI18N extends ViewI18N {
  DashboardViewI18N(BuildContext context) : super(context);

  String get transfer => localize({"pt-br": "Transferir", "en": "Transfer"});

  String get transactionFeed =>
      localize({"pt-br": "Transações", "en": "Transaction Feed"});

  String get changeName =>
      localize({"pt-br": "Mudar nome", "en": "Change name"});
}

class _FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function? onClick;

  _FeatureItem(this.name, this.icon, {@required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () {
            onClick!();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            height: 100,
            width: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 32.0,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
        ),
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
