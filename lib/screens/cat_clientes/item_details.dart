//import 'package:disenart/screens/cat_clientes/client_item_list.dart';
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//
//class ItemDetailsOld extends StatefulWidget {
//  @override
//  _ItemDetailsState createState() => _ItemDetailsState();
//}
//
//List<dynamic> sales;
//DateFormat formatter = DateFormat("dd/MM/yyyy");
//int totalVentas;
//int totalCant;
//
//class _ItemDetailsState extends State<ItemDetailsOld> {
//  @override
//
//  Widget _buildItemDetailList(BuildContext context, int index) {
//    String _currentDate = (formatter.format(sales[index]['date'].toDate())).toString();
//    int _currentPrice = sales[index]['price'];
//    int _currentCant = sales[index]['cant'];
//    int _currentTotal = _currentPrice*_currentCant;
//    totalVentas += (_currentPrice*_currentCant);
//    totalCant += _currentCant;
//
//    return Padding(
//      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
//      child: Card(
//        child: IntrinsicHeight(
//          child: Row(
//            children: <Widget>[
//              Flexible(
//                flex: 1,
//                child: ListTile(
//                  title: Text(
//                    '$_currentDate',
//                    style: TextStyle(color: Colors.black, fontSize: 18),
//                  ),
//                ),
//              ),
//              VerticalDivider(width: 2, thickness: 2.5,),
//              Flexible(
//                flex: 1,
//                child: ListTile(
//                  title: Text(
//                    '\$${numFormatter.format(_currentPrice)}.00',
//                    style: TextStyle(color: Colors.black, fontSize: 18),
//                  ),
//                ),
//              ),
//              VerticalDivider(width: 2, thickness: 2.5,),
//              Flexible(
//                flex: 1,
//                child: ListTile(
//                  title: Text(
//                    '${numFormatter.format(_currentCant)}',
//                    style: TextStyle(color: Colors.black, fontSize: 18),
//                  ),
//                ),
//              ),
//              VerticalDivider(width: 2, thickness: 2.5,),
//              Flexible(
//                flex: 1,
//                child: ListTile(
//                  title: Text(
//                    '\$${numFormatter.format(_currentTotal)}.00',
//                    style: TextStyle(color: Colors.black, fontSize: 18),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget build(BuildContext context) {
//    totalVentas=0;
//    totalCant=0;
//    return Padding(
//      padding: const EdgeInsets.only(top: 10),
//      child: ListView.builder(
//        shrinkWrap: true,
//        scrollDirection: Axis.vertical,
//        itemCount: sales.length,
//        itemBuilder: (context, index) {
//          return _buildItemDetailList(context, index);
//        },
//      ),
//    );
//  }
//}
