import 'package:bytebank_06/database/dao/contact_dao.dart';
import 'package:bytebank_06/models/contact.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberrController =
      TextEditingController();
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('new Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _accountNumberrController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                ),
                style: TextStyle(
                  fontSize: 24.0,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                //pega 100 % do container que ele esta dentro
                child: ElevatedButton(
                  onPressed: () {
                    final String name = _nameController.text;
                    final int? accountNumber =
                        int.tryParse(_accountNumberrController.text);
                    if (accountNumber != null) {
                      final Contact newContact =
                          Contact(0, name, accountNumber);
                      _dao.save(newContact).then((id) => Navigator.pop(context));
                    }
                  },
                  child: Text('Create'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
