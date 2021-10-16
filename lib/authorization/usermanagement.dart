import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/teachers/Homeforteachers.dart';
import 'package:flutter/material.dart';

class ManageUser extends StatefulWidget {
  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  String role = 'students';

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();


    if(snap['role'] == 'students'){

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeStudents()));
    } else if(snap['role'] == 'teachers'){

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeTeachers()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        
      ),
    );
  }
}