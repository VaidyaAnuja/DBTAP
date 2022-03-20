import 'dart:typed_data';
import 'dart:io';
import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/students/accounts_students.dart';
import 'package:beproject/students/notificationforstudents.dart';
import 'package:beproject/teachers/Homeforteachers.dart';
import 'package:beproject/teachers/LORforTeachers.dart';
import 'package:beproject/teachers/accounts_teachers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:screenshot/screenshot.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';


class StudentDetails_LOR extends StatefulWidget{

  @override
  _StudentDetails_LORState createState() => _StudentDetails_LORState();

}


class _StudentDetails_LORState extends State<StudentDetails_LOR>{

  int currentIndex=0;


  @override
  Widget build(BuildContext context){
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('DBTap', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        toolbarHeight: 35,
        centerTitle: true,
        backgroundColor: HexColor("#0E34A0"),
        // actions: <Widget>[
        //   Container(
        //     alignment: Alignment.topRight,
        //     child: IconButton(
        //       icon: Icon(
        //         Icons.arrow_back_rounded ,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         // do something
        //         Navigator.of(context).pop();
        //       },
        //     ),),
        // ],
      ),
      //drawer: NavigationDrawerWidget(),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(

                children: <Widget>[

                  // Container(
                  //
                  //   margin: const EdgeInsets.only(left: 30.0),
                  //   alignment: Alignment.topLeft,
                  //   child: Text('Check your application progress below.',
                  //     style: TextStyle(fontSize: 25,color: HexColor("#0E34A0")),
                  //   ),
                  // ),

                  // Screenshot(
                  //     controller: screenshotController,
                  //     child:
                  Column(children:[


                    SizedBox(height:10),
                    Text('Student details here.'),
                    SizedBox(height:10),
                    Row(children:[
                      SizedBox(width: 50),
                    SizedBox(
                      width: 100,
                      child: Text('Name',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                      Text(':',
                        style: TextStyle(fontSize: 20),),
                      SizedBox(width: 10),
                      FutureBuilder(
                        future:FirebaseFirestore.instance.collection('users').where("username", isEqualTo: studentname).get().then((list){
                        FirebaseFirestore.instance.collection('users')
                            .doc(list.docs[0].id)
                            .collection('LOR_General')
                            .doc('General').get();}),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                              return SizedBox(
                                width: 170,
                                child: Text(snapshot.data['fullname'],
                                  style: TextStyle(fontSize: 20),
                                ),
                              );

                          }
                          else{
                            return Text('');
                          } },
                      ),

                    ]),

                    SizedBox(height:10),
                    Row(children:[
                      SizedBox(width: 50),
                      SizedBox(
                        width: 100,
                        child: Text('Year of passing',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Text(':',
                        style: TextStyle(fontSize: 20),),
                      SizedBox(width: 10),
                      FutureBuilder(
                        future:FirebaseFirestore.instance.collection('users').where("username", isEqualTo: studentname).get().then((list){
                          FirebaseFirestore.instance.collection('users')
                              .doc(list.docs[0].id)
                              .collection('LOR_General')
                              .doc('General').get();}),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              width: 170,
                              child: Text(snapshot.data['yearofpassing'],
                                style: TextStyle(fontSize: 20),
                              ),
                            );

                          }
                          else{
                            return Text('');
                          } },
                      ),

                    ]),
                    SizedBox(height:10),
                    Row(children:[
                      SizedBox(width: 50),
                      SizedBox(
                        width: 100,
                        child: Text('BE project topic',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Text(':',
                        style: TextStyle(fontSize: 20),),
                      SizedBox(width: 10),
                      FutureBuilder(
                        future:FirebaseFirestore.instance.collection('users').where("username", isEqualTo: studentname).get().then((list){
                          FirebaseFirestore.instance.collection('users')
                              .doc(list.docs[0].id)
                              .collection('LOR_General')
                              .doc('General').get();}),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              width: 170,
                              child: Text(snapshot.data['beproject'],
                                style: TextStyle(fontSize: 20),
                              ),
                            );

                          }
                          else{
                            return Text('');
                          } },
                      ),

                    ]),
                    SizedBox(height:10),
                    Row(children:[
                      SizedBox(width: 50),
                      SizedBox(
                        width: 100,
                        child: Text('current status',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Text(':',
                        style: TextStyle(fontSize: 20),),
                      SizedBox(width: 10),
                      FutureBuilder(
                        future:FirebaseFirestore.instance.collection('users').where("username", isEqualTo: studentname).get().then((list){
                          FirebaseFirestore.instance.collection('users')
                              .doc(list.docs[0].id)
                              .collection('LOR_General')
                              .doc('General').get();}),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              width: 170,
                              child: Text(snapshot.data['currentstat'],
                                style: TextStyle(fontSize: 20),
                              ),
                            );

                          }
                          else{
                            return Text('');
                          } },
                      ),

                    ]),
                    SizedBox(height:10),
                    Row(children:[
                      SizedBox(width: 50),
                      SizedBox(
                        width: 100,
                        child: Text('Reason for LOR',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Text(':',
                        style: TextStyle(fontSize: 20),),
                      SizedBox(width: 10),
                      FutureBuilder(
                        future:FirebaseFirestore.instance.collection('users').where("username", isEqualTo: studentname).get().then((list){
                          FirebaseFirestore.instance.collection('users')
                              .doc(list.docs[0].id)
                              .collection('LOR_General')
                              .doc('General').get();}),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              width: 170,
                              child: Text(snapshot.data['reasonforlor'],
                                style: TextStyle(fontSize: 20),
                              ),
                            );

                          }
                          else{
                            return Text('');
                          } },
                      ),

                    ]),
                    SizedBox(height:10),
                    Row(children:[
                      SizedBox(width: 50),
                      SizedBox(
                        width: 100,
                        child: Text('Contact number',style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Text(':',
                        style: TextStyle(fontSize: 20),),
                      SizedBox(width: 10),
                      FutureBuilder(
                        future:FirebaseFirestore.instance.collection('users').where("username", isEqualTo: studentname).get().then((list){
                          FirebaseFirestore.instance.collection('users')
                              .doc(list.docs[0].id)
                              .collection('LOR_General')
                              .doc('General').get();}),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              width: 170,
                              child: Text(snapshot.data['contactnum'],
                                style: TextStyle(fontSize: 20),
                              ),
                            );

                          }
                          else{
                            return Text('');
                          } },
                      ),

                    ]),
                    SizedBox(height:10),
                    Row(children:[
                      SizedBox(width: 50),
                      SizedBox(
                        width: 100,
                        child: Text('Email ID',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Text(':',
                        style: TextStyle(fontSize: 20),),
                      SizedBox(width: 10),
                      FutureBuilder(
                        future:FirebaseFirestore.instance.collection('users').where("username", isEqualTo: studentname).get().then((list){
                          FirebaseFirestore.instance.collection('users')
                              .doc(list.docs[0].id)
                              .collection('LOR_General')
                              .doc('General').get();}),
                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              width: 170,
                              child: Text(snapshot.data['emailid'],
                                style: TextStyle(fontSize: 20),
                              ),
                            );

                          }
                          else{
                            return Text('');
                          } },
                      ),

                    ]),




                   ]),
                  // ElevatedButton(
                  //   // style: ,
                  //   onPressed: (){
                  //     screenshotController
                  //         .capture(
                  //       //delay: Duration(milliseconds: 10)
                  //     )
                  //         .then((image) async {
                  //       getPdf(image!);
                  //       // setState(() {
                  //       //    screenShot = image!;
                  //       // });
                  //     }).catchError((onError) {
                  //       print(onError);
                  //     });
                  //     // getPdf(screenShot);
                  //   },
                  //   child: const Text('Print'),
                  // ),
                  SizedBox(height:80),

                ],

              ),
            ),),

          Container(
            margin: const EdgeInsets.only(top: 564.0),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 1,
              onTap: (index) { setState(() { currentIndex = index;});
              if(currentIndex==0){
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => new HomeTeachers()));
              }
              else if(currentIndex==2){
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => new AccountSettingsTeachers()));
              }
              else{
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => new LORteachers()));
              }
              },
              backgroundColor: HexColor("#0E34A0"),
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.white,
              iconSize: 30,
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home,
                    //color: Colors.white,

                  ),
                  label:'Home',
                  //style: TextStyle(color:Colors.white),
                ),


                BottomNavigationBarItem(
                  icon: new Icon(Icons.import_contacts_sharp,
                    //color: Colors.white,

                  ),
                  label:'LOR',
                  //  style: TextStyle(color:Colors.white),
                ),

                BottomNavigationBarItem(
                  icon: new Icon(Icons.manage_accounts,
                    //color: Colors.white,

                  ),
                  label:'Account',
                  //  style: TextStyle(color:Colors.white),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}