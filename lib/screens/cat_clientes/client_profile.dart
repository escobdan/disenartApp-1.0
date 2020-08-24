import 'package:disenart/screens/cat_clientes/client_item_list.dart';
import 'package:disenart/screens/cat_clientes/client_list.dart';
import 'package:disenart/screens/cat_clientes/edit_client.dart';
import 'package:disenart/screens/cat_clientes/test_panel.dart';
import 'package:disenart/shared/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ClientProfile extends StatefulWidget {
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

bool activeItems = true;

class _ClientProfileState extends State<ClientProfile> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    printUrl() async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child("itemImages/TemploSanMiguel.jfif");
    String url = (await ref.getDownloadURL()).toString();
    print('url: $url');
}

_showEditClientPanel(context) {
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
                                  'Editar cliente',
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
                      EditClient(),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    return StreamBuilder<String>(
        stream: clientprofilestream,
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: CompanyColors.PrimaryAssentColor,
                    child: Text(
                      '${client_name.substring(0,1)}',
                      textScaleFactor: 1.5,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      client_name == null
                          ? 'Selecciona un cliente'
                          : '$client_name',
                      style: TextStyle(
                        fontSize:
                            (orientation == Orientation.landscape) ? 24 : 22,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  isClientSelected
                      ? IconButton(
                          iconSize:
                              (orientation == Orientation.landscape) ? 26 : 24,
                          icon: Icon(Icons.edit),
                          onPressed: (){
                          _showEditClientPanel(context);
                          },
                        )
                      : SizedBox(
                          width: 26,
                        )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Telefono',
                        style: TextStyle(
                            fontSize: 16,
                            color: CompanyColors.PrimaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      VerticalDivider(
                        width: (orientation == Orientation.landscape)
                            ? 188.0
                            : 93.0,
                        thickness: 5.0,
                      ),
                      Text(
                        'Correo',
                        style: TextStyle(
                            fontSize: 16,
                            color: CompanyColors.PrimaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        width: 100.0,
                      ),
                      Switch(
                        activeColor: CompanyColors.PrimaryAssentColor,
                        value: activeItems,
                        onChanged: (value) {
                          setState(() {
                            activeItems = value;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width:
                            (orientation == Orientation.landscape) ? 260 : 165,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                          ),
                          child: Text(
                            client_phone == null ? ' -' : '$client_phone',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                letterSpacing: 1),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          client_email == 'null' ? '-' : '$client_email',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                height: 25,
                thickness: 2,
                endIndent: 10,
              ),
              ci_list == null
                  ? Text('')
                  : Expanded(
                      child: ClientItemList(),
                    ),
            ],
          );
        });
  }
}
