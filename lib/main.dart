import 'package:codingint/view/home.view.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
  await db.execute('''
  CREATE TABLE IF NOT EXISTS itemTable(
    itemid	INTEGER PRIMARY KEY AUTOINCREMENT,
    itemname	TEXT NOT NULL,
    itemamount	TEXT NOT NULL
  );
  ''');
  await db.execute(
      "insert into itemTable(itemname,itemamount) values('itemA','100')");
  await db.execute(
      "insert into itemTable(itemname,itemamount) values('itemB','100')");
  await db.execute(
      "insert into itemTable(itemname,itemamount) values('itemC','100')");
  await db.execute(
      "insert into itemTable(itemname,itemamount) values('itemD','100')");
  await db.execute(
      "insert into itemTable(itemname,itemamount) values('itemE','100')");
  await db.execute(
      "insert into itemTable(itemname,itemamount) values('itemF','100')");
  await db.execute(
      "insert into itemTable(itemname,itemamount) values('itemG','100')");
  // await db.insert('Product', <String, Object?>{'title': 'Product 1'});
  // await db.insert('Product', <String, Object?>{'title': 'Product 1'});
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeView(),
    );
  }
}
