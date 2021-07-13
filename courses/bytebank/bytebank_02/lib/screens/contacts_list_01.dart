import 'package:bytebank_02/database/app_database.dart';
import 'package:bytebank_02/models/contact.dart';
import 'package:bytebank_02/screens/contact_form.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: FutureBuilder<List<Contact>>(
        future: findAll(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data != null) {
            final List<Contact> contacts = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                final Contact contact = contacts[index];
                return _ContactITem(contact);
              },
              itemCount: contacts.length,
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('Loading')
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(builder: (context) => ContactForm()),
          )
              .then(
                (newContact) => debugPrint(newContact.toString()),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}

class _ContactITem extends StatelessWidget {
  final Contact contact;

  _ContactITem(this.contact);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          contact.name,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
