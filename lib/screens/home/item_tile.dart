import 'package:disenart/screens/home/item_list.dart';
import 'package:disenart/shared/alert_delete.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatefulWidget {
  @override
  _ItemTileState createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return Text('test');
//    return GestureDetector(
//      child: Padding(
//        padding: const EdgeInsets.only(right: 10.0),
//        child: Card(
//          margin: EdgeInsets.fromLTRB(3, 0, 3, 20),
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(15.0),
//            side: BorderSide(
//              color: CompanyColors.PrimaryAssentColor,
//              width: 2,
//            ),
//          ),
//          color: Colors.white,
//          elevation: 0,
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//            children: <Widget>[
//              ListTile(
//                title: Text(
//                  '${example_genil[2]}',
//                  style: TextStyle(color: Colors.black),
//                ),
//                subtitle: Text(
//                  'Precio Articulo uno',
//                  style: TextStyle(color: Colors.black),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//      onLongPress: () {
//        setState(() {
//          item_name = document['iname'];
//          item_price = document['price'];
//          item_id = document.documentID;
//          print('$item_name, $item_price, $item_id');
//        });
//        return alertDeleteItem(context);
//      },
//    );
  }
}
