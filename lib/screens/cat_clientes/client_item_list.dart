import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/screens/cat_clientes/client_list.dart';
import 'package:disenart/screens/cat_clientes/client_profile.dart';
import 'package:disenart/screens/cat_clientes/item_details_fixed.dart';
import 'package:disenart/screens/cat_clientes/new_client_item_list.dart';
import 'package:disenart/shared/alert_delete.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientItemList extends StatefulWidget {
  @override
  _ClientItemListState createState() => _ClientItemListState();
}

final _formKey = GlobalKey<FormState>();
final numFormatter = NumberFormat('###,###,###');
int totalVentas = 0;
int totalCant = 0;

//TODO add DateFormat("yyyy-MM-dd").format(DateTime.now()) to see when item was added

class _ClientItemListState extends State<ClientItemList> {
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    _getItemDetailsLists(context) {
      return Firestore.instance
          .collection('clients/$client_id/item_list')
          .document(c_item_id)
          .get()
          .then((data) {
        sales = List.from(data['sales']);
        print('sales: $sales');
        for (var i = 0; i < sales.length; i++) {
          int _currentPrice = sales[i]['price'];
          int _currentCant = sales[i]['cant'];
          totalVentas += (_currentPrice * _currentCant);
          totalCant += _currentCant;
          print('cant: $totalCant, ventas: $totalVentas');
        }
        sales.sort((b, a) => a['date'].compareTo(b['date']));
        print('ordered sales: $sales');
      });
    }

    _showItemDetails(context) {
      return showDialog(
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Dialog(
                insetPadding: EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 50,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 90,
                          ),
                          Flexible(
                            flex: 3,
                            child: Center(
                              child: Text(
                                'Ventas de $c_item_name a $client_name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 300,
                                width: 300,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    c_item_imageurl,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'Unidades totales:',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                Text(
                                  '${numFormatter.format(totalCant)}',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                height: 1,
                                width: 170,
                                child: Container(
                                  margin: EdgeInsetsDirectional.only(
                                      start: 1, end: 1),
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Text(
                                  'Total en ventas:',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                Text(
                                  '\$${numFormatter.format(totalVentas)}.00',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        VerticalDivider(
                          width: 5,
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4.0, 10, 4, 1),
                                child: Card(
                                  child: IntrinsicHeight(
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: ListTile(
                                            title: Text(
                                              'Fecha',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            subtitle: Text(
                                              'dd/MM/yyyy',
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          width: 2,
                                          thickness: 2.5,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: ListTile(
                                            title: Text(
                                              'Precio',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          width: 2,
                                          thickness: 2.5,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: ListTile(
                                            title: Text(
                                              'Unidades',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          width: 2,
                                          thickness: 2.5,
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: ListTile(
                                            title: Text(
                                              'Total',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18),
                                            ),
                                            subtitle: Text(
                                              '*Sin IVA',
                                              style: TextStyle(
                                                  color: Colors.grey[800],
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: ItemDetails(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            );
          });
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
                  color: index%2==0?CompanyColors.PrimaryAssentColor:Colors.grey[700],
                  width: 2,
                ),
              ),
              color: Colors.white,
              elevation: 0,
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 200,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        document['imageurl'],
                      ),
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
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                        title: Text(
                          document['iname'],
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
//                      subtitle: Text(
//                        document['price'],
//                        style: TextStyle(color: Colors.black, fontSize: 15),
//                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () async {
            setState(() {
              c_item_name = document['iname'];
              c_item_price = document['price'];
              c_item_id = document.documentID;
              c_item_cant = document['cant'];
              c_item_imageurl = document['imageurl'];
              print(
                  '${c_item_name}, ${c_item_price}, ${c_item_id}, ${c_item_cant}, ${document['active']}');
            });
            await _getItemDetailsLists(context);
            _showItemDetails(context);
          },
          onLongPress: () {
            setState(() {
              c_item_name = document['iname'];
              c_item_price = document['price'];
              c_item_id = document.documentID;
              c_item_cant = document['cant'];
              c_item_imageurl = document['imageurl'];
              print(
                  '${c_item_name}, ${c_item_price}, ${c_item_id}, ${c_item_cant}, ${document['active']}');
            });
            return alertDeleteClientItem(context);
          },
        ),
      );
    }

    return StreamBuilder(
      stream: Firestore.instance
          .collection('clients/$client_id/item_list')
          .where('active', isEqualTo: activeItems)
          .snapshots(),
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
}
