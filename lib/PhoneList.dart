import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'Rounded_Button.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;
class PhonesList extends StatefulWidget {
  static const String id = 'PhoneList_Screen';
  static String subcat='';
  @override
  _PhonesListState createState() => _PhonesListState();
}

class _PhonesListState extends State<PhonesList> {
  var ListOfPhones = [];
  var ListOfItems=[];
  var ImageLink;
  var upload='Choose the Item Image';
  var nameOfItem='';
  var PriceOfItem='';
  bool _saving = true;
  DateTime now ;
  var url = 'https://firestore.googleapis.com/v1/projects/phonestore-cf23e/databases/(default)/documents:runQuery';
  var list=[];
  var body = jsonEncode({
    "structuredQuery": {
      "from": [
        {
          "collectionId": "tele"
        }
      ],
      "where": {
        "fieldFilter": {
          "field": {
            "fieldPath": "subcat"
          },
          "op": "EQUAL",
          "value": {
            "stringValue": "Samsung"
          }
        }
      }
    },
  });
  Future delay() async{
    await new Future.delayed(new Duration(seconds: 5), ()
    {
      setState(() {
        _saving=false;
      });

    });
  }



  void getPhonesList() async {
    ListOfPhones.clear();
    try {


      var response = await http.post(url,body: body);
      var  data = json.decode(response.body);





      for(var msg in data) {
        final name = msg['document']['fields']['phonename']['stringValue'].toString();
        final price = msg['document']['fields']['price']['stringValue'];
        final image = msg['image'].toString();
        setState(() {
          ListOfPhones.add({'phonename': name, 'price': price, 'image': image});
          _saving=false;
        });
        ListOfPhones.sort((a, b) {
          return a['phonename'].toLowerCase().compareTo(b['phonename'].toLowerCase());
        });

      }
    }
    catch(e){
      print(e);
    }
  }

  Future<double> getqtt(String name) async {
    var qtts = [0.0];


    var url1 = 'https://firestore.googleapis.com/v1/projects/phonestore-cf23e/databases/(default)/documents:runQuery';
    var body1 = jsonEncode({
      "structuredQuery": {
        "from": [
          {
            "collectionId": "transaction"
          }
        ],
        "where": {
          "fieldFilter": {
            "field": {
              "fieldPath": "name"
            },
            "op": "EQUAL",
            "value": {
              "stringValue": name
            }
          }
        }
      },
    });

    var response = await http.post(url1,body: body1);
    var  data = json.decode(response.body);


    for (var msg in data) {
      final qtt = msg['document']['fields']['qtt']["doubleValue"];
      print(qtt);
      qtts.add(double.parse(qtt));
    }

    var result = qtts.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhonesList();
    delay();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.white,
            child: ModalProgressHUD(
              inAsyncCall: _saving,
              dismissible: true,
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(

                    actions: <Widget>[
                      IconButton(icon:Icon(Icons.add,color: Colors.black,),

                          onPressed:(){
                        var nn=1.0;
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(

                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        MaterialButton(

                                          onPressed: (){
                                            setState(() {


                                            },);
                                          },
                                          child: Text(upload,style: TextStyle(color: Colors.black),),
                                          elevation: 20,
                                          color: Colors.white,
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10,top: 10),
                                          child: TextField(
                                            keyboardType: TextInputType
                                                .emailAddress,
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              setState(() {
                                                nameOfItem = value;
                                              });
                                            },
                                            decoration:
                                            KTextFieldImputDecoration
                                                .copyWith(
                                                hintText:
                                                'Enter the Name Of Item'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10,top: 10),
                                          child: TextField(
                                            keyboardType: TextInputType
                                                .emailAddress,
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              setState(() {
                                                PriceOfItem =
                                                value;
                                              });
                                            },
                                            decoration:
                                            KTextFieldImputDecoration
                                                .copyWith(
                                                hintText:
                                                'Enter the Price Of Item in \$'),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10,top: 10),
                                          child: TextField(
                                            keyboardType: TextInputType
                                                .emailAddress,
                                            textAlign: TextAlign.center,
                                            onChanged: (value) {
                                              setState(() {
                                                nn =
                                                (double.parse(value));
                                              });
                                            },
                                            decoration:
                                            KTextFieldImputDecoration
                                                .copyWith(
                                                hintText:
                                                'Enter the Qtt'),
                                          ),
                                        ),
                                        MaterialButton(
                                            child: Text('Add',style: TextStyle(fontSize: 30,color: Colors.black),),
                                            onPressed: (){
//                                          _firestore.collection('tele').add({
//                                            'phonename':nameOfItem,
//                                            'price': PriceOfItem,
//                                            'image': ImageLink,
//                                            'INOUT': 'out',
//                                            'categories':'phones',
//                                            'subcat':PhonesList.subcat,
//                                          });
//                                          _firestore.collection('transaction').add({
//                                            'name': nameOfItem,
//                                            'categorie': 'phones',
//                                            'inout': 'in',
//                                            'qtt': nn,
//                                          });
//                                          getPhonesList();
                                          Navigator.of(context).pop();
                                        }),



                                      ],
                                    ),
                                  );
                                });


                      })
                    ],
                    title: Card(
                      elevation: 20,
                      color: Colors.white.withOpacity(0.0),
                      child: Text(
                        PhonesList.subcat,
                        style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: (){
                              var _n = -1.0;
                              var _price = 0.0;
                              var currency = 'L.L';
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.white,

                                      content: Card(


                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
//                                            Expanded(
//                                              child: Container(
//                                                child: CachedNetworkImage(
//                                                  imageUrl:
//                                                  ListOfPhones[index]
//                                                  ['image'],
//                                                ),
//                                                color: Colors.black,
//                                              ),
//                                            ),
                                            Text(
                                              ListOfPhones[index]
                                              ['phonename'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              '${ListOfPhones[index]['price'].toString()} \$',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            Expanded(
                                              child: FutureBuilder(
                                                  builder:
                                                      (BuildContext context,
                                                      AsyncSnapshot<double>
                                                      qttnumbr) {
                                                    return Center(
                                                      child: Text(
                                                        'Available : ${qttnumbr.data}',style: TextStyle(color:Colors.black),
                                                      ),
                                                    );
                                                  },
                                                  initialData: 1.0,
                                                  future: getqtt(
                                                      ListOfPhones[index]
                                                      ['phonename'])),
                                            ),
                                            Text('Enter Your Qtt',style: TextStyle(color: Colors.black),),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10,top: 2),
                                              child: TextField(
                                                keyboardType: TextInputType
                                                    .emailAddress,
                                                textAlign: TextAlign.center,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _n = -(double.parse(value));
                                                  });
                                                },
                                                decoration:
                                                KTextFieldImputDecoration
                                                    .copyWith(
                                                  hintText:
                                                  'Enter Your Qtt',),
                                              ),
                                            ),
                                            Text('Enter Your price',style: TextStyle(color: Colors.black),),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10,top: 2),
                                              child: TextField(
                                                keyboardType: TextInputType
                                                    .emailAddress,
                                                textAlign: TextAlign.center,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _price =
                                                    (double.parse(value));
                                                  });
                                                },
                                                decoration:
                                                KTextFieldImputDecoration
                                                    .copyWith(
                                                    hintText:
                                                    'Enter Your Price'),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: CustomRadioButton(
                                                buttonColor: Colors.white,


                                                buttonLables: [

                                                  'L.L',
                                                  '\$',

                                                ],
                                                buttonValues: [
                                                  'L.L',
                                                  '\$',
                                                ],
                                                radioButtonValue: (value) {
                                                  setState(() {
                                                    currency = value;
                                                  });
                                                },
                                                selectedColor: Colors.black54,


                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: MaterialButton(
                                                child: Text('Sell',style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),),
                                                onPressed: () {
                                                  return showDialog(
                                                    context: context,
                                                    builder:(BuildContext context) {
                                                     return AlertDialog(
                                                        title: Text(
                                                            'Are You Sure to Sell ${ListOfPhones[index]
                                                            ['phonename']}'),
                                                        actions: <Widget>[
                                                          MaterialButton(
                                                            child: Text(
                                                                'cancel'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          MaterialButton(
                                                            child: Text('yes'),
                                                            onPressed: () {
//                                                              _firestore
//                                                                  .collection(
//                                                                  'transaction')
//                                                                  .add({
//                                                                'name':
//                                                                ListOfPhones[index]['phonename'],
//                                                                'qtt': _n,
//                                                                'price': _price,
//                                                                'timestamp':
//                                                                DateTime.now(),
//                                                                'currency': currency,
//                                                              });
//                                                              setState(() {
//                                                                getqtt(
//                                                                    ListOfPhones[index]['phonename']);
//                                                              });
//                                                              Navigator.of(
//                                                                  context)
//                                                                  .pop();
//                                                              Navigator.of(
//                                                                  context)
//                                                                  .pop();
                                                            },
                                                          ),


                                                        ],
                                                      );

                                                    }
                                                  );


                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 20,
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
//                                    Expanded(
//                                      child: Container(
//                                        child: Padding(
//                                          padding: const EdgeInsets.all(2.0),
//                                          child: CachedNetworkImage(
//                                            imageUrl: ListOfPhones[index]['image'],fit: BoxFit.fill,
//                                          ),
//                                        ),
//                                      ),
//                                    ),
                                    Expanded(
                                      child: Text(
                                        ListOfPhones[index]['phonename'],
                                        style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      '${ListOfPhones[index]['price'].toString()} \$',
                                      style:
                                          TextStyle(fontSize: 16, color: Colors.green),
                                    ),
                                    FutureBuilder(
                                        builder: (BuildContext context,
                                            AsyncSnapshot<double> qttnumbr) {
                                          return Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Available:'),
                                                Text(
                                                  '${qttnumbr.data}',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        initialData: 1.0,
                                        future:
                                            getqtt(ListOfPhones[index]['phonename'])),

                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: ListOfPhones.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        ///no.of items in the horizontal axis
                        crossAxisCount:4,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
