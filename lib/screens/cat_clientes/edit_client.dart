import 'package:disenart/screens/cat_clientes/client_list.dart';
import 'package:disenart/services/database.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/shared/alert_save.dart';
import 'package:flutter/services.dart';

class EditClient extends StatefulWidget {
  @override
  _EditClientState createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  @override
    final _formKey = GlobalKey<FormState>();
    final focus = FocusNode();
    String _clphonelada;
    String _clphonenoformat;

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
                  initialValue: client_name,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Nombre Completo'),
                  validator: (val) => val.isEmpty ? 'Ingresa un nombre' : null,
                  onChanged: (val) => setState(() => client_name = val),
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
                        initialValue: client_phone.substring(1,4),
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
                            setState(() => _clphonelada = val.toString()),
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
                        initialValue: '${client_phone.substring(6,9)}${client_phone.substring(10)}',
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
                        onChanged: (val) =>
                            setState(() => _clphonenoformat = val),
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
                  initialValue: client_email=='null'?'':client_email,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Correo (opcional)'),
                  onChanged: (val) => setState(() => client_email = val),
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
                    'Guardar Cambios',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if(_clphonenoformat==null){
                        if(_clphonelada==null){
                          print('same phone, no changes');
                        } else {
                          client_phone = '($_clphonelada) ${client_phone.substring(6,9)}-${client_phone.substring(10)}';
                        }
                      } else {
                        client_phone = '($_clphonelada) ${_clphonenoformat.substring(0, 3)}-${_clphonenoformat.substring(3)}';
                      }
                      print(client_phone);
                      await clientCollection.document(client_id).updateData({
                        'name': '$client_name',
                        'phone': '$client_phone',
                        'email': '$client_email',
                        'searchKey': '${client_name[0]}'
                      });
                      clientcontroller.add(client_name);
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
