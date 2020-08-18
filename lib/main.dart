import 'package:disenart/screens/cat_art/cat_items.dart';
import 'package:disenart/screens/cat_clientes/client_profile.dart';
import 'package:disenart/screens/home/home.dart';
import 'package:disenart/shared/constants.dart';
import 'package:disenart/shared/loading.dart';
import 'package:flutter/material.dart';
import 'screens/cat_clientes/cat_client.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => Home(),
    '/cat_client': (context) => Cat_Client(),
    '/cat_items': (context) => Cat_Items(),
    '/client_profile': (context) => ClientProfile(),
//    '/loading': (context) => Loading(),
  },
));
