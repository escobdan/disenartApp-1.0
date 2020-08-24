import 'dart:async';
import 'package:disenart/screens/cat_clientes/cat_client.dart';
import 'package:disenart/services/database.dart';
import 'package:disenart/services/search.dart';
import 'package:disenart/shared/alert_delete.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class ClientList extends StatefulWidget {
  @override
  _ClientListState createState() => _ClientListState();
}

StreamController<String> clientcontroller =
    StreamController<String>.broadcast();
Stream clientprofilestream = clientcontroller.stream;

String client_name;
String client_phone;
String client_id;
String searchClient_id;
String client_email = 'null';
bool isClientSelected = false;
List<String> ci_list;
bool searching = false;

class _ClientListState extends State<ClientList> {
  @override
  Widget _buildClientList(
    BuildContext context,
    DocumentSnapshot document,
  ) {
    return Dismissible(
      direction: DismissDirection.horizontal,
      key: Key(client_id),
      confirmDismiss: (direction) {
        setState(() {
          client_name = document['name'];
          client_phone = document['phone'];
          client_email = document['email'];
          client_id = document.documentID;
          ci_list = List.from(document['item_list']);
          print(
              '$client_name, $client_phone, $client_id, $client_email, $ci_list');
        });
        return  alertDeleteClient(context);
      },
      background: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: CompanyColors.ComplementaryColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
        child: Card(
          child: ListTile(
            onTap: () {
//              Map<dynamic, dynamic> map  = document['item_list'].data.document.value;
              setState(() {
                client_name = document['name'];
                client_phone = document['phone'];
                client_email = document['email'];
                ci_list = List.from(document['item_list']);
                client_id = document.documentID;
                clientcontroller.add(client_name);
                print(
                    'client_id: $client_id, $client_name, $client_phone, $client_email, $ci_list,');
                isClientSelected ? null : Navigator.pop(context);
                isClientSelected
                    ? null
                    : Navigator.pushNamed(context, '/cat_client');
                isClientSelected = true;
              });
            },
            title: Text(
              document['name'],
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            subtitle: Row(
              children: <Widget>[
                Icon(
                  Icons.phone,
                  size: 12,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  document['phone'],
                  style: TextStyle(color: Colors.grey[800], fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  gettingID(context) async {
    await SearchService()
        .searchByFullName(client_name)
        .then((QuerySnapshot docs) {
      setState(() {
        searchClient_id = docs.documents[0].documentID;
        print(
            'client id from click: $searchClient_id with client name: $client_name');
      });
    });
  }

  Widget _buildClientListSearch(data) {
    return Stack(
      overflow: Overflow.clip,
      children: <Widget>[
        Container(
          height: 80,
          color: Colors.white,
        ),
        Dismissible(
          direction: DismissDirection.horizontal,
          key: Key(client_id),
          confirmDismiss: (direction) async {
            await setState(() {
              client_name = data['name'];
              print('id before change: $client_id');
              gettingID(context);
            });
            await Future.delayed(Duration(milliseconds: 500));
            print('timer done');
            setState(() {
              client_name = data['name'];
              client_phone = data['phone'];
              client_email = data['email'];
              client_id = searchClient_id;
              ci_list = List.from(data['item_list']);
              print(
                  '$client_name, $client_phone, $client_id, $client_email, $ci_list');
            });
            return alertDeleteClient(context);
          },
          background: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                color: CompanyColors.ComplementaryColor,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
            child: Card(
              child: ListTile(
                onTap: () async {
                  await setState(() {
                    client_name = data['name'];
                    print('id before change: $client_id');
                    gettingID(context);
                  });
                  await Future.delayed(Duration(milliseconds: 500));
                  print('timer done');
                  setState(() {
//                    client_name = data['name'];
                    client_id = searchClient_id;
                    print('id after change: $client_id');
                    client_phone = data['phone'];
                    client_email = data['email'];
                    ci_list = List.from(data['item_list']);
                    clientcontroller.add(client_name);
                    print(
                        'client_id: $client_id, $client_name, $client_phone, $client_email, $ci_list,');
                    isClientSelected ? null : Navigator.pop(context);
                    isClientSelected
                        ? null
                        : Navigator.pushNamed(context, '/cat_client');
                    isClientSelected = true;
                  });
                },
                title: Text(
                  data['name'],
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      size: 12,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      data['phone'],
                      style: TextStyle(color: Colors.grey[800], fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget build(BuildContext context) {
//    return ClientTile();
    if (!searching) {
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('clients')
                .orderBy('name', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading...');
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return _buildClientList(
                      context, snapshot.data.documents[index]);
                },
              );
            }),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
              scrollDirection: Axis.vertical,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return _buildClientListSearch(element);
              }).toList()));
      //this kinda works, go back if all fails
//    return Padding(
//      padding: const EdgeInsets.only(top: 10),
//        child: GridView.count(
//          crossAxisCount: 1,
//          scrollDirection: Axis.vertical,
//          primary: false,
//          shrinkWrap: true,
//          children: tempSearchStore.map((element) {
//            return _buildClientListSearch(element);
//          }).toList()
//        ),
//    );
    }

//    return Padding(
//      padding: EdgeInsets.only(top:10),
//      child: StreamBuilder(
//          stream: Firestore.instance.collection('clients').orderBy('name', descending: false).snapshots(),
//          builder: (context, snapshot) {
//            if (!snapshot.hasData) return const Text('Loading...');
//            return ListView.builder(
//              scrollDirection: Axis.vertical,
//              itemCount: snapshot.data.documents.length,
//              itemBuilder: (context, index) {
//                return _buildClientList(context, snapshot.data.documents[index]);
//              },
//            );
//          }
//      ),
//    );
  }
}
