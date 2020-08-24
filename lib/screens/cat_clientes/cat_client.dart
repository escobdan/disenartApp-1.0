import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/screens/cat_clientes/cat_button.dart';
import 'package:disenart/screens/cat_clientes/client_profile.dart';
import 'package:disenart/screens/cat_clientes/new_client.dart';
import 'package:disenart/screens/cat_clientes/new_client_item_list.dart';
import 'package:disenart/services/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:disenart/shared/constants.dart';
import 'package:disenart/screens/cat_clientes/client_list.dart';

// ignore: camel_case_types
class Cat_Client extends StatefulWidget {
  @override
  _Cat_ClientState createState() => _Cat_ClientState();
}

var queryResultSet = [];
var tempSearchStore = [];
TextEditingController _controller = TextEditingController();
FocusNode focus = FocusNode();

String _queryText;

// ignore: camel_case_types
class _Cat_ClientState extends State<Cat_Client> {
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        searching = false;
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    if (queryResultSet.length == 0 && value.length == 1) {
      setState(() => searching = true);
      SearchService().searchByName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          print('raw data: ${docs.documents[i].documentID}');
          queryResultSet.add(docs.documents[i].data);
          setState(() {
            client_id = docs.documents[i].documentID;
            tempSearchStore.add(queryResultSet[i]);
          });
        }
        tempSearchStore.sort((a, b) => a['name'].compareTo(b['name']));
        print(tempSearchStore);
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['name'].startsWith(value)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
    if (tempSearchStore.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    _showNewClientPanel(context) {
      return showDialog(
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Dialog(
                  insetPadding: EdgeInsets.symmetric(
                    horizontal:
                        (orientation == Orientation.landscape) ? 270 : 120,
                    vertical: (orientation == Orientation.landscape) ? 100 : 70,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
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
                          children: <Widget>[
                            SizedBox(
                              width: 45,
                            ),
                            Flexible(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  'Registra nuevo cliente',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.only(right: 20),
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  selected = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      NewClient(),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Catalogo de Clientes'),
        backgroundColor: CompanyColors.PrimaryColor,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.add),
            textColor: Colors.white,
            label: Text(
              'Nuevo Cliente',
              style: TextStyle(fontSize: 15),
            ),
            onPressed: () => _showNewClientPanel(context),
          ),
        ],
      ),
      body: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(width: 20),
            ],
          ),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextField(
                  autofocus: false,
                  focusNode: focus,
                  controller: _controller,
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                  textCapitalization: TextCapitalization.words,
                  decoration: textInputDecoration.copyWith(
                      prefixIcon: Icon(
                        Icons.search,
                        color: CompanyColors.PrimaryAssentColor,
                      ),
                      hintText: 'Buscar',
                      suffixIcon: IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey,),
                          onPressed: () {
                            focus.unfocus();
                            _controller.clear();
                            setState(() {
                              queryResultSetItems = [];
                              tempSearchStoreItems = [];
                              searching = false;
                            });
                          })),
                  onChanged: (val) {
                    initiateSearch(val);
                  },
                ),
                Expanded(
                  child: SizedBox(
                    child: ClientList(),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            width: 40,
            thickness: 2,
            color: Colors.grey,
          ),
          Flexible(
            flex: 4,
            child: ClientProfile(),
          ),
        ],
      ),
      floatingActionButton: CatButton(),
    );
  }
}
