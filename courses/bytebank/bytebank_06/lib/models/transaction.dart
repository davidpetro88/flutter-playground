import 'contact.dart';

class Transaction {
  String id;
  double value;
  Contact contact;

  Transaction(
    this.id,
    this.value,
    this.contact,
  );

  Transaction.fromJson(dynamic json)
      : id = json['id'],
        value = json['value'],
        contact = Contact.fromJson(json['contact']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
        'contact': contact.toJson(),
      };

  @override
  String toString() {
    return 'Transaction{id: $id, value: $value, contact: $contact}';
  }
}
