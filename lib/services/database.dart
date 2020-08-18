import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/models/client.dart';
import 'package:disenart/screens/cat_clientes/client_list.dart';

  //collection reference
  final CollectionReference clientCollection = Firestore.instance.collection('clients');
  final CollectionReference itemCollection = Firestore.instance.collection('items');
  final CollectionReference clientItemListCollection = Firestore.instance.collection('clients/$client_id/item_list');

class DatabaseService {

  final String cid;
  DatabaseService({this.cid});

  Future updateUserData(String phone, String name) async {
    return await clientCollection.document(cid).setData({
      'name': name,
      'phone': phone,
    });
  }
  List<Client> _clientItemListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return Client(
        name: doc.data['name'] ?? '',
        phone: doc.data['phone'] ?? 0,
        email: doc.data['email'] ?? '',
        cid: doc.documentID ?? '0',
      );
    }).toList();
  }

//  brew list from snapshot (to convert)
  List<Client> _clientListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return Client(
        name: doc.data['name'] ?? '',
        phone: doc.data['phone'] ?? 0,
        email: doc.data['email'] ?? '',
        cid: doc.documentID ?? '0',
      );
    }).toList();
  }

  //get clients stream
  Stream<List<Client>> get clients {
    return clientCollection.snapshots()
        .map(_clientListFromSnapshot);
  }

  //get user doc stream
//  Stream<UserData> get userData {
//    return brewCollection.document(uid).snapshots()
//        .map(_userDataFromSnapshot);
//  }
//
}