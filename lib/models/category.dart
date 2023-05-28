import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  String? residence;
  String? edibles;
  String? wearables;
  String? medicine;
  String? other;
  Category({
    this.residence,
    this.edibles,
    this.wearables,
    this.medicine,
    this.other,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Residence': residence,
      'Edibles': edibles,
      'Wearables': wearables,
      'Medicine': medicine,
      'Other': other,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      residence: map['Residence'] != null ? map['Residence'] as String : null,
      edibles: map['Edibles'] != null ? map['Edibles'] as String : null,
      wearables: map['Wearables'] != null ? map['Wearables'] as String : null,
      medicine: map['Medicine'] != null ? map['Medicine'] as String : null,
      other: map['Other'] != null ? map['Other'] as String : null,
    );
  }

  static Category fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Category(
        residence: snapshot['Residence'],
        edibles: snapshot['Edibles'],
        wearables: snapshot['Wearables'],
        medicine: snapshot['Medicine'],
        other: snapshot['Other']);
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
