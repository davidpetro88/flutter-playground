import 'package:bytebank_06/components/container.dart';
import 'package:bytebank_06/components/progress/progress.dart';
import 'package:bytebank_06/database/dao/contact_dao.dart';
import 'package:bytebank_06/models/contact.dart';
import 'package:bytebank_06/screens/transferencia/contact_form.dart';
import 'package:bytebank_06/screens/transferencia/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class ContactListState {
  const ContactListState();
}

@immutable
class InitContactsListState extends ContactListState {
  const InitContactsListState();
}

@immutable
class LoadingContactsListState extends ContactListState {
  const LoadingContactsListState();
}

@immutable
class LoadedContactsListState extends ContactListState {
  final List<Contact> _contacts;

  const LoadedContactsListState(this._contacts);
}

@immutable
class FatalErrorContactsListState extends ContactListState {
  const FatalErrorContactsListState();
}

class ContactListCubit extends Cubit<ContactListState> {
  ContactListCubit() : super(InitContactsListState());

  void reload(ContactDao dao) {
    emit(LoadingContactsListState());
    dao.findAll().then((contacts) => emit(LoadedContactsListState(contacts)));
  }
}
// class ContactListState {
//   string e
// }

class ContactsListContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    final ContactDao _dao = ContactDao();

    return BlocProvider<ContactListCubit>(
        create: (BuildContext contect) {
          final cubit = ContactListCubit();
          cubit.reload(_dao);
          return cubit;
        },
        child: ContactsList(_dao));
  }
}

class ContactsList extends StatelessWidget {
  final ContactDao _dao;

  const ContactsList(this._dao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: BlocBuilder<ContactListCubit, ContactListState>(
          builder: (context, state) {
        if (state is InitContactsListState ||
            state is LoadingContactsListState) {
          return Progress();
        }
        if (state is LoadedContactsListState) {
          final List<Contact> contacts = state._contacts;
          return ListView.builder(
            itemBuilder: (context, index) {
              final Contact contact = contacts[index];
              return _ContactItem(
                contact,
                onClick: () {
                  push(context, TransactionFormContainer(contact));
                },
              );
            },
            itemCount: contacts.length,
          );
        }
        return Text('Unknown error');
      }),
      floatingActionButton: buildAddContactButton(context),
    );
  }

  FloatingActionButton buildAddContactButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactForm(),
          ),
        );
        context.read<ContactListCubit>().reload(this._dao);
      },
      child: Icon(
        Icons.add,
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(this.contact, {required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
