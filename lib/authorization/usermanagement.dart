import 'package:beproject/accounts/HomeAccounts.dart';
import 'package:beproject/admin/Homeforadmin.dart';
import 'package:beproject/examcell/HomeExamCell.dart';
import 'package:beproject/library/HomeLibrary.dart';
import 'package:beproject/tpo/HomeTPO.dart';
import 'package:beproject/workshop/HomeWorkshop.dart';
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
    else if(snap['role'] == 'admin'){

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeAdmin()));
    }

    else if(snap['role'] == 'accounts'){

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeAccounts()));
    }
    else if(snap['role'] == 'examcell'){

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeExam()));
    }
    else if(snap['role'] == 'tpo'){

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeTPO()));
    }
    else if(snap['role'] == 'library'){

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeLibrary()));
    }
    else {

      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeWorkshop()));
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