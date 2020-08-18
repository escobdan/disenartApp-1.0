import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disenart/screens/cat_clientes/client_list.dart';

class SearchService {

  //for clients
  searchByName(String searchField) {
    return Firestore.instance.collection('clients').where('searchKey', isEqualTo: searchField.substring(0,1))
        .getDocuments();
  }

  searchByFullName(String searchName){
    return Firestore.instance.collection('clients').where('name', isEqualTo: searchName).getDocuments();
  }

  // for items
  searchByItemName(String searchField) {
    return Firestore.instance.collection('items').where('searchKey', isEqualTo: searchField.substring(0,1))
        .getDocuments();
  }

  searchByFullItemName(String searchName){
    return Firestore.instance.collection('items').where('iname', isEqualTo: searchName).getDocuments();
  }

}
