import 'dart:io';
import 'package:disenart/services/database.dart';
import 'package:disenart/shared/alert_save.dart';
import 'package:disenart/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class NewItem extends StatefulWidget {
  @override
  _NewItemState createState() => _NewItemState();
}

//TODO add image: _image!=null ? AssetImage(_image.path):RaisedButton(child: Text('Agregar Imagen'),), https://www.c-sharpcorner.com/article/upload-image-file-to-firebase-storage-using-flutter/
class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  String itname;
  String itprice;
  String error = '';
  bool alertclosed = false;
  final focus = FocusNode();
  final focus2 = FocusNode();
  File image;
  String uploadedFileURL;
  FirebaseAuth mAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String sampleimage =
        'https://firebasestorage.googleapis.com/v0/b/disenart-8ed36.appspot.com/o/itemIma'
        'ges%2FCalendarioAzteca.jfif?alt=media&token=eb7da96e-1be3-4386-90fe-0ae145d64f7e';

    //OLD
//    Future chooseFile(BuildContext context) async {
//      print('picking file');
//      final pickedFile = await picker.getImage(source: ImageSource.gallery);
//      setState(() {
//        _image = File(pickedFile.path);
//      });
//      print('image text: $_image');
//    }

    Future chooseFile(BuildContext context) async {
      print('picking file');
      var selectedImage =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        image = selectedImage;
      });
      print('image path: $image');
      print('image path basename: ${basename(image.path)}');
    }


    Future uploadFile(BuildContext context) async {
      await mAuth.signInAnonymously();
      String fileName = basename(image.path);
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('itemImages/$fileName');
      StorageUploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.onComplete;
      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          uploadedFileURL = fileURL;
        });
        print('Url obtained: $uploadedFileURL');
      });
    }

//OLD
//    Future uploadFile(BuildContext context) async {
//      print('Uploading File...');
//      StorageReference storageReference = FirebaseStorage.instance.ref().child('itemImages/$_image');
//      StorageUploadTask uploadTask = storageReference.putFile(_image);
//      await uploadTask.onComplete;
//      print('File Uploaded');
//      storageReference.getDownloadURL().then((fileURL) {
//        setState(() {
//          _uploadedFileURL = fileURL;
//        });
//      });
//    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 50.0, left: 50.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            (image != null)
                ? Image.file(
                    image,
                    height: 300.0,
                    fit: BoxFit.scaleDown,
                  )
                : GestureDetector(
              onTap: () => chooseFile(context),
                  child: Container(
                      height: 300.0,
                      width: 300.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.image,
                            size: 75.0,
                          ),
                          Text(
                            'Seleccionar Imagen',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 250.0,
                  child: TextFormField(
                    focusNode: focus2,
                    autofocus: false,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    initialValue: itname!=null?itname:null,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Nombre de artículo'),
                    validator: (val) =>
                        val.isEmpty ? 'Ingresa un nombre' : null,
                    onChanged: (val) => setState(() => itname = val),
                    onFieldSubmitted: (val) {
                      FocusScope.of(context).requestFocus(focus);
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(
                  width: 170.0,
                  child: TextFormField(
                    focusNode: focus,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Precio'),
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.number,
                    initialValue: itprice!=null?itprice:null,
                    validator: (val) =>
                        val.isEmpty ? 'Ingresa un precio' : null,
                    onChanged: (val) => setState(() => itprice = val),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            (image == null)
                ? Container(width: 5.0, height: 10.0,)
                : FlatButton.icon(
                    icon: Icon(Icons.image),
                    label: Text(
                      'Cambiar Imagen',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      chooseFile(context);
                    },
                  ),
            (image!=null)?FlatButton(
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
                  await uploadFile(context);
                  await itemCollection.add({
                    'iname': itname,
                    'price': '\$$itprice.00',
                    'searchKey': '${itname[0]}',
                    'imageurl': uploadedFileURL,
//                    'date': DateTime.now(),
                  });
                  Navigator.pop(context);
                  alertSaveItem(context);
                }
              },
            ):Container(height: 20.0, width: 40.0,),
          ],
        ),
      ),
    );
  }
}
