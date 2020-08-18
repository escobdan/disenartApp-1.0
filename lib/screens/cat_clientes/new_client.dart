import 'package:disenart/services/database.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/shared/alert_save.dart';
import 'package:flutter/services.dart';


class NewClient extends StatefulWidget {
  @override
  _NewClientState createState() => _NewClientState();
}

class _NewClientState extends State<NewClient> {
  final _formKey = GlobalKey<FormState>();

  String clname;
  String clphonelada = '477';
  String clphone;
  String clphonenoformat;
  String clemail;
  var item_list = new List();
  String error = '';
  bool alertclosed = false;

  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.0,
        right: 50.0,
        left: 50.0,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration:
                    textInputDecoration.copyWith(hintText: 'Nombre Completo'),
                validator: (val) => val.isEmpty ? 'Ingresa un nombre' : null,
                onChanged: (val) => setState(() => clname = val),
                autofocus: true,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus);
                },
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: 80.0,
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      initialValue: '477',
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Lada',
                          counterText: '',
                          errorBorder: InputBorder.none),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      validator: (val) => val.isEmpty ? 'Ingresa' : null,
                      onChanged: (val) =>
                          setState(() => clphonelada = val.toString()),
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).requestFocus(focus);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  SizedBox(
                    width: 230.0,
                    child: TextFormField(
                      focusNode: focus,
                      textInputAction: TextInputAction.done,
                      decoration: textInputDecoration.copyWith(
                        hintText: 'Telefono',
                        counterText: '',
                      ),
                      maxLength: 7,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Ingresa un número de teléfono';
                        } else {
                          return val.length < 7
                              ? 'Numero debe de ser 7 dígitos'
                              : null;
                        }
                      },
                      onChanged: (val) => setState(() => clphonenoformat = val),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration:
                    textInputDecoration.copyWith(hintText: 'Correo (opcional)'),
                onChanged: (val) => setState(() => clemail = val),
                autofocus: true,
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                color: CompanyColors.PrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    clphone =
                        '($clphonelada) ${clphonenoformat.substring(0, 3)}-${clphonenoformat.substring(3)}';
                    await clientCollection.add({
                      'name': '$clname',
                      'phone': '$clphone',
                      'email': '$clemail',
                      'item_list': FieldValue.arrayUnion(item_list),
                      'searchKey': '${clname[0]}'
                    });
                    Navigator.pop(context);
                    alertSaveClient(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
