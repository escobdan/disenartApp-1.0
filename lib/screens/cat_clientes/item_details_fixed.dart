import 'package:disenart/screens/cat_clientes/client_item_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<dynamic> sales;
DateFormat formatter = DateFormat("dd/MM/yyyy");


class ItemDetails extends StatelessWidget {
  @override

    Widget _buildItemDetailList(BuildContext context, int index) {
      String currentDate = (formatter.format(sales[index]['date'].toDate())).toString();
      int currentPrice = sales[index]['price'];
      int currentCant = sales[index]['cant'];
      int currentTotal = currentPrice * currentCant;
//      totalVentas += (currentPrice * currentCant);
//      totalCant += currentCant;
//      print('cant: $totalCant, ventas: $totalVentas');

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        child: Card(
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: ListTile(
                    title: Text(
                      '$currentDate',
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
                      '\$${numFormatter.format(currentPrice)}.00',
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
                      '${numFormatter.format(currentCant)}',
                      style: TextStyle(color: Colors.black, fontSize: 16),
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
                      '\$${numFormatter.format(currentTotal)}.00',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget build(BuildContext context) {
    totalVentas=0;
    totalCant=0;
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: sales.length,
          itemBuilder: (context, index) {
            return _buildItemDetailList(context, index);
          },
        ),
      );
    }
  }

