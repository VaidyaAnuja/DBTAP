
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beproject/loginscreen.dart';
import 'package:beproject/authorization/usermanagement.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut({required context}) async {
    await _firebaseAuth.signOut();

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<void> signIn({required String email, required String password, required context}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)
    .then((userCredential) => {
    Navigator.of(context).pushReplacement(
    new MaterialPageRoute(builder: (context) => new ManageUser()))
    });
    } on FirebaseAuthException{
      final text = 'Incorrect password. Please check again.';
      final snackBar = SnackBar(

        duration: Duration(seconds: 30),
        content: Text(text,
        style: TextStyle(fontSize: 16, color: Colors.white),),
      action: SnackBarAction(

        label: 'Dismiss',

        textColor: Colors.yellow,
        onPressed: (){
        },
      ),
        backgroundColor: HexColor("#0E34A0"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);


    }

  }

}