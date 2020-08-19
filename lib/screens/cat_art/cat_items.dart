import 'package:disenart/screens/cat_art/new_item.dart';
import 'package:disenart/screens/home/item_list.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/material.dart';

class Cat_Items extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery
        .of(context)
        .orientation;

    _showNewItemPanel(context) {
      return showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                    child: SingleChildScrollView(
                      child: Dialog(
                        insetPadding: EdgeInsets.symmetric(
                          horizontal:
                          (orientation == Orientation.landscape) ? 150 : 150,
                          vertical: (orientation == Orientation.landscape)
                              ? 100
                              : 20,
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
                              height: 65,
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    flex: 3,
                                    child: Center(
                                      child: Text(
                                        'Registra nuevo artículo',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.only(right: 20),
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
                            NewItem(),
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: CompanyColors.PrimaryColor,
        title: Text('Catalogo de Artículos'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text(
          'Nuevo artículo',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: CompanyColors.PrimaryColor,
        onPressed: () => _showNewItemPanel(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: ItemList(),
      ),
    );
  }
}
