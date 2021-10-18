import 'package:beproject/accounts/HomeAccounts.dart';
import 'package:beproject/admin/Homeforadmin.dart';
import 'package:beproject/examcell/HomeExamCell.dart';
import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/teachers/Homeforteachers.dart';
import 'package:beproject/tpo/HomeTPO.dart';
import 'package:beproject/workshop/HomeWorkshop.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:beproject/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:beproject/authorization/authorization.dart';
import 'package:beproject/authorization/usermanagement.dart';

import 'library/HomeLibrary.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
 final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {

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
        '/firststudents': (context) => HomeStudents(),
        '/firstteachers': (context) => HomeTeachers(),
        '/firstadmin': (context) => HomeAdmin(),
        '/firstworkshop': (context) => HomeWorkshop(),
        '/firstlibrary': (context) => HomeLibrary(),
        '/firstaccount': (context) => HomeAccounts(),
        '/firstexam': (context) => HomeExam(),
        '/firsttpo': (context) => HomeTPO(),
        '/login': (context) => LoginScr(),
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

