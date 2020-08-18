import 'dart:io';
import 'package:disenart/services/database.dart';
import 'package:disenart/shared/alert_save.dart';
import 'package:disenart/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as Path;

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

  @override
  Widget build(BuildContext context) {
    File _image;
    final picker = ImagePicker();
    String _uploadedFileURL;
    String sampleimage =
        'https://firebasestorage.googleapis.com/v0/b/disenart-8ed36.appspot.com/o/itemImages%2FCalendarioAzteca.jfif?alt=media&token=eb7da96e-1be3-4386-90fe-0ae145d64f7e';

    Future chooseFile() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      setState(() {
        _image = File(pickedFile.path);
      });
    }

    Future uploadFile() async {
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child('itemImages/$_image');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
        });
      });
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 50.0, left: 50.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            _image != null
                ? Image.asset(
                    _image.path,
                    height: 300.0,
                    fit: BoxFit.scaleDown,
                  )
                : Container(
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
                    'No hay imagen seleccioanda',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
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
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              decoration:
                    textInputDecoration.copyWith(hintText: 'Nombre de artículo'),
              validator: (val) => val.isEmpty ? 'Ingresa un nombre' : null,
              onChanged: (val) => setState(() => itname = val),
              autofocus: true,
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
            _image == null
                ? FlatButton.icon(
                    icon: Icon(Icons.image),
                    label: Text(
                      'Seleccionar Imagen',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () => chooseFile,
                  )
                : FlatButton.icon(
                    icon: Icon(Icons.image),
                    label: Text(
                      'Cambiar Imagen',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () => chooseFile,
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
                  uploadFile();
                  itemCollection.add({
                    'iname': itname,
                    'price': '\$$itprice.00',
                    'searchKey': '${itname[0]}',
                    'imageurl': _uploadedFileURL,
//                    'date': DateTime.now(),
                  });
                  await Navigator.pop(context);
                  alertSaveItem(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
