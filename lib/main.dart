import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beproject/loginscreen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:beproject/authorization.dart';
import 'package:beproject/usermanagement.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//DatabaseReference usersRef = FirebaseDatabase.instance.reference().child('users');

class MyApp extends StatelessWidget {
 final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    final ref = fb.reference().child('path');
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<AuthenticationService>().authStateChanges, initialData: null,
          )
        ],
    child: MaterialApp(
      title: 'DBTap',

      home: AuthenticationWrapper(),
      routes: {
        LoginScr.routeName: (ctx)=> LoginScr(),
      },
    ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return ManageUser();
    }
    return LoginScr();
  }
}

