import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

alertSaveItem(BuildContext context) {
  return Flushbar(
    padding: EdgeInsets.all(15),
    backgroundColor: Colors.green[500],
    messageText: Center(child: Text('Artículo registrado exisosamente', style: TextStyle(fontSize: 20, color: Colors.white),)),
    borderRadius: 8,
    duration: Duration(seconds: 2),
  ).show(context);
}

alertAddItem(BuildContext context) {
  return Flushbar(
    padding: EdgeInsets.all(15),
    backgroundColor: Colors.green[500],
    messageText: Center(child: Text('Artículo agregado a cliente', style: TextStyle(fontSize: 20, color: Colors.white),)),
    borderRadius: 8,
    duration: Duration(seconds: 1),
  ).show(context);
}

alertSaveClient(BuildContext context){

  return Flushbar(
    padding: EdgeInsets.all(15),
    backgroundColor: Colors.green[500],
    messageText: Center(child: Text('Cliente registrado exisosamente', style: TextStyle(fontSize: 20, color: Colors.white),)),
    borderRadius: 8,
    duration: Duration(seconds: 2),
  ).show(context);
}
