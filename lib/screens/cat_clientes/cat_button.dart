import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/screens/cat_clientes/client_list.dart';
import 'package:disenart/screens/cat_clientes/new_client_item_list.dart';
import 'package:disenart/services/search.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/material.dart';

class CatButton extends StatefulWidget {
  @override
  _CatButtonState createState() => _CatButtonState();
}

var queryResultSetItems = [];
var tempSearchStoreItems = [];
TextEditingController _controller = TextEditingController();
FocusNode _focus = FocusNode();
String NewClientItemListTitle;

class _CatButtonState extends State<CatButton> {

  initiateItemSearch(value) {
    if (value.length == 0) {
      setState(() {
        searchingitem = false;
        queryResultSetItems = [];
        tempSearchStoreItems = [];
      });
    }
    if (queryResultSetItems.length == 0 && value.length == 1) {
      setState(() => searchingitem = true);
      SearchService().searchByItemName(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
          print('raw data: ${docs.documents[i].documentID}');
          queryResultSetItems.add(docs.documents[i].data);
          setState(() {
            c_item_id = docs.documents[i].documentID;
            tempSearchStoreItems.add(queryResultSetItems[i]);
          });
        }
        tempSearchStoreItems.sort((a, b) => a['iname'].compareTo(b['iname']));
        print(tempSearchStoreItems);
      });
    } else {
      tempSearchStoreItems = [];
      queryResultSetItems.forEach((element) {
        if (element['iname'].startsWith(value)) {
          setState(() {
            tempSearchStoreItems.add(element);
          });
        }
      });
    }
    if (tempSearchStoreItems.length == 0 && value.length > 1) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    _showNewClientItemListPanel(context) {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                child: Dialog(
                  insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 40,),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 90,),
                            Flexible(
                              flex: 3,
                              child: Center(
                                child: Text(
                                  !searchingitem?'Artículos Disponibles':'Búsqueda de Artículos Disponibles',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.only(right: 20, left: 20),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 30,
                              ),
                              onPressed: () async {
//                                _controller.clear();
//                                setState(() {
//                                  searchingitem = false;
//                                });
//                                await Future.delayed(Duration(milliseconds: 500));
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                        child: TextField(
                          focusNode: _focus,
                        controller: _controller,
                        style: TextStyle(fontSize: 20),
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
                              _focus.unfocus();
                              _controller.clear();
                              setState(() {
                                queryResultSetItems = [];
                                tempSearchStoreItems = [];
                                searchingitem = false;
                              });
                            }),
                        ),
                          onChanged: (val){
                            setState(() {
                              searchingitem = true;
                            });
                            initiateItemSearch(val);
                          },
                    ),
                      ),
                      NewClientItemList()
                    ],
                  ),
                ),
              );
              },
            );
          });
    }

      return isClientSelected?FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text(
          'Agregar Venta',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: CompanyColors.PrimaryColor,
        onPressed: () {
          return _showNewClientItemListPanel(context);
          },
      ):Text('');
  }
}
