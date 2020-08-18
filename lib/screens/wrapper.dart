import 'package:disenart/screens/authenticate/authenticate.dart';
import 'package:disenart/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:disenart/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    return Home();
    //return either Home or Authenticate widget
//   if (user == null){
//     return Authenticate();
//   } else {
//     return Home();
//   }
  }
}
