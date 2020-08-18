import 'package:disenart/models/user.dart';
import 'package:disenart/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  // underscore means private object
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on Firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
//        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  //sign in anon
//  Future signInAnon() async {
//    try{
//      AuthResult result = await _auth.signInAnonymously();
//      FirebaseUser user = result.user;
//      return _userFromFirebaseUser(user);
//    } catch(e){
//      print(e.toString());
//      return null;
//    }
//  }

  //sign in w/ email & psswd
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & psswd
//  Future registerWithEmailAndPassword(String email, String password) async {
//    try {
//      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//      FirebaseUser user = result.user;
//
//      //create a new document for the user with the uid
//      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
//      return _userFromFirebaseUser(user);
//    } catch(e) {
//      print(e.toString());
//      return null;
//    }
//  }

  //sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}