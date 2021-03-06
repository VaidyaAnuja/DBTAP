import 'package:beproject/students/Homeforstudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:beproject/students/LcApply.dart' as lc;
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'dart:io';

class delete_Others extends StatefulWidget{

  @override
  _delete_OthersState createState() => _delete_OthersState();

}


class _delete_OthersState extends State<delete_Others>{
  int currentIndex =0;

  Future<void> deleteapplication(int numofdocs, List nameofteachers) async {
    User user = FirebaseAuth.instance.currentUser!;
    var snapss = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    var username = snapss.data()!['username'];
    var department = snapss.data()!['branch'];
    String fileName = '$username.pdf';

    if(snapss.data()!['canundo']){
      if(department == "Computer"){
      firebase_storage.FirebaseStorage.instance.ref().child('Computer').child(fileName).delete();}
      else if(department == "IT"){
        firebase_storage.FirebaseStorage.instance.ref().child('IT').child(fileName).delete();}
      else{
        firebase_storage.FirebaseStorage.instance.ref().child('EXTC').child(fileName).delete();

    }
      lc.atleastoneexam = false;
      lc.uploaded = false;

    FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'is_enabled_LC' : true,
    });

    FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'seatnumber' : 1000000,
    });

    final collectionRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues');
    final futureQuery = collectionRef.get();
    await futureQuery.then((value) => value.docs.forEach((element) {
      element.reference.delete();
    }));

      final collectionReff = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('ExamCell');
      final futureQueryy = collectionReff.get();
      await futureQueryy.then((value) => value.docs.forEach((element) {
        element.reference.delete();
      }));

    final collectionreference = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('EntranceExams');
    final future = collectionreference.get();
    await future.then((value) => value.docs.forEach((element) {
      element.reference.delete();
    }));



    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    String username = snap['username'];

    var i;
    for(i = 0 ; i<numofdocs; i++){
      //String name = nameofteachers[i];

      FirebaseFirestore.instance.collection('users').where("username", isEqualTo: nameofteachers[i]).get().then((list){

        FirebaseFirestore.instance.collection('users')
            .doc(list.docs[0].id)
            .collection('NoDues')
            .doc('$username')
            .delete();
      });
    }}
    nameofteachers.clear();


    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new HomeStudents()));

  }


  @override
  Widget build(BuildContext context){
    int numofdocs =0 ;
    List nameofteachers = [];
    return Scaffold(

      body: Stack(
          children: <Widget>[
            Center(
              child: Text('Loading', style: TextStyle(fontSize: 50),),
            ),
      FutureBuilder(

        future:  FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('No Dues').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData){

              numofdocs = snapshot.data!.docs.length;
              var i;
              for(i = 0 ; i<numofdocs; i++){
                nameofteachers.add(snapshot.data!.docs[i].id);

              }


             // var s = snapshot.data!.docs[0].get('status');

              // print(numofdocs);
              // print(nameofteachers);
              deleteapplication(numofdocs, nameofteachers);
              return new Text('');


          }
          else{
            return CircularProgressIndicator();
          }
        }
      )])
    );
  }
}