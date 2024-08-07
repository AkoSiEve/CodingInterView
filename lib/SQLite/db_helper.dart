import 'dart:developer';

import 'package:codingint/SQLite/personsale.dart';
import 'package:codingint/SQLite/tempJson.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  final databaseName = "myDbv4";

  String personsale = '''
  CREATE TABLE IF NOT EXISTS personsale(
    personid	INTEGER PRIMARY KEY AUTOINCREMENT,
    personname	TEXT NOT NULL,
    itemname	TEXT NOT NULL,
    itemamount	INTEGER NOT NULL
  );

  CREATE TABLE IF NOT EXISTS itemTable(
    itemid	INTEGER PRIMARY KEY AUTOINCREMENT,
    itemname	TEXT NOT NULL,
    itemamount	TEXT NOT NULL
  );

  CREATE TABLE IF NOT EXISTS temp(
    tempid	INTEGER PRIMARY KEY AUTOINCREMENT,
    saleperson	TEXT NOT NULL,
    itemA	TEXT ,
    itemB	TEXT ,
    itemC	TEXT ,
    itemD	TEXT ,
    itemE	TEXT ,
    itemF	TEXT ,
    itemG	TEXT 
  );

''';
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      // await db.execute(itemTable);
      await db.execute(personsale);
      await db.execute(
          "insert into itemTable(itemname,itemamount) values('itemA','100')");
      await db.execute(
          "insert into itemTable(itemname,itemamount) values('itemB','150')");
      await db.execute(
          "insert into itemTable(itemname,itemamount) values('itemC','200')");
      await db.execute(
          "insert into itemTable(itemname,itemamount) values('itemD','250')");
      await db.execute(
          "insert into itemTable(itemname,itemamount) values('itemE','300')");
      await db.execute(
          "insert into itemTable(itemname,itemamount) values('itemF','330')");
      await db.execute(
          "insert into itemTable(itemname,itemamount) values('itemG','410')");
    });
  }

  //add sales to DB
  Future<int> createSale(PersonSale itm) async {
    final Database db = await initDB();
    return db.insert("personsale", itm.toJson());
  }

  //
  fetchPivotTable() async {
    final Database db = await initDB();
    var result = await db.query("temp");
    // log("taetae${result}");
    return result;
    // return result.map((e) => Temp.fromJson(e)).toList();
  }

  deleteTablePivot() async {
    final Database db = await initDB();
    final res = await db.rawDelete("delete from temp");
    // final res = await db.rawQuery(
    // 'insert into temp(saleperson,itemA,itemB,itemC,itemD,itemE,itemF,itemG) select personname as "Sales Person",sum(itemamount) filter(where itemname="itemA") as "Item A",sum(itemamount) filter(where itemname="itemB") as "Item B",sum(itemamount) filter(where itemname="itemC") as "Item C",sum(itemamount) filter(where itemname="itemD") as "Item D",sum(itemamount) filter(where itemname="itemE") as "Item E",sum(itemamount) filter(where itemname="itemF") as "Item F",sum(itemamount) filter(where itemname="itemG") as "Item G" from(select * from (select a.personname,b.itemname,b.itemamount from personsale as a join itemTable as b on a.itemname=b.itemname group by b.itemname) as c) group by personname;');
    // log("${res}");
  }

  updateTablePivot() async {
    final Database db = await initDB();
    // await db.rawDelete("delete from temp");
    // final res = await db.rawQuery(
    //     'insert into temp(saleperson,itemA,itemB,itemC,itemD,itemE,itemF,itemG) select personname as "Sales Person",sum(itemamount) filter(where itemname="itemA") as "Item A",sum(itemamount) filter(where itemname="itemB") as "Item B",sum(itemamount) filter(where itemname="itemC") as "Item C",sum(itemamount) filter(where itemname="itemD") as "Item D",sum(itemamount) filter(where itemname="itemE") as "Item E",sum(itemamount) filter(where itemname="itemF") as "Item F",sum(itemamount) filter(where itemname="itemG") as "Item G" from(select * from (select a.personname,b.itemname,a.itemamount from personsale as a join itemTable as b on a.itemname=b.itemname group by b.itemname) as c) group by personname;');
    final res = await db.rawQuery(
        'insert into temp(saleperson,itemA,itemB,itemC,itemD,itemE,itemF,itemG) select personname as "Sales Person",sum(itemamount) filter(where itemname="itemA") as "Item A",sum(itemamount) filter(where itemname="itemB") as "Item B",sum(itemamount) filter(where itemname="itemC") as "Item C",sum(itemamount) filter(where itemname="itemD") as "Item D",sum(itemamount) filter(where itemname="itemE") as "Item E",sum(itemamount) filter(where itemname="itemF") as "Item F",sum(itemamount) filter(where itemname="itemG") as "Item G" from(select a.personname,a.itemname,a.itemamount from personsale as a join itemTable as b on a.itemname=b.itemname) as c group by personname ');
  }

  //
  fetchPersonTable() async {
    final Database db = await initDB();
    var result = await db.query("personsale");
    return result;
    // return result.map((e) => Temp.fromJson(e)).toList();
  }

  deleteByIdPersonTable(String str) async {
    final Database db = await initDB();
    final res =
        await db.rawDelete("delete from personsale where personid='${str}'");

    return res;
  }

  ///
  fetchItemTable() async {
    final Database db = await initDB();
    var result = await db.query("itemTable");
    return result;
  }

  //

  updateByIdPersonTable(int id, String itmName, String tmamount) async {
    final Database db = await initDB();
    final res = await db.rawUpdate(
        "update personsale set itemname='${itmName}',itemamount='${tmamount}' where personid='${id}'");
    log("tae taetae ${res}");
    return res;
  }

  queryChecker() async {
    final Database db = await initDB();
    // final res = await db.rawQuery("select * from itemTable");
    // final res = await db.rawQuery(
    //     "insert into itemTable(itemname,itemamount) values('itemG','480')");
    // final res = await db.rawQuery(
    //     'select personname as "Sales Person",sum(itemamount) filter(where itemname="itemA") as "Item A",sum(itemamount) filter(where itemname="itemB") as "Item B",sum(itemamount) filter(where itemname="itemC") as "Item C",sum(itemamount) filter(where itemname="itemD") as "Item D",sum(itemamount) filter(where itemname="itemE") as "Item E",sum(itemamount) filter(where itemname="itemF") as "Item F",sum(itemamount) filter(where itemname="itemG") as "Item G" from(select * from (select a.personname,b.itemname,b.itemamount from personsale as a join itemTable as b on a.itemname=b.itemname group by b.itemname) as c) group by personname;');

    // final del = await db.rawDelete("delete from temp");
    // final res = await db.rawQuery(
    // 'insert into temp(saleperson,itemA,itemB,itemC,itemD,itemE,itemF,itemG) select personname as "Sales Person",sum(itemamount) filter(where itemname="itemA") as "Item A",sum(itemamount) filter(where itemname="itemB") as "Item B",sum(itemamount) filter(where itemname="itemC") as "Item C",sum(itemamount) filter(where itemname="itemD") as "Item D",sum(itemamount) filter(where itemname="itemE") as "Item E",sum(itemamount) filter(where itemname="itemF") as "Item F",sum(itemamount) filter(where itemname="itemG") as "Item G" from(select * from (select a.personname,b.itemname,b.itemamount from personsale as a join itemTable as b on a.itemname=b.itemname group by b.itemname) as c) group by personname;');
    // final res = await db.rawQuery(
    // 'select personname as "Sales Person",sum(itemamount) filter(where itemname="itemA") as "Item A",sum(itemamount) filter(where itemname="itemB") as "Item B",sum(itemamount) filter(where itemname="itemC") as "Item C",sum(itemamount) filter(where itemname="itemD") as "Item D",sum(itemamount) filter(where itemname="itemE") as "Item E",sum(itemamount) filter(where itemname="itemF") as "Item F",sum(itemamount) filter(where itemname="itemG") as "Item G" from(select a.personname,a.itemname,a.itemamount from personsale as a join itemTable as b on a.itemname=b.itemname) as c group by personname ');
    // final res = await db.rawQuery(
    //     "insert into itemTable(itemname,itemamount) values('itemG','410')");
    // 'update personsale set itemname=?,itemamount=? where id=56 '
    // itemC -> itemD
    //300 -> 400
    final res = await db.rawQuery('select * from itemTable');
    log("${res}");
  }
}
