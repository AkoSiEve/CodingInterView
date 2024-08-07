import 'dart:developer';

import 'package:codingint/SQLite/db_helper.dart';
import 'package:codingint/SQLite/personsale.dart';
import 'package:codingint/SQLite/tempJson.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final DatabaseHelper db = DatabaseHelper();
  TextEditingController _namePersonController = TextEditingController();
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  soldButton() async {
    if (_namePersonController.text.isEmpty ||
        _itemNameController.text.isEmpty ||
        _amountController.text.isEmpty) {
      log("wala laman");
      return false;
    }
    var res = await db.createSale(PersonSale(
        personname: "${_namePersonController.text}",
        itemname: "${_itemNameController.text}",
        itemamount: int.parse(_amountController.text)));
    if (res > 0) {
      var del = await db.deleteTablePivot();
      if (del != []) {
        log("mag update ka");
        await db.updateTablePivot();
      }
      pivotDataTable = await db.fetchPivotTable();
      persoDataTable = await db.fetchPersonTable();
      setState(() {
        pivotDataTable = pivotDataTable;
        persoDataTable = persoDataTable;
        log("hahahahah${pivotDataTable}");
      });
      clearItemText();
    }
  }

  clearItemText() {
    _namePersonController.text = "";
    _itemNameController.text = "";
    _amountController.text = "";
    selectedValue = null;
  }

////
  fetchButton() async {
    await db.queryChecker();
  }

  ///REFRESH
  // late List<Map<String, dynamic>> tempTable;
  // refreshStudentList() {
  //   setState(() async {
  //     // tempTable = await db.fetchPivotTable();
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   refreshStudentList();
  // }

  List<Map<String, dynamic>> pivotDataTable = [{}];

  void initState() {
    super.initState();
    refreshSalesList();
    refreshPersonList();
    refreshItemList();
  }

  refreshSalesList() async {
    await db.deleteTablePivot();
    await db.updateTablePivot();
    List<Map<String, dynamic>> qweqweqwev1 = [{}];
    qweqweqwev1 = await db.fetchPivotTable();
    setState(() {
      pivotDataTable = qweqweqwev1;
    });
  }
////

  List<Map<String, dynamic>> persoDataTable = [{}];
  refreshPersonList() async {
    var temp = await db.fetchPersonTable();
    setState(() {
      // log("setsatestasdasd${temp}");
      persoDataTable = temp;
    });
  }

  ///
  deleteFunctionForPersonTable(String str) async {
    log("waht taht ${str}");
    final rs = await db.deleteByIdPersonTable(str);
    if (rs > 0) {
      var temp = await db.fetchPersonTable();
      await refreshSalesList();
      setState(() {
        // log("setsatestasdasd${temp}");
        persoDataTable = temp;
      });
    }
  }

  ///
  List<Map<String, dynamic>> itemDataTable = [{}];
  refreshItemList() async {
    var temp = await db.fetchItemTable();
    setState(() {
      itemDataTable = temp;
    });
  }

  String? selectedValue = null;

  ///
  showAlertUpdate(String? id, String? name, String? itmname, String? amount) {
    updatePersonTable(String? itmname, String? amount) async {
      if (itmname == "" || amount == "") {
        log("stopstop");
        return false;
      }

      final res = await db.updateByIdPersonTable(
          int.parse(id!), "${itmname}", "${amount}");
      if (res > 0) {
        await refreshSalesList();
        await refreshPersonList();
        log("chechechecheck mo na hahahaha");
      }
    }

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.pop(context, 'Cancel'),
    );
    Widget continueButton = TextButton(
      child: Text("Update"),
      onPressed: () {
        updatePersonTable(itmname, amount);
        // if (itmname == "") {
        // log("cxzcxzcxz ${id}");
        // log("cxzcxzcxz ${itmname}");
        // log("cxzcxzcxz ${amount}");
        // }
        Navigator.of(context).pop();
      },
    );
    String? selectedValue = "${itmname}";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update your Data"),
          content: Container(
            width: 300,
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Person ID : ${id}"),
                Text("Person Name : ${name}"),
                Row(
                  children: [
                    Text("Item Name : "),
                    // Text("${itmname}"),
                    Container(
                      width: 100,
                      height: 50,
                      child: DropdownButtonFormField<String>(
                        value: selectedValue,
                        onChanged: (String? value) {
                          setState(() {
                            // selectedValue = value!;
                            itmname = value!;
                            // _itemNameController.text = selectedValue!;
                          });
                        },
                        items: [
                          'itemA',
                          'itemB',
                          'itemC',
                          'itemD',
                          'itemE',
                          'itemF',
                          'itemG'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                // const SizedBox(width: 10),
                                Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("Item Amount : "),
                    Container(
                      width: 80,
                      height: 30,
                      // color: Colors.red,
                      child: TextField(
                          onChanged: (value) {
                            amount = value;
                            log("onchage onchage ${value}");
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "${amount}",
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
        ;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height / 2,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height / 2,
                    // width: MediaQuery.of(context).size.width / 2,
                    width: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Person Sales"),
                        Container(
                          height: 40,
                          padding: EdgeInsets.all(2),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                // color: Colors.red,
                                child: Text("Person Name"),
                              ),
                              Container(
                                width: 200,
                                child: TextField(
                                    controller: _namePersonController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter Person Name',
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.all(2),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text("Item Name"),
                              ),
                              Container(
                                width: 200,
                                child: DropdownButtonFormField<String>(
                                  value: selectedValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedValue = value!;
                                      _itemNameController.text = selectedValue!;
                                    });
                                  },
                                  items: [
                                    'itemA',
                                    'itemB',
                                    'itemC',
                                    'itemD',
                                    'itemE',
                                    'itemF',
                                    'itemG'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          // const SizedBox(width: 10),
                                          Text(value),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                                // child: DropdownButton(
                                //   value: selectedValue,
                                //   items: dropdownItems,
                                //   isExpanded: true,
                                //   onChanged: (String? newValue) {
                                //     setState(() {
                                //       log("${newValue}");
                                //       selectedValue = newValue!;
                                //     });
                                //   },
                                // ),
                                // child: TextField(
                                //     controller: _itemNameController,
                                //     decoration: InputDecoration(
                                //       border: OutlineInputBorder(),
                                //       hintText: 'Enter Item Name',
                                //     )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: EdgeInsets.all(2),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: Text("Amount"),
                              ),
                              Container(
                                width: 200,
                                child: TextField(
                                    controller: _amountController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Enter Amount',
                                    )),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () {
                              soldButton();
                            },
                            child: Container(
                              height: 55,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                // color: GlobalColors.mainColor,
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                  )
                                ],
                              ),
                              child: Text(
                                "Sold an Item",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            )),
                        // InkWell(
                        //     onTap: () {
                        //       fetchButton();
                        //     },
                        //     child: Text("fetch"))
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        // color: Colors.red,
                        width: 620,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Column(
                          children: [
                            Text(
                              "Person Sale Table",
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: DataTable(
                                    border: TableBorder.all(width: 3.0),
                                    columns: [
                                      DataColumn(label: Text("id")),
                                      DataColumn(label: Text("Name")),
                                      DataColumn(label: Text("Item Name")),
                                      DataColumn(label: Text("Amount")),
                                      DataColumn(label: Text("Delete")),
                                      DataColumn(label: Text("Update")),
                                    ],
                                    rows: persoDataTable
                                        .map((e) => DataRow(cells: [
                                              DataCell(Text(
                                                  e["personid"].toString() ??
                                                      "-")),
                                              DataCell(
                                                  Text(e["personname"] ?? "-")),
                                              DataCell(
                                                  Text(e["itemname"] ?? "-")),
                                              DataCell(Text(
                                                  e["itemamount"].toString() ??
                                                      "-")),
                                              DataCell(InkWell(
                                                onTap: () {
                                                  deleteFunctionForPersonTable(
                                                      e["personid"].toString());
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () {
                                                  // deleteFunctionForPersonTable(
                                                  //     e["personid"].toString());
                                                  var personid = e["personid"]
                                                          .toString() ??
                                                      null;
                                                  var personname =
                                                      e["personname"]
                                                              .toString() ??
                                                          null;
                                                  var itemname = e["itemname"]
                                                          .toString() ??
                                                      null;
                                                  var itemamount =
                                                      e["itemamount"]
                                                              .toString() ??
                                                          null;

                                                  showAlertUpdate(
                                                      personid,
                                                      personname,
                                                      itemname,
                                                      itemamount);
                                                },
                                                child: Icon(
                                                  Icons.update,
                                                  color: Colors.green,
                                                ),
                                              ))
                                            ]))
                                        .toList(),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 200,
                          // color: Colors.blue,
                          height: MediaQuery.of(context).size.height / 2,
                          child: Column(
                            children: [
                              Text(
                                "Item Table",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      border: TableBorder.all(width: 3.0),
                                      columns: [
                                        DataColumn(label: Text("id")),
                                        DataColumn(label: Text("Item Name"))
                                      ],
                                      rows: itemDataTable
                                          .map((e) => DataRow(cells: [
                                                DataCell(Text(
                                                    e["itemid"].toString() ??
                                                        "-")),
                                                DataCell(
                                                    Text(e["itemname"] ?? "-")),
                                              ]))
                                          .toList(),
                                    )),
                              ),
                            ],
                          ))
                    ],
                  )
                ],
              )),
          Container(
              // color: Colors.blue,
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: db.fetchPivotTable(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (!snapshot.hasData) {
                    return Text("if");
                  } else {
                    List<Map<String, dynamic>> data =
                        snapshot.data as List<Map<String, dynamic>>;
                    // return Text("else");
                    return Column(
                      children: [
                        Text(
                          "Pivot Table for Person Sale And itemTble",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        DataTable(
                          border: TableBorder.all(width: 3.0),
                          columns: [
                            DataColumn(label: Text("Sales Person")),
                            DataColumn(label: Text("itemA")),
                            DataColumn(label: Text("itemB")),
                            DataColumn(label: Text("itemC")),
                            DataColumn(label: Text("itemD")),
                            DataColumn(label: Text("itemE")),
                            DataColumn(label: Text("itemF")),
                            DataColumn(label: Text("itemG")),
                          ],
                          rows: pivotDataTable
                              .map((e) => DataRow(cells: [
                                    DataCell(Text(e["saleperson"] ?? "-")),
                                    DataCell(Text(e["itemA"] ?? "-")),
                                    DataCell(Text(e["itemB"] ?? "-")),
                                    DataCell(Text(e["itemC"] ?? "-")),
                                    DataCell(Text(e["itemD"] ?? "-")),
                                    DataCell(Text(e["itemE"] ?? "-")),
                                    DataCell(Text(e["itemF"] ?? "-")),
                                    DataCell(Text(e["itemG"] ?? "-")),
                                    // DataCell(Icon(Icons.delete))
                                  ]))
                              .toList(),
                        ),
                      ],
                    );
                  }
                },
              )),
        ],
      ),
    );
  }
}
