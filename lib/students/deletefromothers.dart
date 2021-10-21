import 'package:beproject/students/Homeforstudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class delete_Others extends StatefulWidget{

  @override
  _delete_OthersState createState() => _delete_OthersState();

}


class _delete_OthersState extends State<delete_Others>{
  int currentIndex =0;

  Future<void> deleteapplication(int numofdocs, List nameofteachers) async {
    User user = FirebaseAuth.instance.currentUser!;
    var snapss = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    if(snapss.data()!['canundo']){
    FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'is_enabled_LC' : true,
    });

    final collectionRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues');
    final futureQuery = collectionRef.get();
    await futureQuery.then((value) => value.docs.forEach((element) {
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