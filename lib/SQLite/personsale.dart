// To parse this JSON data, do
//
//     final personSale = personSaleFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PersonSale personSaleFromJson(String str) =>
    PersonSale.fromJson(json.decode(str));

String personSaleToJson(PersonSale data) => json.encode(data.toJson());

class PersonSale {
  final int? personid;
  final String personname;
  final String itemname;
  final int itemamount;

  PersonSale({
    this.personid,
    required this.personname,
    required this.itemname,
    required this.itemamount,
  });

  factory PersonSale.fromJson(Map<String, dynamic> json) => PersonSale(
        personid: json["personid"],
        personname: json["personname"],
        itemname: json["itemname"],
        itemamount: json["itemamount"],
      );

  Map<String, dynamic> toJson() => {
        "personid": personid,
        "personname": personname,
        "itemname": itemname,
        "itemamount": itemamount,
      };
}
