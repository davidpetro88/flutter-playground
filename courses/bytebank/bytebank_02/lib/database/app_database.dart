import 'package:bytebank_02/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/contact_dao.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ContactDao.tableSql);
    },
    version: 1,
  );
}

// Old not used more
Future<Database> createDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, 'bytebank.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute('CREATE TABLE contacts( '
            'id INTEGER PRIMARY KEY, '
            'name TEXT, '
            'account_number INTEGER)');
      },
      version: 1,
      // onDowngrade: onDatabaseDowngradeDelete,
    );
  });
}

Future<int> save(Contact contact) {
  return createDatabase().then((db) {
    final Map<String, dynamic> contactMap = Map();
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;
    return db.insert('contacts', contactMap);
  });
}

Future<List<Contact>> findAll() {
  return createDatabase().then((db) {
    return db.query('contacts').then((maps) {
      final List<Contact> contacts = [];
      for (Map<String, dynamic> map in maps) {
        contacts.add(
          Contact(
            map['id'],
            map['name'],
            map['account_number'],
          ),
        );
      }
      return contacts;
    });
  });
}
