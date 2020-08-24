import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String name;
  final double price;
  final int count;
  final String url;
  final DocumentReference reference;
  final String category;

  Item.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['price'] != null),
        assert(map['count'] != null),
        assert(map['url'] != null),
        assert(map['category'] != null),
        name = map['name'],
        // If the value in the database is just stored as a whole number
        // i.e. 2 the cast to double will fail so we change to string then
        // parse as a double.
        price = double.parse(map['price'].toString()),
        count = map['count'],
        url = map['url'],
        category = map['category'];

  Item.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  bool operator ==(other) => other is Item && other.name == name;

  int get hashCode => name.hashCode;
}
