import 'package:disenart/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
        color: CompanyColors.PrimaryColor,
        child: Center(
          child: SpinKitFadingCube(
            color: Colors.white,
            size: 75.0,
          ),
        ),
      );
  }
}
