import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/screens/cat_clientes/cat_button.dart';
import 'package:disenart/screens/cat_clientes/client_list.dart';
import 'package:disenart/services/database.dart';
import 'package:disenart/services/search.dart';
import 'package:disenart/shared/alert_save.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewClientItemList extends StatefulWidget {
  @override
  _NewClientItemListState createState() => _NewClientItemListState();
}

String c_item_id;
int c_item_price = 0;
String original_price_string;
int original_price = 0;
String c_item_name;
String c_item_imageurl;
String searchClientItem_id;
int c_item_cant = 0;
List<String> c_item_list = [];
List<String> temp_list = [];
bool selected = false;
bool searchingitem = false;
bool price_changed = false;
Timestamp c_item_timestamp;
int subtraction = c_item_price - original_price;
double percent = ((c_item_price / original_price * 100).roundToDouble());

final DateTime now = DateTime.now();
final DateFormat nowFormatter = DateFormat('dd/MM/yyyy');

List<dynamic> newSaleList = [];

class _NewClientItemListState extends State<NewClientItemList> {
  DateTime selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          builder: (context, Widget child) {
            return Theme(
              data: ThemeData(
                primaryColor: CompanyColors.PrimaryAssentColor,
                accentColor: Colors.grey[700],
                colorScheme: ColorScheme.light(
                    primary: CompanyColors.PrimaryAssentColor),
              ),
              child: child,
            );
          },
          firstDate: DateTime(2018, 8),
          lastDate: DateTime(2101));
//      if (picked != null && picked != selectedDate)
      if (picked == null) {
        return;
      }
      setState(() {
        selectedDate = picked;
      });
      print('${nowFormatter.format(selectedDate)}');
    }

    _getNewItemList(context) {
      return clientCollection.document(client_id).get().then((data) {
        ci_list = List.from(data['item_list']);
        print('ci_list = $ci_list');
      });
    }

    _showNewItemDetails(context) {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: Dialog(
                      insetPadding: EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 100,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: CompanyColors.PrimaryColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              width: double.infinity,
                              height: 75,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 90,
                                  ),
                                  Flexible(
                                    flex: 3,
                                    child: Center(
                                      child: Text(
                                        '${c_item_name}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding:
                                        EdgeInsets.only(right: 20, left: 20),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Container(
                                    height: 300,
                                    width: 300,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        c_item_imageurl,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: SizedBox(
                                            child: DecoratedBox(
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20.0,
                                                            15.0,
                                                            20.0,
                                                            15.0),
                                                    child: Text(
//                                        '${selectedDate.toLocal()}'.split(' ')[0],
                                                      '${nowFormatter.format(selectedDate)}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(Icons.date_range),
                                                ],
                                              ),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                    color: CompanyColors
                                                        .PrimaryAssentColor,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                color: Colors.white,
                                              ),
                                            ),
                                            width: 170.0,
                                          ),
                                          onTap: () async {
                                            await _selectDate(context);
                                            setState(() {
                                              selectedDate = selectedDate;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: 30.0,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Text(
                                                  '\$',
                                                  style:
                                                      TextStyle(fontSize: 24),
                                                ),
                                              ),
                                            SizedBox(
                                              width: 142.0,
                                              child: TextFormField(
                                                initialValue:
                                                    '${original_price}',
                                                decoration: textInputDecoration
                                                    .copyWith(
                                                        hintText: 'Precio'),
                                                textInputAction:
                                                    TextInputAction.next,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  WhitelistingTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (val) => val.isEmpty
                                                    ? 'Ingresa un precio'
                                                    : null,
                                                onChanged: (val) {
                                                  setState(() {
                                                    c_item_price =
                                                        int.parse(val);
                                                    price_changed = true;
                                                  });
                                                },
                                                onFieldSubmitted: (v) {
                                                  FocusScope.of(context)
                                                      .requestFocus(focus);
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                         SizedBox(
                                          height: 30.0,
                                        ),
                                        SizedBox(
                                          width: 170.0,
                                          child: TextFormField(
                                            focusNode: focus,
                                            decoration: textInputDecoration
                                                .copyWith(hintText: 'Cantidad'),
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
                                            validator: (val) => val.isEmpty
                                                ? 'Ingresa una cantidad'
                                                : null,
                                            onChanged: (val) => setState(() =>
                                                c_item_cant = int.parse(val)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlatButton(
                                color: CompanyColors.PrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Agregar Venta',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    price_changed == true
                                        ? print('price changed')
                                        : c_item_price = original_price;
                                    c_item_timestamp =
                                        Timestamp.fromDate(selectedDate);
                                    newSaleList.add({
                                      'price': c_item_price,
                                      'cant': c_item_cant,
                                      'date': c_item_timestamp,
                                    });
                                    print('sales list $newSaleList');
                                    print('before adding: ${c_item_list}');
                                    c_item_list.add(c_item_id);
                                    print('after adding: ${c_item_list}');
                                    _getNewItemList(context);
                                    ci_list.contains(c_item_id)
                                        ? clientCollection
                                            .document(client_id)
                                            .collection('item_list')
                                            .document(c_item_id)
                                            .updateData({
                                            'sales': FieldValue.arrayUnion(
                                                newSaleList),
                                            'active': true,
                                          })
                                        : clientCollection
                                            .document(client_id)
                                            .collection('item_list')
                                            .document(c_item_id)
                                            .setData({
                                            'iname': '${c_item_name}',
                                            'sales': FieldValue.arrayUnion(
                                                newSaleList),
                                            'imageurl': c_item_imageurl,
//                                  'price': '\$${c_item_price}.00',
//                                  'cant': c_item_cant,
                                            'active': true,
//                    'date': DateTime.now(),
                                          });
                                    ci_list.contains(c_item_id)
                                        ? print('item exists, only adding date')
                                        : clientCollection
                                            .document(client_id)
                                            .updateData({
                                            'item_list': FieldValue.arrayUnion(
                                                c_item_list),
                                          });
                                    //add updated list
                                    c_item_list.removeLast();
                                    newSaleList.removeLast();
                                    print(
                                        'after clearing: itemList:${c_item_list}, salesList: $newSaleList');
                                    Navigator.pop(context);
                                    alertAddItem(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          });
    }

    Widget _buildClientItemList(
        BuildContext context, DocumentSnapshot document, int index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: Card(
              margin: EdgeInsets.fromLTRB(3, 0, 3, 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: index % 2 == 0
                      ? CompanyColors.PrimaryAssentColor
                      : Colors.grey[700],
                  width: 2,
                ),
              ),
              color: Colors.white,
              elevation: 6,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        document['imageurl'],
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                        title: Text(
                          document['iname'],
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        subtitle: Text(
                          document['price'],
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () async {
            setState(() {
              c_item_id = document.documentID;
              c_item_name = document['iname'];
              original_price_string = document['price'];
              c_item_imageurl = document['imageurl'];
              original_price = int.parse(original_price_string.substring(
                  1, original_price_string.length - 3));
//              temp_list = List.from(clientCollection.document['item_list']);
            });
            await _getNewItemList(context);
            print('lista actualizada: $ci_list');
            _showNewItemDetails(context);
            print(
                '$c_item_id, $c_item_name, $c_item_price, $original_price_string, $original_price');
          },
          //for debug only
          onLongPress: () {
            setState(() {
              c_item_id = document.documentID;
              print('$c_item_id');
            });
          },
        ),
      );
    }

    gettingItemID(context) async {
      await SearchService()
          .searchByFullItemName(c_item_name)
          .then((QuerySnapshot docs) {
        setState(() {
          searchClientItem_id = docs.documents[0].documentID;
          print(
              'item id from click: $searchClientItem_id with item name: $c_item_name');
        });
      });
    }

//add for next update?
    Widget _buildClientItemListSearch(document) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: GestureDetector(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: Card(
                  margin: EdgeInsets.fromLTRB(3, 0, 3, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: CompanyColors.PrimaryAssentColor,
                      width: 2,
                    ),
                  ),
                  color: Colors.white,
                  elevation: 6,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        height: 200,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            document['imageurl'],
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 0),
                            title: Text(
                              document['iname'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 17),
                            ),
                            subtitle: Text(
                              document['price'],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                setState(() {
                  c_item_id = document.documentID;
                  c_item_name = document['iname'];
                  original_price_string = document['price'];
                  c_item_imageurl = document['imageurl'];
                  original_price = int.parse(original_price_string.substring(
                      1, original_price_string.length - 3));
//              temp_list = List.from(clientCollection.document['item_list']);
                });
                await _getNewItemList(context);
                print('lista actualizada: $ci_list');
                _showNewItemDetails(context);
                print(
                    '$c_item_id, $c_item_name, $c_item_price, $original_price_string, $original_price');
              },
              //for debug only
              onLongPress: () {
                setState(() {
                  c_item_id = document.documentID;
                  print('$c_item_id');
                });
              },
            ),
          );
        },
      );
    }

    //ORIGINAL DONT CHANGE
//    return StreamBuilder(
//      stream: Firestore.instance.collection('items').orderBy('iname').snapshots(),
//      builder: (context, snapshot) {
//        if (!snapshot.hasData) return const Text('Cargando artículos...');
//        return Padding(
//          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
//          child: GridView.builder(
//              shrinkWrap: true,
//              itemCount: snapshot.data.documents.length,
//              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                  crossAxisCount:
//                      (orientation == Orientation.landscape) ? 6 : 4),
//              itemBuilder: (context, index) {
//                return _buildClientItemList(
//                    context, snapshot.data.documents[index], index);
//              }),
//        );
//      },
//    );

    //Kinda works
    if (!searchingitem) {
      return StreamBuilder(
        stream:
            Firestore.instance.collection('items').orderBy('iname').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Cargando artículos...');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (orientation == Orientation.landscape) ? 6 : 4),
                itemBuilder: (context, index) {
                  return _buildClientItemList(
                      context, snapshot.data.documents[index], index);
                }),
          );
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GridView.count(
            crossAxisCount: (orientation == Orientation.landscape) ? 6 : 4,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: tempSearchStoreItems.map((element) {
              return _buildClientItemListSearch(element);
            }).toList()),
      );
    }

//    //testing currently
//    if (searchingitem) {
//      return Padding(
//        padding: const EdgeInsets.symmetric(horizontal: 8.0),
//        child: GridView.count(
//            crossAxisCount: (orientation == Orientation.landscape) ? 6 : 4,
//            scrollDirection: Axis.vertical,
//            shrinkWrap: true,
//            children: tempSearchStoreItems.map((element) {
//              return _buildClientItemListSearch(element);
//            }).toList()),
//      );
//    } else {
//      return StreamBuilder(
//        stream:
//            Firestore.instance.collection('items').orderBy('iname').snapshots(),
//        builder: (context, snapshot) {
//          if (!snapshot.hasData) return const Text('Cargando artículos...');
//          return Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 8.0),
//            child: GridView.builder(
//                shrinkWrap: true,
//                itemCount: snapshot.data.documents.length,
//                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                    crossAxisCount:
//                        (orientation == Orientation.landscape) ? 6 : 4),
//                itemBuilder: (context, index) {
//                  return _buildClientItemList(
//                      context, snapshot.data.documents[index], index);
//                }),
//          );
//        },
//      );
//    }

  }
}
