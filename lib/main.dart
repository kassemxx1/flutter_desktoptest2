import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_desktoptest2/PhoneList.dart';
import 'package:http/http.dart' as http;

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());}

class MyApp extends StatelessWidget {
  static const String id = 'PhoneList_Screen';
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MyApp.id,
      routes: {
        PhonesList.id :(context) => PhonesList(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
var text1='kassem';
var texts=[];
var url = 'https://firestore.googleapis.com/v1/projects/phonestore-cf23e/databases/(default)/documents:runQuery';
var list=[];
var body = jsonEncode({
  "structuredQuery": {
    "from": [
      {
        "collectionId": "transaction"
      }
    ],
    "where": {
      "fieldFilter": {
        "field": {
          "fieldPath": "client"
        },
        "op": "EQUAL",
        "value": {
          "stringValue": "zeinab ghandur"
        }
      }
    }
  },
});
void gethttp() async{
  var hhh=[];
  var response = await http.post(url,body: body);
 var  data = json.decode(response.body);
//  var qtt = jsonDecode(data[0]['document'][0]['fields']);
//  print(qtt);
for(var p in data){
  final price=p['document']['fields']['price']['doubleValue'];
  final debt=p['document']['fields']['debt']['doubleValue'];
  setState(() {
    hhh.add(-price);
    hhh.add(debt);
  });
}
print(hhh);
}







@override
  void initState() {
    // TODO: implement initState
    super.initState();
    gethttp();

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(title: Text('kassem'),),
      body: Center(
        child: Container(
          child:Center(child: MaterialButton(onPressed:() {
            Navigator.pushNamed(context, PhonesList.id);

          },
          child: Text('GO'),)),
        ),
      ),
    );
  }
}
