//import 'dart:html';
import 'dart:typed_data';
import 'dart:io';
import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/students/accounts_students.dart';
import 'package:beproject/students/notificationforstudents.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
class LOR_APPLY extends StatefulWidget{


  @override
  _LOR_APPLYState createState() => _LOR_APPLYState();

}


List select = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
List TeacherName = [];

class _LOR_APPLYState extends State<LOR_APPLY>{
  // bool isSana = false;
  // bool isDeepali = false;
  // bool isSejal = false;
  int currentIndex=0;
  int count =0;

  // bool atleastoneexam = false;
  Future<void> emailerror() async{
    final text = 'Please input correct email type.';
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
  bool atleastone = false;
  Future<void> changestate(TextEditingController name, TextEditingController yearofpassing, TextEditingController topicofbeproject, TextEditingController currentstat, TextEditingController reasonforlor, TextEditingController email, TextEditingController contact) async{


    User user = FirebaseAuth.instance.currentUser!;

    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    String username = snap['username'];
    String Department = snap['branch'];
    for(int j=0; j<count; j++){
      if(select[j]){
        atleastone = true;
        break;
      }
    }
    //print(username);
    if(name.text=="" || atleastone == false || contact.text.length != 10 || double.tryParse(contact.text)== null || double.tryParse(yearofpassing.text)== null || topicofbeproject.text=="" || currentstat.text=="" || reasonforlor.text=="" || email.text==""){

      final text = 'Please fill in all the required fields.';
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
    else {
      for (int i = 0; i < count; i++) {
        if (select[i]) {
          FirebaseFirestore.instance.collection('users').doc(user.uid)
              .collection('LOR').doc(TeacherName[i])
              .set(
              {
                'status': 'pending',
              });
          FirebaseFirestore.instance.collection('users').where(
              "username", isEqualTo: TeacherName[i]).get().then((list) {
            FirebaseFirestore.instance.collection('users')
                .doc(list.docs[0].id)
                .collection('LOR')
                .doc('$username')
                .set({
              'status': 'pending',
              'time': Timestamp.now(),
              'branch': Department,
              'fullname':name.text.trim(),
              'contactnum':contact.text.trim(),
              'yearofpassing':yearofpassing.text.trim(),
              'beproject':topicofbeproject.text.trim(),
              'reasonforlor':reasonforlor.text.trim(),
              'currentstat':currentstat.text.trim(),
              'emailid':emailid.text.trim()
            });
          });
        }
      }

      FirebaseFirestore.instance.collection('users').doc(user.uid)
          .collection('LOR_General').doc('General')
          .set(
          {
            'fullname':name.text.trim(),
            'contactnum':contact.text.trim(),
            'yearofpassing':yearofpassing.text.trim(),
            'beproject':topicofbeproject.text.trim(),
            'reasonforlor':reasonforlor.text.trim(),
            'currentstat':currentstat.text.trim(),
            'emailid':emailid.text.trim()
          });
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'LOR_applied': true
      });




      Navigator.of(context).pushNamedAndRemoveUntil(
          '/firststudents', (Route<dynamic> route) => false);
    }

  }



  final TextEditingController yearofpassing = TextEditingController();
  final TextEditingController topicofbeproject = TextEditingController();
  final TextEditingController Name = TextEditingController();
  final TextEditingController currentstat = TextEditingController();
  final TextEditingController reasonforlor = TextEditingController();
  final TextEditingController emailid = TextEditingController();
  final TextEditingController contactnum = TextEditingController();


  @override
  Widget build(BuildContext context) {
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
        title: Text('DBTap',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
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

        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(

                children: <Widget>[

                  Container(

                    margin: const EdgeInsets.only(left: 30.0, top: 50),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Select teacher you want to apply for LOR.(Required)',
                      style: TextStyle(fontSize: 25, color: HexColor(
                          "#0E34A0")),
                    ),
                  ),
                  SizedBox(height: 20),

                  StreamBuilder(
                      stream:
                      FirebaseFirestore.instance.collection('users').where(
                          "role", isEqualTo: 'teachers').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot teachers = snapshot.data!
                                  .docs[index];
                              count = snapshot.data!.docs.length;
                              TeacherName.insert(
                                  index, teachers.get('username'));
                              return ListTile(
                                // Access the fields as defined in FireStore
                                title: Column(
                                  children: <Widget>[
                                    SizedBox(height: 10,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceAround,
                                        children: <Widget>[

                                          Text(teachers.get('username'),
                                            style: TextStyle(fontSize: 30,
                                                color: Colors.black),
                                          ),

                                          Transform.scale(
                                            scale: 2,
                                            child: Checkbox(

                                              checkColor: Colors.white,
                                              fillColor: MaterialStateProperty
                                                  .resolveWith(getColor),
                                              value: select[index],
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  select[index] = value;
                                                });
                                              },
                                            ),),
                                        ]
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          // Still loading
                          return CircularProgressIndicator();
                        }
                      }
                  ),


                  SizedBox(height: 20),

                  Container(

                    margin: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: Name,
                      decoration: InputDecoration(
                          labelText: "Enter your name (Required)",

                          labelStyle: TextStyle(fontSize: 25)
                      ),
                      style: TextStyle(fontSize: 25,),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(

                    margin: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: yearofpassing,
                      decoration: InputDecoration(
                          labelText: "Enter year of passing (Required)",

                          labelStyle: TextStyle(fontSize: 25)
                      ),
                      style: TextStyle(fontSize: 25,),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(

                    margin: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: currentstat,
                      decoration: InputDecoration(
                          labelText: "Enter your current status of work (Required)",

                          labelStyle: TextStyle(fontSize: 25)
                      ),
                      style: TextStyle(fontSize: 25,),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(

                    margin: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: topicofbeproject,
                      decoration: InputDecoration(
                          labelText: "Enter your BE major project topic (Required)",

                          labelStyle: TextStyle(fontSize: 25)
                      ),
                      style: TextStyle(fontSize: 25,),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(

                    margin: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: reasonforlor,
                      decoration: InputDecoration(
                          labelText: "Explain in brief need for LOR (Required)",

                          labelStyle: TextStyle(fontSize: 25)
                      ),
                      style: TextStyle(fontSize: 25,),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(

                    margin: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: emailid,
                      decoration: InputDecoration(
                          labelText: "Enter email id (Required)",

                          labelStyle: TextStyle(fontSize: 25)
                      ),
                      style: TextStyle(fontSize: 25,),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(

                    margin: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.topLeft,
                    child: TextField(
                      controller: contactnum,
                      decoration: InputDecoration(
                          labelText: "Enter contact number (Required)",

                          labelStyle: TextStyle(fontSize: 25)
                      ),
                      style: TextStyle(fontSize: 25,),
                    ),
                  ),


                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () {
                        bool isValid = EmailValidator.validate(emailid.text);
                      if (isValid) {
                          changestate(Name, yearofpassing, topicofbeproject, currentstat, reasonforlor, emailid, contactnum);}
                      else{
                        emailerror();
                      }

                        },
                      child: Text('Apply for LOR',
                          style: TextStyle(fontSize: 30, color: HexColor(
                              "#0E34A0")))),
                  SizedBox(height: 80),

                ],

              ),
            ),),

          Container(
            margin: const EdgeInsets.only(top: 564.0),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 0,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
                if (currentIndex == 0) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/firststudents', (Route<dynamic> route) => false);
                }
                else if (currentIndex == 2) {
                  Navigator.of(context).push(
                      new MaterialPageRoute(
                          builder: (context) => new AccountSettings()));
                }
                else {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (
                          context) => new notifications_Students()));
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
                  label: 'Home',
                  //style: TextStyle(color:Colors.white),
                ),


                BottomNavigationBarItem(
                  icon: new Icon(Icons.notifications,
                    //color: Colors.white,

                  ),
                  label: 'Notifications',
                  //  style: TextStyle(color:Colors.white),
                ),

                BottomNavigationBarItem(
                  icon: new Icon(Icons.manage_accounts,
                    //color: Colors.white,

                  ),
                  label: 'Account',
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