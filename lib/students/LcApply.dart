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
class LC_APPLY extends StatefulWidget{


  @override
  _LC_APPLYState createState() => _LC_APPLYState();

}


List select = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
List TeacherName = [];
List s = [false,false,false,false];
List ExamName = ['GRE', 'GATE', 'CAT', 'GMAT'];

bool atleastoneexam = false;
bool uploaded = false;
class _LC_APPLYState extends State<LC_APPLY>{
  // bool isSana = false;
  // bool isDeepali = false;
  // bool isSejal = false;
  int currentIndex=0;
  int count =0;
  bool atleastone = false;
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

  Future<void> changestate(TextEditingController seatnumber, TextEditingController Marks, TextEditingController Name, TextEditingController yearofadd, TextEditingController rn, TextEditingController address, TextEditingController emailid, TextEditingController contactnum, TextEditingController altcontactnum, TextEditingController statusstring,) async{


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
    for(int i =0; i<4; i++){
      if(s[i]){
        atleastoneexam = true;
        break;
      }}
    if(Marks.text.trim() != ""){
      atleastoneexam = true;
    }
    else{
      atleastoneexam = false;
    }
 if(atleastoneexam == true && uploaded == false){
      print('first');

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

 else if (atleastoneexam == true && uploaded == true){
   if( seatnumber.text == "" || atleastone == false || Name.text == "" || yearofadd.text == "" || rn.text=="" || address.text == "" || contactnum.text=="" || altcontactnum.text=="" || statusstring.text == ""){
     //print('Text Field is empty, Please Fill All Data');
     print('Second');
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
   else{

     if(Department == 'Computer'){
       String fileName = '$username.pdf';
     firebase_storage.Reference reference = firebase_storage.FirebaseStorage
         .instance.ref().child('Computer').child(fileName);
     firebase_storage.UploadTask uploadTask = reference.putData(
         await file.readAsBytes());
     String url = await (await uploadTask.whenComplete(() => null)).ref
         .getDownloadURL();
     }
     else if(Department == 'IT'){
       String fileName = '$username.pdf';
       firebase_storage.Reference reference = firebase_storage.FirebaseStorage
           .instance.ref().child('IT').child(fileName);
       firebase_storage.UploadTask uploadTask = reference.putData(
           await file.readAsBytes());
       String url = await (await uploadTask.whenComplete(() => null)).ref
           .getDownloadURL();
     }
     else{
       String fileName = '$username.pdf';
       firebase_storage.Reference reference = firebase_storage.FirebaseStorage
           .instance.ref().child('EXTC').child(fileName);
       firebase_storage.UploadTask uploadTask = reference.putData(
           await file.readAsBytes());
       String url = await (await uploadTask.whenComplete(() => null)).ref
           .getDownloadURL();
     }

     FirebaseFirestore.instance.collection('users').doc(user.uid).update({
       'is_enabled_LC' : false,
       'canundo':true,
       'seatnumber': int.parse(seatnumber.text.trim()),
     });

     for(int i =0; i<4; i++){
       if(s[i]){
         FirebaseFirestore.instance.collection('users').doc(user.uid).collection('EntranceExams').doc(ExamName[i]).set({
           'some':'yes',
         });
       }
       else{
         FirebaseFirestore.instance.collection('users').doc(user.uid).collection('EntranceExams').doc(ExamName[i]).set({
           'some':'NA',
         });
       }
     }
     if(Marks.text == ""){
       FirebaseFirestore.instance.collection('users').doc(user.uid).collection('EntranceExams').doc('maxmarks').set({
         'marks':'NA',
       });
     }
     else{
       FirebaseFirestore.instance.collection('users').doc(user.uid).collection('EntranceExams').doc('maxmarks').set({
         'marks':Marks.text.trim(),
       });}

     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('General').doc('Details').set({
       'Name':Name.text.trim(),
       "Admission Year": yearofadd.text.trim(),
       "Registration Number": rn.text.trim(),
       "Address": address.text.trim(),
       "EmailID": emailid.text.trim(),
       "Contact":contactnum.text.trim(),
       "Alternate Contact": altcontactnum.text.trim()

     });

     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('General').doc('Further').set({
       "Status": selectstatus,
       "Brief": statusstring.text.trim()
     });


     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('workshop').set(
         {
           'status':'pending',
           'reason':'',
         });
     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('library').set(
         {
           'status':'pending',
           'reason':'',
         });
     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('accounts').set(
         {
           'status':'pending',
           'reason':'',
         });
     if(Department == "Computer"){
     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('HODCOMP').set(
         {
           'status':'pending',
           'reason':'',
         });
     FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'HODCOMP').get().then((list){
       FirebaseFirestore.instance.collection('users')
           .doc(list.docs[0].id)
           .collection('NoDues')
           .doc('$username')
           .set({
         'status':'pending',
         'reason':'',
         'time':Timestamp.now(),
         'seatnumber': int.parse(seatnumber.text.trim()),
         'branch': Department,
       });
     });


     }


     else if(Department == "IT"){
       FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('HODIT').set(
           {
             'status':'pending',
             'reason':'',
           });
       FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'HODIT').get().then((list){
         FirebaseFirestore.instance.collection('users')
             .doc(list.docs[0].id)
             .collection('NoDues')
             .doc('$username')
             .set({
           'status':'pending',
           'reason':'',
           'time':Timestamp.now(),
           'seatnumber': int.parse(seatnumber.text.trim()),
           'branch': Department,
         });
       });


     }

     else{
       FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('HODEXTC').set(
           {
             'status':'pending',
             'reason':'',
           });
       FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'HODEXTC').get().then((list){
         FirebaseFirestore.instance.collection('users')
             .doc(list.docs[0].id)
             .collection('NoDues')
             .doc('$username')
             .set({
           'status':'pending',
           'reason':'',
           'time':Timestamp.now(),
           'seatnumber': int.parse(seatnumber.text.trim()),
           'branch': Department,
         });
       });


     }

     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('ExamCell').set(
         {
           'status':'pending',
           'reason':'',
           'message':'',
         });
     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('TPO').set(
         {
           'status':'pending',
           'reason':'',
         });
     // FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'admin').get().then((list){
     //   FirebaseFirestore.instance.collection('users')
     //       .doc(list.docs[0].id)
     //       .collection('NoDues')
     //       .doc('$username')
     //       .set({
     //     'status':'pending',
     //     'reason':'',
     //     'time':Timestamp.now(),
     //     'seatnumber': int.parse(seatnumber.text.trim()),
     //     'branch': Department,
     //   });
     // });

     FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'workshop').get().then((list){
       FirebaseFirestore.instance.collection('users')
           .doc(list.docs[0].id)
           .collection('NoDues')
           .doc('$username')
           .set({
         'status':'pending',
         'reason':'',
         'time':Timestamp.now(),
         'seatnumber': int.parse(seatnumber.text.trim()),
         'branch': Department,
       });
     });

     FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'library').get().then((list){
       FirebaseFirestore.instance.collection('users')
           .doc(list.docs[0].id)
           .collection('NoDues')
           .doc('$username')
           .set({
         'status':'pending',
         'reason':'',
         'time':Timestamp.now(),
         'seatnumber': int.parse(seatnumber.text.trim()),
         'branch': Department,
       });
     });

     FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'ExamCell').get().then((list){
       FirebaseFirestore.instance.collection('users')
           .doc(list.docs[0].id)
           .collection('NoDues')
           .doc('$username')
           .set({
         'status':'pending',
         'reason':'',
         'time':Timestamp.now(),
         'message':'',
         'seatnumber': int.parse(seatnumber.text.trim()),
         'branch': Department,
       });
     });

     FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'TPO').get().then((list){
       FirebaseFirestore.instance.collection('users')
           .doc(list.docs[0].id)
           .collection('NoDues')
           .doc('$username')
           .set({
         'status':'pending',
         'reason':'',
         'time':Timestamp.now(),
         'seatnumber': int.parse(seatnumber.text.trim()),
         'branch': Department,
       });
     });
     FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'accounts').get().then((list){
       FirebaseFirestore.instance.collection('users')
           .doc(list.docs[0].id)
           .collection('NoDues')
           .doc('$username')
           .set({
         'status':'pending',
         'reason':'',
         'time':Timestamp.now(),
         'seatnumber': int.parse(seatnumber.text.trim()),
         'branch': Department,
       });
     });
     var i;
     for(i=0; i<count; i++){
       if(select[i]){
         FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc(TeacherName[i]).set(
             {
               'status':'pending',
               'reason':'',
             });
         FirebaseFirestore.instance.collection('users').where("username", isEqualTo: TeacherName[i]).get().then((list){
           FirebaseFirestore.instance.collection('users')
               .doc(list.docs[0].id)
               .collection('NoDues')
               .doc('$username')
               .set({
             'status':'pending',
             'reason':'',
             'time':Timestamp.now(),
             'seatnumber': int.parse(seatnumber.text.trim()),
             'branch': Department,
           });
         });
       }
     }



     // Navigator.of(context).pushReplacement(
     //     new MaterialPageRoute(builder: (context) => new HomeStudents()));
     Navigator.of(context).pushNamedAndRemoveUntil('/firststudents', (Route<dynamic> route) => false);
   }
 }

    else{
   if( seatnumber.text == "" || atleastone == false || Name.text == "" || yearofadd.text == "" || rn.text=="" || address.text == "" || contactnum.text=="" || altcontactnum.text=="" || statusstring.text == ""){
     //print('Text Field is empty, Please Fill All Data');
     print('third');
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
   else{
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'is_enabled_LC' : false,
        'canundo':true,
        'seatnumber': int.parse(seatnumber.text.trim()),
      });

      for(int i =0; i<4; i++){
        if(s[i]){
          FirebaseFirestore.instance.collection('users').doc(user.uid).collection('EntranceExams').doc(ExamName[i]).set({
            'some':'yes',
          });
        }
        else{
          FirebaseFirestore.instance.collection('users').doc(user.uid).collection('EntranceExams').doc(ExamName[i]).set({
            'some':'NA',
          });
        }
      }
      if(Marks.text == ""){
        FirebaseFirestore.instance.collection('users').doc(user.uid).collection('EntranceExams').doc('maxmarks').set({
          'marks':'NA',
        });
        }
        else{
        FirebaseFirestore.instance.collection('users').doc(user.uid).collection('EntranceExams').doc('maxmarks').set({
        'marks':Marks.text.trim(),
      });}

      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('General').doc('Details').set({
      'Name':Name.text.trim(),
        "Admission Year": yearofadd.text.trim(),
        "Registration Number": rn.text.trim(),
        "Address": address.text.trim(),
        "EmailID": emailid.text.trim(),
        "Contact":contactnum.text.trim(),
        "Alternate Contact": altcontactnum.text.trim()

      });

      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('General').doc('Further').set({
        "Status": selectstatus,
        "Brief": statusstring.text.trim()
      });


      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('workshop').set(
          {
            'status':'pending',
            'reason':'',
          });
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('library').set(
          {
            'status':'pending',
            'reason':'',
          });
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('accounts').set(
          {
            'status':'pending',
            'reason':'',
          });
      if(Department == "Computer"){
        FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('HODCOMP').set(
            {
              'status':'pending',
              'reason':'',
            });
        FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'HODCOMP').get().then((list){
          FirebaseFirestore.instance.collection('users')
              .doc(list.docs[0].id)
              .collection('NoDues')
              .doc('$username')
              .set({
            'status':'pending',
            'reason':'',
            'time':Timestamp.now(),
            'seatnumber': int.parse(seatnumber.text.trim()),
            'branch': Department,
          });
        });


      }


      else if(Department == "IT"){
        FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('HODIT').set(
            {
              'status':'pending',
              'reason':'',
            });
        FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'HODIT').get().then((list){
          FirebaseFirestore.instance.collection('users')
              .doc(list.docs[0].id)
              .collection('NoDues')
              .doc('$username')
              .set({
            'status':'pending',
            'reason':'',
            'time':Timestamp.now(),
            'seatnumber': int.parse(seatnumber.text.trim()),
            'branch': Department,
          });
        });


      }

      else{
        FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('HODEXTC').set(
            {
              'status':'pending',
              'reason':'',
            });
        FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'HODEXTC').get().then((list){
          FirebaseFirestore.instance.collection('users')
              .doc(list.docs[0].id)
              .collection('NoDues')
              .doc('$username')
              .set({
            'status':'pending',
            'reason':'',
            'time':Timestamp.now(),
            'seatnumber': int.parse(seatnumber.text.trim()),
            'branch': Department,
          });
        });


      }
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('ExamCell').set(
          {
            'status':'pending',
            'reason':'',
            'message':'',
          });
      FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('TPO').set(
          {
            'status':'pending',
            'reason':'',
          });


      FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'workshop').get().then((list){
        FirebaseFirestore.instance.collection('users')
            .doc(list.docs[0].id)
            .collection('NoDues')
            .doc('$username')
            .set({
          'status':'pending',
          'reason':'',
          'time':Timestamp.now(),
          'seatnumber': int.parse(seatnumber.text.trim()),
          'branch': Department,
        });
      });

      FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'library').get().then((list){
        FirebaseFirestore.instance.collection('users')
            .doc(list.docs[0].id)
            .collection('NoDues')
            .doc('$username')
            .set({
          'status':'pending',
          'reason':'',
          'time':Timestamp.now(),
          'seatnumber': int.parse(seatnumber.text.trim()),
          'branch': Department,
        });
      });

      FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'ExamCell').get().then((list){
        FirebaseFirestore.instance.collection('users')
            .doc(list.docs[0].id)
            .collection('NoDues')
            .doc('$username')
            .set({
          'status':'pending',
          'reason':'',
          'time':Timestamp.now(),
          'message':'',
          'seatnumber': int.parse(seatnumber.text.trim()),
          'branch': Department,
        });
      });

      FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'TPO').get().then((list){
        FirebaseFirestore.instance.collection('users')
            .doc(list.docs[0].id)
            .collection('NoDues')
            .doc('$username')
            .set({
          'status':'pending',
          'reason':'',
          'time':Timestamp.now(),
          'seatnumber': int.parse(seatnumber.text.trim()),
          'branch': Department,
        });
      });
      FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'accounts').get().then((list){
        FirebaseFirestore.instance.collection('users')
            .doc(list.docs[0].id)
            .collection('NoDues')
            .doc('$username')
            .set({
          'status':'pending',
          'reason':'',
          'time':Timestamp.now(),
          'seatnumber': int.parse(seatnumber.text.trim()),
          'branch': Department,
        });
      });
      var i;
      for(i=0; i<count; i++){
        if(select[i]){
          FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc(TeacherName[i]).set(
              {
                'status':'pending',
                'reason':'',
              });
          FirebaseFirestore.instance.collection('users').where("username", isEqualTo: TeacherName[i]).get().then((list){
            FirebaseFirestore.instance.collection('users')
                .doc(list.docs[0].id)
                .collection('NoDues')
                .doc('$username')
                .set({
              'status':'pending',
              'reason':'',
              'time':Timestamp.now(),
              'seatnumber': int.parse(seatnumber.text.trim()),
              'branch': Department,
            });
          });
        }
      }



      // Navigator.of(context).pushReplacement(
      //     new MaterialPageRoute(builder: (context) => new HomeStudents()));
      Navigator.of(context).pushNamedAndRemoveUntil('/firststudents', (Route<dynamic> route) => false);
    }}

  }

  // Future<
  //     firebase_storage.UploadTask?
  // > uploadFile(File file) async {
  //
  //     String fileName = 'ExamDetails.pdf';
  //     firebase_storage.Reference reference = firebase_storage.FirebaseStorage
  //         .instance.ref().child(fileName);
  //     firebase_storage.UploadTask uploadTask = reference.putData(
  //         await file.readAsBytes());
  //     String url = await (await uploadTask.whenComplete(() => null)).ref
  //         .getDownloadURL();
  //
  //   }


    final TextEditingController seatnumber = TextEditingController();
    final TextEditingController Marks = TextEditingController();
    final TextEditingController Name = TextEditingController();
    final TextEditingController yearofadd = TextEditingController();
    final TextEditingController rn = TextEditingController();
    final TextEditingController address = TextEditingController();
    final TextEditingController emailid = TextEditingController();
    final TextEditingController contactnum = TextEditingController();
    final TextEditingController altcontactnum = TextEditingController();
    final TextEditingController statusstring = TextEditingController();
    String filename = "None";
  File file = File('');
    int _v = 1;
    String EmploymentStat = "Enter Employer and LPA";
    String selectstatus = "Campus Employment";
    //bool uploaded = false;
  void initState() {
    uploaded = false;
  }
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
                        'No Dues - Select your project guide.(Required)',
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
                            labelText: "Name as in hallticket (Required)",

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
                        controller: seatnumber,
                        decoration: InputDecoration(
                            labelText: "Exam Seat Number (Required)",

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
                        controller: yearofadd,
                        decoration: InputDecoration(
                            labelText: "Year of Addmission (Required)",

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
                        controller: rn,
                        decoration: InputDecoration(
                            labelText: "Registration Number (Required)",

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
                        controller: address,
                        decoration: InputDecoration(
                            labelText: "Address for communication (Required)",

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
                            labelText: "Email ID (Required)",

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
                            labelText: "Contact Number (Required)",

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
                        controller: altcontactnum,
                        decoration: InputDecoration(
                            labelText: "Alternate Contact Number (Required)",

                            labelStyle: TextStyle(fontSize: 25)
                        ),
                        style: TextStyle(fontSize: 25,),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(

                      margin: const EdgeInsets.only(left: 30.0),
                      alignment: Alignment.topLeft,
                      child: Text('Select status from following (Required).',
                        style: TextStyle(fontSize: 25, color: HexColor(
                            "#0E34A0")),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Radio(
                            value: 1,
                            groupValue: _v,
                            onChanged: (value) {
                              setState(() {
                                _v = value as int;
                                EmploymentStat = "Enter Employer and LPA";
                                selectstatus = "Campus Employment";
                              });
                            }
                        ),
                        SizedBox(width: 10),
                        Text("Campus Employment",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Radio(
                            value: 2,
                            groupValue: _v,
                            onChanged: (value) {
                              setState(() {
                                _v = value as int;
                                EmploymentStat = "Enter Institute and Course";
                                selectstatus = "Higher Studies";
                              });
                            }
                        ),
                        SizedBox(width: 10),
                        Text("Higher Studies",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Radio(
                            value: 3,
                            groupValue: _v,
                            onChanged: (value) {
                              setState(() {
                                _v = value as int;
                                EmploymentStat = "Enter Details in short";
                                selectstatus = "Self Employed";
                              });
                            }
                        ),
                        SizedBox(width: 10),
                        Text("Self Employed",
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        )
                      ],
                    ),

                    SizedBox(height: 20),

                    Container(

                      margin: const EdgeInsets.only(left: 30.0),
                      alignment: Alignment.topLeft,
                      child: TextField(
                        controller: statusstring,
                        decoration: InputDecoration(
                            labelText: EmploymentStat,

                            labelStyle: TextStyle(fontSize: 25)
                        ),
                        style: TextStyle(fontSize: 25,),
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(

                      margin: const EdgeInsets.only(left: 30.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Select the exams you have appeared for(if any).',
                        style: TextStyle(fontSize: 25, color: HexColor(
                            "#0E34A0")),
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          Text(("GRE"),
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),

                          Transform.scale(
                            scale: 2,
                            child: Checkbox(

                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(
                                  getColor),
                              value: s[0],
                              onChanged: (bool? value) {
                                setState(() {
                                  s[0] = value;
                                  atleastoneexam = false;
                                });
                              },
                            ),),
                        ]
                    ),

                    SizedBox(height: 10),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          Text(("GATE"),
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),

                          Transform.scale(
                            scale: 2,
                            child: Checkbox(

                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(
                                  getColor),
                              value: s[1],
                              onChanged: (bool? value) {
                                setState(() {
                                  s[1] = value;
                                  atleastoneexam = false;
                                });
                              },
                            ),),
                        ]
                    ),

                    SizedBox(height: 10),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          Text(("CAT"),
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),

                          Transform.scale(
                            scale: 2,
                            child: Checkbox(

                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(
                                  getColor),
                              value: s[2],
                              onChanged: (bool? value) {
                                setState(() {
                                  s[2] = value;
                                  atleastoneexam = false;
                                });
                              },
                            ),),
                        ]
                    ),

                    SizedBox(height: 10),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[

                          Text(("GMAT"),
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),

                          Transform.scale(
                            scale: 2,
                            child: Checkbox(

                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(
                                  getColor),
                              value: s[3],
                              onChanged: (bool? value) {
                                setState(() {
                                  s[3] = value;
                                  atleastoneexam = false;
                                });
                              },
                            ),),
                        ]
                    ),


                    SizedBox(height: 20),


                    Container(

                      margin: const EdgeInsets.only(left: 30.0),
                      alignment: Alignment.topLeft,
                      child: TextField(
                        controller: Marks,
                        decoration: InputDecoration(
                            labelText: "Any otheer exam name with score",

                            labelStyle: TextStyle(fontSize: 30)
                        ),
                        style: TextStyle(fontSize: 25,),
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(

                    margin: const EdgeInsets.only(left: 30.0),
                    alignment: Alignment.center,
                    child: Text(filename),),
                    SizedBox(height: 20),
                    FloatingActionButton(
                      // backgroundColor: Colors.purple,
                      child: Text("Upload",
                        style: TextStyle(color: Colors.white),),
                      onPressed: () async {
                        final path = await FlutterDocumentPicker.openDocument();
                         file = File(path);
                         uploaded = true;
                         setState(() {
                           filename = file.path.split('/').last;
                         });
                        //firebase_storage.UploadTask? task = await uploadFile(file);
                      },
                    ),
                    SizedBox(height: 20),
                    TextButton(
                        onPressed: () {
                          bool isValid = EmailValidator.validate(emailid.text);
                          if (isValid) {

                            changestate(
                                seatnumber,
                                Marks,
                                Name,
                                yearofadd,
                                rn,
                                address,
                                emailid,
                                contactnum,
                                altcontactnum,
                                statusstring,
                            //file
                            );
                          }
                          else {
                            emailerror();
                          }
                        },
                        child: Text('Apply for No Dues',
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