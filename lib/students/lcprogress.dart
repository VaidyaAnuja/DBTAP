import 'dart:typed_data';
import 'dart:io';
import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/students/accounts_students.dart';
import 'package:beproject/students/notificationforstudents.dart';
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


class LC_PROGRESS extends StatefulWidget{

  @override
  _LC_PROGRESSState createState() => _LC_PROGRESSState();

}


class _LC_PROGRESSState extends State<LC_PROGRESS>{

  int currentIndex=0;
   // Uint8List? screenShot;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  //Uint8List screenShot;
  Future<void> getPdf(Uint8List screenShot) async {

//Create a new PDF document.
    final PdfDocument document = PdfDocument();
//Read image data.
   // final Uint8List imageData = File('input.png').readAsBytesSync();
//Load the image using PdfBitmap.
    final PdfBitmap image = PdfBitmap(screenShot);
//Draw the image to the PDF page.
    document.pages
        .add()
        .graphics
        .drawImage(image, const Rect.fromLTWH(0, 0, 500, 780));
// Save the document.
    final path = (await getExternalStorageDirectory())!.path;
    final file = File('$path/NoDues.pdf');
    await file.writeAsBytes(document.save());
    OpenFile.open('$path/NoDues.pdf');
    //File('NoDues.pdf').writeAsBytes(document.save());
// Dispose the document.
    document.dispose();

  }

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

        Screenshot(
        controller: screenshotController,
        child: Column(children:[

                  Text('Don Bosco Institute of Technology'),
                  Text('[Engineering College]'),
                  Text('Approved by AICTE & Affiliated to University of Mumbai'),
                  Text('Dues Clearance Certificate'),
                  SizedBox(height: 10,),
                  Text('Details of Candidate'),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Column(
                        children: [

                          SizedBox(
                            width: 10,),
                          SizedBox(
                            width: 10,),
                          SizedBox(
                            width: 10,),

                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text('Name of Student',

                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text('Branch',

                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text('Academic Year of Admission',

                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text('Registration Number',

                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text('Address for Communication',

                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text('Email ID',

                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text('Contact Number',

                            ),
                          ),
                          SizedBox(
                            width: 180,
                            child: Text('Alternate Contact Number',

                            ),
                          ),

                          // Text('Academic Year of Admission'),
                        ],
                      ),

                      Column(
                        children: [
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                        ],
                      ),
                      Column(
                        children: [

                          SizedBox(
                            width: 20,),
                          SizedBox(
                            width: 20,),
                          SizedBox(
                            width: 20,),

                        ],
                      ),
                      Column(
                        children: [
                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('General').doc('Details').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['Name']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),

                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['branch']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),

                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('General').doc('Details').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['Admission Year']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),


                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('General').doc('Details').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['Registration Number']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),

                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('General').doc('Details').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['Address']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),
                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('General').doc('Details').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['EmailID']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),
                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('General').doc('Details').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['Contact']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),
                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('General').doc('Details').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['Alternate Contact']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),

                          // Text('Academic Year of Admission'),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),

                  Text('Other details of the Student'),
                  Row(
                    children: [
                      Column(
                        children: [

                          SizedBox(
                            width: 10,),
                          SizedBox(
                            width: 10,),
                          SizedBox(
                            width: 10,),

                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 130,
                            child: Text('You have opted for',

                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: Text('Details of above',

                            ),
                          ),
                          // Text('Academic Year of Admission'),
                        ],
                      ),

                      Column(
                        children: [
                          Text(':'),
                          Text(':'),
                        ],
                      ),
                      Column(
                        children: [

                          SizedBox(
                            width: 20,),
                          SizedBox(
                            width: 20,),
                          SizedBox(
                            width: 20,),

                        ],
                      ),
                      Column(
                        children: [
                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('General').doc('Further').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['Status']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),
                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('General').doc('Further').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: 180,
                                  child: Text('${snapshot.data['Brief']}'

                                  ),
                                );
                              }
                              else{
                                return Text('');
                              } },
                          ),
                          // Text('Academic Year of Admission'),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  Text('Other examination related scores'),
                  Row(
                    children: [
                      Column(
                        children: [

                          SizedBox(
                            width: 10,),
                          SizedBox(
                            width: 10,),
                          SizedBox(
                            width: 10,),

                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: 130,
                            child: Text('GATE',

                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: Text('GRE',

                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: Text('GMAT',

                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: Text('CAT',

                            ),
                          ),
                          SizedBox(
                            width: 130,
                            child: Text('Any other exam with detail',

                            ),
                          ),
                          // SizedBox(
                          //   width: 130,
                          //   child: Text('If appeared respective departments have a copy')
                          // ),
                          // Text('Academic Year of Admission'),
                        ],
                      ),

                      Column(
                        children: [
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                          Text(':'),
                        ],
                      ),
                      Column(
                        children: [

                          SizedBox(
                            width: 20,),
                          SizedBox(
                            width: 20,),
                          SizedBox(
                            width: 20,),

                        ],
                      ),
                      Column(
                        children: [
                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('EntranceExams').doc('GATE').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                if(snapshot.data['some'] == "NA"){
                                return SizedBox(
                                  width: 170,
                                  child: Text('NA'

                                  ),
                                );
                              }
                              else{
                                  return SizedBox(
                                    width: 170,
                                    child: Text('Yes'

                                    ),
                                  );
                                }
                              }
                              else{
                                return Text('');
                              } },
                          ),


                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('EntranceExams').doc('GRE').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                if(snapshot.data['some'] == "NA"){
                                  return SizedBox(
                                    width: 170,
                                    child: Text('NA'

                                    ),
                                  );
                                }
                                else{
                                  return SizedBox(
                                    width: 170,
                                    child: Text('Yes'

                                    ),
                                  );
                                }
                              }
                              else{
                                return Text('');
                              } },
                          ),

                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('EntranceExams').doc('GMAT').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                if(snapshot.data['some'] == "NA"){
                                  return SizedBox(
                                    width: 170,
                                    child: Text('NA'

                                    ),
                                  );
                                }
                                else{
                                  return SizedBox(
                                    width: 170,
                                    child: Text('Yes'

                                    ),
                                  );
                                }
                              }
                              else{
                                return Text('');
                              } },
                          ),

                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('EntranceExams').doc('CAT').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                if(snapshot.data['some'] == "NA"){
                                  return SizedBox(
                                    width: 170,
                                    child: Text('NA'

                                    ),
                                  );
                                }
                                else{
                                  return SizedBox(
                                    width: 170,
                                    child: Text('Yes'

                                    ),
                                  );
                                }
                              }
                              else{
                                return Text('');
                              } },
                          ),


                          FutureBuilder(
                            future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('EntranceExams').doc('maxmarks').get(),
                            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.hasData) {
                                  return SizedBox(
                                    width: 170,
                                    child: Text('${snapshot.data['marks']}'

                                    ),
                                  );

                              }
                              else{
                                return Text('');
                              } },
                          ),
                                                    // Text('Academic Year of Admission'),
                        ],
                      ),
                    ],
                  ),
                  // SizedBox(height:10),

                  SizedBox(
                       width: 300,
                      child: Text('If appeared respective departments have a copy',
                      style:TextStyle(color:Colors.blue)
                      )
                  ),
                  SizedBox(height:10),
                  Text('Dues Clearance Certified form'),

                      StreamBuilder(
                          stream:
                          FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('No Dues').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,

                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot nodues = snapshot.data!.docs[index];
                                  if(nodues.get('status') == 'pending'){
                                    return ListTile(
                                      //dense:true,
                                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                      // Access the fields as defined in FireStore
                                      title: Column(
                                        children: <Widget>[
                                          //SizedBox(height: 10,),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,),
                                                  SizedBox(
                                                  width: 170,
                                                  child: Text(nodues.id

                                                  ),
                                                ),
                                                Text(':'),
                                                SizedBox(
                                                  width: 20,),
                                                SizedBox(
                                                  width: 170,
                                                  child: Text('Pending', style: TextStyle( color:Colors.blue),

                                                  ),
                                                ),
                                              ]
                                          ),
                                          //SizedBox(height: 10,),
                                        ],
                                      ),
                                    );}

                                  else if(nodues.get('status') == 'approved'){
                                    return ListTile(
                                      // Access the fields as defined in FireStore
                                      title: Column(
                                        children: <Widget>[
                                          //SizedBox(height: 10,),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,),
                                                SizedBox(
                                                  width: 170,
                                                  child: Text(nodues.id

                                                  ),
                                                ),
                                                Text(':'),
                                                SizedBox(
                                                  width: 20,),
                                                SizedBox(
                                                  width: 170,
                                                  child: Text('Approved', style: TextStyle( color:Colors.green),

                                                  ),
                                                ),

                                              ]
                                          ),
                                          //SizedBox(height: 10,),
                                        ],
                                      ),
                                    );}

                                  else{
                                    return ListTile(
                                      // Access the fields as defined in FireStore
                                      title: Column(
                                        children: <Widget>[
                                          //SizedBox(height: 10,),
                                          Row(

                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 10,),
                                                SizedBox(
                                                  width: 170,
                                                  child: Text(nodues.id

                                                  ),
                                                ),
                                                Text(':'),
                                                SizedBox(
                                                  width: 20,),
                                                SizedBox(
                                                  width: 170,
                                                  child: Text('Rejected', style: TextStyle( color:Colors.red),

                                                  ),
                                                ),

                                              ]
                                          ),
                                          Row(
                                              children: <Widget>[
                                                TextButton(onPressed: ()=> showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext context) => AlertDialog(
                                                      title: Text(nodues.get('reason')),)),
                                                  child: Row(children:[
                                                    SizedBox(
                                                      width: 5,),
                                                    SizedBox(
                                                      width: 170,
                                                      child: Text('See Reason', style: TextStyle( color:Colors.green),

                                                      ),
                                                    ),]),

                                                )]),
                                         // SizedBox(height: 20,),
                                        ],
                                      ),
                                    );
                                  }

                                },
                              );
                            }  else {
                              // Still loading
                              return CircularProgressIndicator();
                            }
                          }
                      ),

                  // SizedBox(height:10),
                  //
                  //   FutureBuilder(
                  //     future:FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('ExamCell').doc('ExamCell').get(),
                  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  //       if (snapshot.hasData) {
                  //         return ListTile(
                  //           // Access the fields as defined in FireStore
                  //           title: Column(
                  //             children: <Widget>[
                  //               //SizedBox(height: 10,),
                  //               Row(
                  //
                  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //                   children: <Widget>[
                  //                     SizedBox(
                  //                       width: 10,),
                  //                     SizedBox(
                  //                       width: 170,
                  //                       child: Text('ExamCell'
                  //
                  //                       ),
                  //                     ),
                  //                     Text(':'),
                  //                     SizedBox(
                  //                       width: 20,),
                  //                     Row(
                  //                         children: <Widget>[
                  //                           TextButton(onPressed: ()=> showDialog<String>(
                  //                               context: context,
                  //                               builder: (BuildContext context) => AlertDialog(
                  //                                 title: Text(snapshot.data['message']),)),
                  //                             child: Row(children:[
                  //                               SizedBox(
                  //                                 width: 5,),
                  //                               SizedBox(
                  //                                 width: 170,
                  //                                 child: Text('See Message', style: TextStyle( color:Colors.green),
                  //
                  //                                 ),
                  //                               ),]),
                  //
                  //                           )]),
                  //
                  //                   ]
                  //               ),
                  //               // SizedBox(height: 20,),
                  //             ],
                  //           ),
                  //         );
                  //
                  //       }
                  //       else{
                  //         return Text('');
                  //       } },
                  //   ),

                  SizedBox(height:10),
                  Text('Declaration : I do not have any other Dues from any other section.'),
                  SizedBox(height:40),
                  Divider(
                    color: Colors.black,
                    height: 20,
                    thickness: 2,
                    indent: 220,
                    endIndent: 30,
                  ),
                  SizedBox(height:10),
                  Row(children:[
                    SizedBox(width:220),
                  Text('Student''s signature'),]),
                  SizedBox(height:40),])),
                  ElevatedButton(
                    // style: ,
                    onPressed: (){
                      screenshotController
                          .capture(
                          //delay: Duration(milliseconds: 10)
                      )
                          .then((image) async {
                        getPdf(image!);
                        // setState(() {
                        //    screenShot = image!;
                        // });
                      }).catchError((onError) {
                        print(onError);
                      });
                     // getPdf(screenShot);
                    },
                    child: const Text('Print'),
                  ),
                  SizedBox(height:80),
                  // StreamBuilder(
                  //   stream:
                  //   FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('No Dues').snapshots(),
                  //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //     if (snapshot.hasData) {
                  //       return ListView.builder(
                  //         physics: NeverScrollableScrollPhysics(),
                  //         scrollDirection: Axis.vertical,
                  //         shrinkWrap: true,
                  //
                  //         itemCount: snapshot.data!.docs.length,
                  //         itemBuilder: (context, index) {
                  //           DocumentSnapshot nodues = snapshot.data!.docs[index];
                  //             if(nodues.get('status') == 'pending'){
                  //            return ListTile(
                  //             // Access the fields as defined in FireStore
                  //             title: Column(
                  //               children: <Widget>[
                  //                 SizedBox(height: 10,),
                  //                 Row(
                  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //                     children: <Widget>[
                  //
                  //                       Text(nodues.id,
                  //                         style: TextStyle(fontSize: 30, color:Colors.black),
                  //                       ),
                  //
                  //                       Text('Pending', style: TextStyle(fontSize: 30, color:Colors.blue),),
                  //                     ]
                  //                 ),
                  //                 SizedBox(height: 10,),
                  //               ],
                  //             ),
                  //           );}
                  //
                  //           else if(nodues.get('status') == 'approved'){
                  //             return ListTile(
                  //               // Access the fields as defined in FireStore
                  //               title: Column(
                  //                 children: <Widget>[
                  //                   SizedBox(height: 10,),
                  //                   Row(
                  //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //                       children: <Widget>[
                  //
                  //                         Text(nodues.id,
                  //                           style: TextStyle(fontSize: 30, color:Colors.black),
                  //                         ),
                  //
                  //                         Text('Approved', style: TextStyle(fontSize: 30, color:Colors.green),),
                  //                       ]
                  //                   ),
                  //                   SizedBox(height: 10,),
                  //                 ],
                  //               ),
                  //             );}
                  //
                  //           else{
                  //               return ListTile(
                  //                 // Access the fields as defined in FireStore
                  //                 title: Column(
                  //                   children: <Widget>[
                  //                     SizedBox(height: 10,),
                  //                     Row(
                  //
                  //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //                         children: <Widget>[
                  //
                  //                           Text(nodues.id,
                  //                             style: TextStyle(fontSize: 30, color:Colors.black),
                  //                           ),
                  //
                  //                           Text('Rejected', style: TextStyle(fontSize: 30, color:Colors.red),),
                  //                         ]
                  //                     ),
                  //                     Row(
                  //                         children: <Widget>[
                  //                           SizedBox(width: 35,),
                  //                           TextButton(onPressed: ()=> showDialog<String>(
                  //                               context: context,
                  //                               builder: (BuildContext context) => AlertDialog(
                  //                                 title: Text(nodues.get('reason')),)),
                  //                               child: Text('See Reason', style: TextStyle(fontSize: 20, color:Colors.green),),),
                  //                         ]
                  //                     ),
                  //                     SizedBox(height: 20,),
                  //                   ],
                  //                 ),
                  //               );
                  //             }
                  //
                  //         },
                  //       );
                  //     }  else {
                  //     // Still loading
                  //     return CircularProgressIndicator();
                  //     }
                  //   }
                  // ),

                ],

              ),
            ),),

          Container(
            margin: const EdgeInsets.only(top: 564.0),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 0,
              onTap: (index) { setState(() { currentIndex = index;});
              if(currentIndex==0){
                Navigator.of(context).pushNamedAndRemoveUntil('/firststudents', (Route<dynamic> route) => false);
              }
              else if(currentIndex==2){
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new AccountSettings()));
              }
              else{
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (context) => new notifications_Students()));
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
                  icon: new Icon(Icons.notifications,
                    //color: Colors.white,

                  ),
                  label:'Notifications',
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