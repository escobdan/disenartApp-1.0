import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/screens/home/item_list.dart';
import 'package:flutter/material.dart';
import 'package:disenart/screens/cat_clientes/client_list.dart';
import 'package:flushbar/flushbar.dart';
import 'package:disenart/services/database.dart';
import 'package:disenart/screens/cat_clientes/new_client_item_list.dart';

bool notactive = false;

alertDeleteItem(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(
      "Cancelar",
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Eliminar",
      style: TextStyle(fontSize: 18, color: Colors.red),
    ),
    onPressed: () {
      itemCollection.document(item_id).delete();
      Navigator.pop(context);
      itemDeletedFlushbar(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    title: Text('$item_name'),
    content: Text(
      "Eliminar articulo?",
      style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          cancelButton,
          SizedBox(width: 100,),
          continueButton,
        ],
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

alertDeleteClientItem(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(
      "Cancelar",
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Desactivar",
      style: TextStyle(fontSize: 18, color: Colors.black),
    ),
    //TODO option to reactivate item
    onPressed: () {
      clientItemListCollection.document('${c_item_id}').updateData({
        'active': notactive,
      });
      Navigator.pop(context);
      itemDeletedFlushbar(context);
    },
  );
  Widget eraseButton = FlatButton(
    child: Text(
      "Eliminar",
      style: TextStyle(fontSize: 18, color: Colors.red),
    ),
    onPressed: () {
      clientItemListCollection.document('${c_item_id}').delete();
      var val=[];
      val.add(c_item_id);
      clientCollection.document('$client_id').updateData({
        'item_list': FieldValue.arrayRemove(val),
      });
      val.removeRange(0, val.length-1);
      Navigator.pop(context);
      itemDeletedFlushbar(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    title: Text('${c_item_name}'),
    content: Text(
      "Desactivar Articulo?",
      style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          cancelButton,
          SizedBox(width: 50,),
          continueButton,
          SizedBox(width: 50,),
          eraseButton,
        ],
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

alertDeleteClient(BuildContext context){
  print('$client_id, $client_name, $client_phone');
  Widget cancelButton = FlatButton(
    child: Text(
      "Cancelar",
      style: TextStyle(fontSize: 18),
    ),
    onPressed: () async {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Eliminar",
      style: TextStyle(fontSize: 18, color: Colors.red),
    ),
    onPressed: () async {
      await clientCollection.document(client_id).collection('item_list').getDocuments().then((snapshot){
        for (DocumentSnapshot ds in snapshot.documents){
          ds.reference.delete();
          print('deleted item, id: ${ds.documentID}');
        }
      });
      clientCollection.document(client_id).delete();
      print('deleted client');
      Navigator.pop(context);
      clientDeletedFlushbar(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    title: Text("$client_name"),
    content: Text(
      "Eliminar cliente?",
      style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          cancelButton,
          SizedBox(width: 100,),
          continueButton,
        ],
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

clientDeletedFlushbar(BuildContext context){
  return Flushbar(
    padding: EdgeInsets.all(15),
    messageText: Center(child: Text('Cliente eliminado', style: TextStyle(fontSize: 20, color: Colors.grey[300]),)),
    borderRadius: 8,
    duration: Duration(milliseconds: 1500),
  ).show(context);
}
itemDeletedFlushbar(BuildContext context){
  return Flushbar(
    padding: EdgeInsets.all(15),
    messageText: Center(child: Text('Artículo eliminado', style: TextStyle(fontSize: 20, color: Colors.grey[300]),)),
    borderRadius: 8,
    duration: Duration(milliseconds: 1500),
  ).show(context);
}
