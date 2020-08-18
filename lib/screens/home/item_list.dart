import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:disenart/shared/alert_delete.dart';
import 'package:disenart/shared/constants.dart';
import 'package:intl/intl.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

String item_name;
String item_price;
String item_id;

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return StreamBuilder(
      stream: Firestore.instance.collection('items').orderBy('iname', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Cargando artículos...');
        return GridView.builder(
            itemCount: snapshot.data.documents.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.landscape) ? 4 : 3),
            itemBuilder: (context, index) {
              return _buildItemList(context, snapshot.data.documents[index], index);
            });
      },
    );
  }

  Widget _buildItemList(BuildContext context, DocumentSnapshot document, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      child: GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(3, 0, 3, 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(
              color: index%2==0?CompanyColors.PrimaryAssentColor:Colors.grey[800],
              width: 2,
            ),
          ),
          color: Colors.white,
          elevation: 0,
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  child: Image.network(
                    document['imageurl'],
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  color: Colors.grey[200].withOpacity(0.9),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                    title: Text(
                      document['iname'],
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    subtitle: Text(
                      (document['price']),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onLongPress: () {
        setState(() {
          item_name = document['iname'];
          item_price = document['price'];
          item_id = document.documentID;
          print('$item_name, $item_price, $item_id');
        });
        return alertDeleteItem(context);
      },
    ),
    );
  }
}
