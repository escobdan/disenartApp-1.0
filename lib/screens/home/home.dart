import 'package:disenart/screens/cat_clientes/cat_client.dart';
import 'package:disenart/services/auth.dart';
import 'package:disenart/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:disenart/shared/constants.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  bool loading = false;

  _cancelLoading() {
    return setState(() {
      loading = false;
    });
  }

  _startLoading() {
    return setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
//    SizeConfig().init(context);
    return loading
        ? Loading()
        : Container(
            color: Colors.white,
            child: ButtonTheme(
              minWidth: 265,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              height: 100,
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    width: 400.0,
                    height: 300.0,
                    image: AssetImage('assets/logo_disenart.png'),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        color: CompanyColors.PrimaryColor,
                        textColor: Colors.white,
                        splashColor: Colors.redAccent,
                        child: Text('Catalogo de Clientes',
                            style: TextStyle(fontSize: 22)),
                        onPressed: () async {
                          _startLoading();
                          dynamic result =
                              await Navigator.pushNamed(context, '/cat_client');
                          _cancelLoading();
                        },
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      RaisedButton(
                        color: CompanyColors.PrimaryAssentColor,
                        textColor: Colors.white,
                        splashColor: Colors.redAccent,
                        child: Text('Catalogo de articulos',
                            style: TextStyle(fontSize: 22)),
                        onPressed: () async {
                          _startLoading();
                          dynamic result =
                              await Navigator.pushNamed(context, '/cat_items');
                          _cancelLoading();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      RaisedButton(
//                        child: Text('Estatus de entregas'),
//                      ),
//                      SizedBox(
//                        width: 30,
//                      ),
//                      RaisedButton(
//                        child: Text('Catalogo de Clientes'),
//                      ),
//                    ],
//                  ),
                ],
              ),
            ),
          );
  }
}
