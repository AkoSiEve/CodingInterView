// To parse this JSON data, do
//
//     final temp = tempFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Temp tempFromJson(String str) => Temp.fromJson(json.decode(str));

String tempToJson(Temp data) => json.encode(data.toJson());

class Temp {
  final int tempid;
  final String saleperson;
  final String itemA;
  final String itemB;
  final String itemC;
  final String itemD;
  final String itemE;
  final String itemF;
  final String itemG;

  Temp({
    required this.tempid,
    required this.saleperson,
    required this.itemA,
    required this.itemB,
    required this.itemC,
    required this.itemD,
    required this.itemE,
    required this.itemF,
    required this.itemG,
  });

  factory Temp.fromJson(Map<String, dynamic> json) => Temp(
        tempid: json["tempid"],
        saleperson: json["saleperson"],
        itemA: json["itemA"],
        itemB: json["itemB"],
        itemC: json["itemC"],
        itemD: json["itemD"],
        itemE: json["itemE"],
        itemF: json["itemF"],
        itemG: json["itemG"],
      );

  Map<String, dynamic> toJson() => {
        "tempid": tempid,
        "saleperson": saleperson,
        "itemA": itemA,
        "itemB": itemB,
        "itemC": itemC,
        "itemD": itemD,
        "itemE": itemE,
        "itemF": itemF,
        "itemG": itemG,
      };
}
