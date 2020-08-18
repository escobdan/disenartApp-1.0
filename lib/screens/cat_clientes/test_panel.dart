import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/screens/cat_clientes/client_list.dart';
import 'package:disenart/services/database.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/material.dart';

class TestPanel extends StatefulWidget {
  @override
  _TestPanelState createState() => _TestPanelState();
}

String item_id;
String item_price;
String item_name;
bool selected;

List<String> itemsList;

class _TestPanelState extends State<TestPanel> {
//    QuerySnapshot snapshot = await cardRef.limit(10).getDocuments();
//    List<DocumentSnapshot> filtered = snapshot.documents.where((doc) => ... /* your filter goes here */ )
//    List<CustomCard> cards = filtered.map((doc) => CustomCard.fromDocument(doc)).toList();



  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return StreamBuilder(
      stream: Firestore.instance.collection('items').snapshots(),
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
                return _buildClientItemList(context, snapshot.data.documents[index], index);
              }),
        );
      },
    );
  }

  Widget _buildClientItemList(BuildContext context, DocumentSnapshot document, int index) {
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
            elevation: 15,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  height: 200,
                  width: 200,
                  child: Image(
                    image: AssetImage('assets/lego.png'),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
//                      color: Colors.grey[800].withOpacity(0.8),
//                      color: Colors.red[900].withOpacity(0.8),
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
        onTap: () {
          setState(() {
            selected = !selected;
          });
          print('$selected');
        },
        onLongPress: () {
          setState(() {
            item_id = document.documentID;
            print('$item_id');
          });
        },
      ),
    );
  }
}
