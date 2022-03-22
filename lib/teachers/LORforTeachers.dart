
import 'package:beproject/teachers/Homeforteachers.dart';
import 'package:beproject/teachers/StudentDetailsforLOR.dart';
import 'package:beproject/teachers/accounts_teachers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:dio/dio.dart';

import 'dart:io';
import 'package:hexcolor/hexcolor.dart';


class LORteachers extends StatefulWidget {
  @override
  _LORteachersState createState() => _LORteachersState();
}

String studentname = "";

class _LORteachersState extends State<LORteachers> with SingleTickerProviderStateMixin {
  int _v = 1;
  bool iwillwrite = false;

  Future<firebase_storage.ListResult>listFiles() async{

      firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref().child('LOR').listAll();
      result.items.forEach((firebase_storage.Reference ref) {print('Found file:$ref'); });
      return result;


  }
  Future<void> downloadURLExample(String name) async {
    Dio dio = Dio();

      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref().child('LOR').child(name)
          .getDownloadURL();
      final dir = (await getExternalStorageDirectory())!.path;
      final path = "${dir}/$name";
      Response response = await dio.get(
        downloadURL,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      File file = File(path);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      OpenFile.open('$path');

    //Notice the Push Route once this is done.
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      // print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }


  Future<void> undo(id) async {
    //var snapss = await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: id).get();
    //   .then((list){
    // FirebaseFirestore.instance.collection('users')
    //     .doc(list.docs[0].id)
    //     .get();});

      final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      String username = snap['username'];
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('LOR').doc(id).update(
          {'status':'pending',
          });
      FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get().then((list){
        FirebaseFirestore.instance.collection('users')
            .doc(list.docs[0].id)
            .collection('LOR')
            .doc('$username')
            .update({
          'status':'pending',
        });
      });
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new LORteachers()));
    }
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
  Future<void> approve(id, TextEditingController reason, TextEditingController availability, TextEditingController emailteacher, TextEditingController contactteacher) async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String username = snap['username'];
    if(reason.text == "" || availability.text == "" || double.tryParse(contactteacher.text)==null || contactteacher.text.length != 10){
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
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('LOR').doc(id).set(
        {'status':'approved',
          'message': reason.text.trim(),
          'availability': availability.text.trim(),
          'emailteacher':emailteacher.text.trim(),
          'contactteacher':contactteacher.text.trim()
        }, SetOptions(merge: true));
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('LOR')
          .doc('$username')
          .set({
        'status':'approved',
        'message': reason.text.trim(),
        'availability': availability.text.trim(),
        'emailteacher':emailteacher.text.trim(),
        'contactteacher':contactteacher.text.trim()
      }, SetOptions(merge: true));
    });
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new LORteachers()));}
  }

  Future<void> reject(id, TextEditingController reason) async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String username = snap['username'];
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('LOR').doc(id).set(
        {'status':'rejected',
          'reason':reason.text,
        }, SetOptions(merge: true));
    // FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').doc(id).set(
    //     {'reason':reason.text,
    //     });
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('LOR')
          .doc('$username')
          .set({
        'status':'rejected',
        'reason':reason.text,
      }, SetOptions(merge: true));
    });

    // FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get().then((list){
    //   FirebaseFirestore.instance.collection('users')
    //       .doc(list.docs[0].id)
    //       .collection('No Dues')
    //       .doc('$username')
    //       .set({
    //     'reason':reason.text,
    //   });
    // });
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new LORteachers()));
  }


  late int currentIndex;
  late TabController _controller ;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    currentIndex = 0;
  }

  final TextEditingController reason = TextEditingController();
  final TextEditingController availability = TextEditingController();
  final TextEditingController emailteacher = TextEditingController();
  final TextEditingController contactteacher = TextEditingController();
  final TextEditingController reqdept = TextEditingController();
  bool isSelectedcomp = false;
  bool isSelectedit = false;
  bool isSelectedextc = false;
  bool isSelectedmech = false;
  String whatisdept ="";
  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      appBar: AppBar(
        bottom: new TabBar(controller: _controller, tabs: <Tab>[

          new Tab(text: "Time"),
          new Tab(text: "Branch"),
          new Tab(text: "LOR Documents"),
        ],
        ),
        title: Text('DBTap',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        backgroundColor: HexColor("#0E34A0"),
        centerTitle: true,
        actions: [
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_rounded,
              ),
            ),
          )
        ],
      ),



      body:
      new TabBarView(
        controller: _controller,
        children: [
          Stack(
            children: [
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Container(
                        margin: const EdgeInsets.only(left: 30.0, top: 30),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Applications',
                          style:
                          TextStyle(fontSize: 30, color: HexColor("#0E34A0")),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: HexColor("#0E34A0"),
                        height: 20,
                        thickness: 2,
                        indent: 30,
                        endIndent: 30,
                      ),

                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('LOR').orderBy(
                              'time', descending: true).snapshots(),
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

                                        title: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.blue,
                                                  width: 0.5,
                                                )),
                                            margin: const EdgeInsets.only(left: 30.0, top: 30),
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                                children: [
                                                  Row(children:[
                                                    // Text(
                                                    //   nodues.get('seatnumber').toString(),
                                                    //   style: TextStyle(
                                                    //       fontSize: 20, color: HexColor("#0E34A0")),
                                                    // ),
                                                    SizedBox(width: 20,),
                                                    TextButton(
                                                        onPressed: () {
                                                         studentname = nodues.id;
                                                         print(studentname);
                                                         Navigator.of(context).push(
                                                             new MaterialPageRoute(builder: (context) => new StudentDetails_LOR()));
                                                        },
                                                        child: Text(nodues.id,
                                                          style: TextStyle(fontSize: 20, color: HexColor("#0E34A0")),)),
                                                    // Text(
                                                    //   nodues.id,
                                                    //   style: TextStyle(
                                                    //       fontSize: 20, color: HexColor("#0E34A0")),
                                                    // ),
                                                    TextButton(
                                                      onPressed: () => showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text(
                                                              'Are you sure you want to approve??'),
                                                          //actions: <Widget>[
                                                            // Row(
                                                            //   children: [
                                                            //     Radio(
                                                            //         value: 1,
                                                            //         groupValue: _v,
                                                            //         onChanged: (value) {
                                                            //           setState(() {
                                                            //             _v = value as int;
                                                            //             iwillwrite = false;
                                                            //             print('1st');
                                                            //           });
                                                            //         }
                                                            //     ),
                                                            //     SizedBox(width: 10),
                                                            //     Text("Write it for yourself",
                                                            //       style: TextStyle(fontSize: 30, color: Colors.black),
                                                            //     )
                                                            //   ],
                                                            // ),
                                                            //
                                                            // Row(
                                                            //   children: [
                                                            //     Radio(
                                                            //         value: 2,
                                                            //         groupValue: _v,
                                                            //         onChanged: (value) {
                                                            //           setState(() {
                                                            //             _v = value as int;
                                                            //             iwillwrite = true;
                                                            //             print('2nd');
                                                            //           });
                                                            //         }
                                                            //     ),
                                                            //     SizedBox(width: 10),
                                                            //     Text("I will write LOR",
                                                            //       style: TextStyle(fontSize: 30, color: Colors.black),
                                                            //     )
                                                            //   ],
                                                            // ),
                                                            content:SingleChildScrollView(child:
                                                            Column(
                                                            children:[
                                                            TextField(
                                                              controller: reason,
                                                              decoration: InputDecoration(
                                                                  labelText: "Are you writing LOR?",
                                                                  //hintText: 'Hint Value',
                                                                  labelStyle: TextStyle(fontSize: 15)
                                                              ),
                                                              style: TextStyle(fontSize: 15,),
                                                            ),//),
                                                            TextField(
                                                              controller: availability,
                                                              decoration: InputDecoration(
                                                                  labelText: "Enter date and time of your availability.",

                                                                  labelStyle: TextStyle(fontSize: 15)
                                                              ),
                                                              style: TextStyle(fontSize: 15,),
                                                            ),
                                                            TextField(
                                                              controller: emailteacher,
                                                              decoration: InputDecoration(
                                                                  labelText: "Enter your Email ID.",

                                                                  labelStyle: TextStyle(fontSize: 15)
                                                              ),
                                                              style: TextStyle(fontSize: 15,),
                                                            ),
                                                            TextField(
                                                              controller: contactteacher,
                                                              decoration: InputDecoration(
                                                                  labelText: "Enter your contact number.",

                                                                  labelStyle: TextStyle(fontSize: 15)
                                                              ),
                                                              style: TextStyle(fontSize: 15,),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                        bool isValid = EmailValidator.validate(emailteacher.text);
                                                        if (isValid) {
                                                                approve(nodues.id ,reason, availability, emailteacher, contactteacher);}
                                                        else{
                                                          emailerror();
                                                        }
                                                        },
                                                              child: const Text('YES'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(context, 'Cancel'),
                                                              child: const Text('Cancel'),
                                                            ),])
                                                        )
                                                      //],
                                                        ),
                                                      ),
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.rectangle,
                                                          color: HexColor("#0E34A0"),
                                                        ),
                                                        margin: const EdgeInsets.only(left: 15.0),
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          'Approve',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text(
                                                              'Are you sure you want to reject??'),
                                                          actions: <Widget>[

                                                            TextField(
                                                              controller: reason,
                                                              decoration: InputDecoration(
                                                                  labelText: "Please write reason to reject.",

                                                                  labelStyle: TextStyle(fontSize: 20)
                                                              ),
                                                              style: TextStyle(fontSize: 15,),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                reject(nodues.id,reason);},
                                                              child: const Text('YES'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(context, 'Cancel'),
                                                              child: const Text('Cancel'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      child: Container(
                                                        width: 80,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.rectangle,
                                                          color: HexColor("#0E34A0"),
                                                        ),
                                                        margin: const EdgeInsets.only(left: 0.0),
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          'Reject',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  ),
                                                  Row(
                                                      children:[
                                                        Text(
                                                          nodues.get('branch'),
                                                          style: TextStyle(
                                                              fontSize: 20, color: HexColor("#0E34A0")),
                                                        ),
                                                        SizedBox(height: 30),
                                                      ]),

                                                ])),);
                                    }
                                    else if (nodues.get('status') == 'approved') {
                                      return ListTile(

                                          title: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.blue,
                                                    width: 0.5,
                                                  )),
                                              margin: const EdgeInsets.only(left: 30.0, top: 30),
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                  children: [
                                                    Row(children:[

                                                      SizedBox(width: 20,),
                                                      TextButton(
                                                          onPressed: () {
                                                            studentname = nodues.id;
                                                            print(studentname);
                                                            Navigator.of(context).push(
                                                                new MaterialPageRoute(builder: (context) => new StudentDetails_LOR()));
                                                          },
                                                          child: Text(nodues.id,
                                                            style: TextStyle(fontSize: 20, color: HexColor("#0E34A0")),)),
                                                      TextButton(
                                                        onPressed: () {},
                                                        child: Container(
                                                          width: 80,
                                                          height: 20,

                                                          margin: const EdgeInsets.only(left: 15.0),
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            'Approved',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.green,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                    ),
                                                    Row(
                                                        children:[
                                                          Text(
                                                            nodues.get('branch'),
                                                            style: TextStyle(
                                                                fontSize: 20, color: HexColor("#0E34A0")),
                                                          ),
                                                          SizedBox(height: 30),
                                                        ]),
                                                  ])));
                                    }

                                    else{
                                      return ListTile(

                                          title: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.blue,
                                                  width: 0.5,
                                                )),
                                            margin: const EdgeInsets.only(left: 30.0, top: 30),
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                                children: [
                                                  Row(
                                                    children: [

                                                      SizedBox(width: 20,),
                                                      TextButton(
                                                          onPressed: () {
                                                            studentname = nodues.id;
                                                            print(studentname);
                                                            Navigator.of(context).push(
                                                                new MaterialPageRoute(builder: (context) => new StudentDetails_LOR()));
                                                          },
                                                          child: Text(nodues.id,
                                                            style: TextStyle(fontSize: 20, color: HexColor("#0E34A0")),)),
                                                      TextButton(
                                                        onPressed: () => showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext context) => AlertDialog(
                                                            title: const Text(
                                                                'Are you sure you want undo the action??'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed:() {
                                                                  undo(nodues.id);
                                                                },
                                                                child: const Text('YES'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(context, 'Cancel'),
                                                                child: const Text('Cancel'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        child: Container(
                                                          width: 80,
                                                          height: 20,

                                                          margin: const EdgeInsets.only(left: 15.0),
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            'Rejected',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                  Row(
                                                      children:[
                                                        Text(
                                                          nodues.get('branch'),
                                                          style: TextStyle(
                                                              fontSize: 20, color: HexColor("#0E34A0")),
                                                        ),

                                                      ])]),));

                                    }


                                  });}
                            else {
                              // Still loading
                              return CircularProgressIndicator();
                            }

                          }),

                    ],
                  ),
                ),
              ),

            ],
          ),
          //Icon(Icons.music_note),
          //Icon(Icons.music_video),









          Stack(
            children: [
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      Container(
                        margin: const EdgeInsets.only(left: 30.0, top: 30),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Applications',
                          style:
                          TextStyle(fontSize: 30, color: HexColor("#0E34A0")),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: HexColor("#0E34A0"),
                        height: 20,
                        thickness: 2,
                        indent: 30,
                        endIndent: 30,
                      ),

                      // Row(children:[
                      //   Container(
                      //       width: 200,
                      //       margin: const EdgeInsets.only(left: 50.0),
                      //       child: TextField(
                      //         controller: reqdept,
                      //         decoration: InputDecoration(
                      //             labelText: "Enter department",
                      //
                      //             labelStyle: TextStyle(fontSize: 25)
                      //         ),
                      //         style: TextStyle(fontSize: 25,),
                      //       )),
                      //   SizedBox(width:20),
                      //   TextButton(
                      //       onPressed: (){
                      //         setState(() {
                      //           whatisdept = reqdept.text.trim();
                      //         });
                      //         // whatisdept = reqdept.text.trim();
                      //       },
                      //       child: Icon(
                      //         Icons.person_search ,
                      //         color: HexColor("#0E34A0"),
                      //         size: 40,
                      //       )
                      //
                      //   ),
                      //
                      // ]),
                      SizedBox(width: 600, height: 80,
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget> [
                                Container(
                                    width: 80,
                                    height: 50,
                                    child:
                                    TextButton(onPressed: (){
                                      setState(() {
                                        whatisdept = 'Computer';
                                        isSelectedcomp = true;
                                        isSelectedit = false;
                                        isSelectedextc = false;
                                        isSelectedmech = false;
                                      });
                                    },
                                        child:Ink(
                                            color: isSelectedcomp ? Colors.blue : Colors.white,
                                            child: Text(
                                              'Computer',
                                              style: TextStyle(color: Colors.black),
                                            )))),
                                Container(
                                  width: 20,
                                  height: 50,
                                ),
                                Container(
                                    width: 80,
                                    height: 50,
                                    child:
                                    TextButton(onPressed: (){
                                      setState(() {
                                        whatisdept = 'IT';
                                        isSelectedcomp = false;
                                        isSelectedit = true;
                                        isSelectedextc = false;
                                        isSelectedmech = false;
                                      });
                                    },child:Ink(
                                        color: isSelectedit ? Colors.blue : Colors.white,
                                        child: Text(
                                          'IT',
                                          style: TextStyle(color: Colors.black),
                                        )))),
                                Container(
                                  width: 20,
                                  height: 50,
                                ),
                                Container(
                                    width: 80,
                                    height: 50,
                                    child:
                                    TextButton(onPressed: (){
                                      setState(() {
                                        whatisdept = 'EXTC';
                                        isSelectedcomp = false;
                                        isSelectedit = false;
                                        isSelectedextc = true;
                                        isSelectedmech = false;
                                      });
                                    },child:Ink(
                                        color: isSelectedextc ? Colors.blue : Colors.white,
                                        child: Text(
                                          'EXTC',
                                          style: TextStyle(color: Colors.black),
                                        )))),
                                Container(
                                  width: 20,
                                  height: 50,
                                ),
                                Container(
                                    width: 90,
                                    height: 50,
                                    child:
                                    TextButton(onPressed: (){
                                      setState(() {
                                        whatisdept = 'Mechanical';
                                        isSelectedcomp = false;
                                        isSelectedit = false;
                                        isSelectedextc = false;
                                        isSelectedmech = true;
                                      });
                                    },child:Ink(
                                        color: isSelectedmech ? Colors.blue : Colors.white,
                                        child: Text(
                                          'Mechanical',
                                          style: TextStyle(color: Colors.black),
                                        )))),

                              ]
                          )),

                      SizedBox(
                        height: 20,
                      ),

                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('LOR').orderBy(
                              'time', descending: true).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot nodues = snapshot.data!.docs[index];
                                    if(nodues.get('branch') == whatisdept){
                                      if(nodues.get('status') == 'pending'){
                                        return ListTile(

                                          title: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.blue,
                                                    width: 0.5,
                                                  )),
                                              margin: const EdgeInsets.only(left: 30.0, top: 30),
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                  children: [
                                                    Row(children:[
                                                      // Text(
                                                      //   nodues.get('seatnumber').toString(),
                                                      //   style: TextStyle(
                                                      //       fontSize: 20, color: HexColor("#0E34A0")),
                                                      // ),
                                                      SizedBox(width: 20,),
                                                      TextButton(
                                                          onPressed: () {
                                                            studentname = nodues.id;
                                                            print(studentname);
                                                            Navigator.of(context).push(
                                                                new MaterialPageRoute(builder: (context) => new StudentDetails_LOR()));
                                                          },
                                                          child: Text(nodues.id,
                                                            style: TextStyle(fontSize: 20, color: HexColor("#0E34A0")),)),
                                                      TextButton(
                                                        onPressed: () => showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext context) => AlertDialog(
                                                            title: const Text(
                                                                'Are you sure you want to approve??'),
                                                              //actions: <Widget>[
                                                              // Row(
                                                              //   children: [
                                                              //     Radio(
                                                              //         value: 1,
                                                              //         groupValue: _v,
                                                              //         onChanged: (value) {
                                                              //           setState(() {
                                                              //             _v = value as int;
                                                              //             iwillwrite = false;
                                                              //             print('1st');
                                                              //           });
                                                              //         }
                                                              //     ),
                                                              //     SizedBox(width: 10),
                                                              //     Text("Write it for yourself",
                                                              //       style: TextStyle(fontSize: 30, color: Colors.black),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              //
                                                              // Row(
                                                              //   children: [
                                                              //     Radio(
                                                              //         value: 2,
                                                              //         groupValue: _v,
                                                              //         onChanged: (value) {
                                                              //           setState(() {
                                                              //             _v = value as int;
                                                              //             iwillwrite = true;
                                                              //             print('2nd');
                                                              //           });
                                                              //         }
                                                              //     ),
                                                              //     SizedBox(width: 10),
                                                              //     Text("I will write LOR",
                                                              //       style: TextStyle(fontSize: 30, color: Colors.black),
                                                              //     )
                                                              //   ],
                                                              // ),
                                                              content:SingleChildScrollView(child:
                                                              Column(
                                                                  children:[
                                                                    TextField(
                                                                      controller: reason,
                                                                      decoration: InputDecoration(
                                                                          labelText: "Are you writing LOR?",
                                                                          //hintText: 'Hint Value',
                                                                          labelStyle: TextStyle(fontSize: 15)
                                                                      ),
                                                                      style: TextStyle(fontSize: 15,),
                                                                    ),//),
                                                                    TextField(
                                                                      controller: availability,
                                                                      decoration: InputDecoration(
                                                                          labelText: "Enter date and time of your availability.",

                                                                          labelStyle: TextStyle(fontSize: 15)
                                                                      ),
                                                                      style: TextStyle(fontSize: 15,),
                                                                    ),
                                                                    TextField(
                                                                      controller: emailteacher,
                                                                      decoration: InputDecoration(
                                                                          labelText: "Enter your Email ID.",

                                                                          labelStyle: TextStyle(fontSize: 15)
                                                                      ),
                                                                      style: TextStyle(fontSize: 15,),
                                                                    ),
                                                                    TextField(
                                                                      controller: contactteacher,
                                                                      decoration: InputDecoration(
                                                                          labelText: "Enter your contact number.",

                                                                          labelStyle: TextStyle(fontSize: 15)
                                                                      ),
                                                                      style: TextStyle(fontSize: 15,),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () {
                                                                        bool isValid = EmailValidator.validate(emailteacher.text);
                                                                        if (isValid) {
                                                                          approve(nodues.id ,reason, availability, emailteacher, contactteacher);}
                                                                        else{
                                                                          emailerror();
                                                                        }
                                                                      },
                                                                      child: const Text('YES'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(context, 'Cancel'),
                                                                      child: const Text('Cancel'),
                                                                    ),])
                                                              )
                                                            //],
                                                          ),
                                                        ),
                                                        child: Container(
                                                          width: 80,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            color: HexColor("#0E34A0"),
                                                          ),
                                                          margin: const EdgeInsets.only(left: 15.0),
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            'Approve',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () => showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext context) => AlertDialog(
                                                            title: const Text(
                                                                'Are you sure you want to reject??'),
                                                            actions: <Widget>[
                                                              TextField(
                                                                controller: reason,
                                                                decoration: InputDecoration(
                                                                    labelText: "Please write reason to reject.",

                                                                    labelStyle: TextStyle(fontSize: 20)
                                                                ),
                                                                style: TextStyle(fontSize: 15,),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  reject(nodues.id,reason);},
                                                                child: const Text('YES'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(context, 'Cancel'),
                                                                child: const Text('Cancel'),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        child: Container(
                                                          width: 80,
                                                          height: 20,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.rectangle,
                                                            color: HexColor("#0E34A0"),
                                                          ),
                                                          margin: const EdgeInsets.only(left: 0.0),
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            'Reject',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    ),
                                                    Row(
                                                        children:[
                                                          Text(
                                                            nodues.get('branch'),
                                                            style: TextStyle(
                                                                fontSize: 20, color: HexColor("#0E34A0")),
                                                          ),
                                                          SizedBox(height: 30),
                                                        ]),

                                                  ])),);
                                      }
                                      else if (nodues.get('status') == 'approved') {
                                        return ListTile(

                                            title: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.blue,
                                                      width: 0.5,
                                                    )),
                                                margin: const EdgeInsets.only(left: 30.0, top: 30),
                                                alignment: Alignment.topLeft,
                                                child: Column(
                                                    children: [
                                                      Row(children:[

                                                        SizedBox(width: 20,),
                                                        TextButton(
                                                            onPressed: () {
                                                              studentname = nodues.id;
                                                              print(studentname);
                                                              Navigator.of(context).push(
                                                                  new MaterialPageRoute(builder: (context) => new StudentDetails_LOR()));
                                                            },
                                                            child: Text(nodues.id,
                                                              style: TextStyle(fontSize: 20, color: HexColor("#0E34A0")),)),
                                                        TextButton(
                                                          onPressed: () {},
                                                          child: Container(
                                                            width: 80,
                                                            height: 20,

                                                            margin: const EdgeInsets.only(left: 15.0),
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              'Approved',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.green,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                      ],
                                                      ),
                                                      Row(
                                                          children:[
                                                            Text(
                                                              nodues.get('branch'),
                                                              style: TextStyle(
                                                                  fontSize: 20, color: HexColor("#0E34A0")),
                                                            ),
                                                            SizedBox(height: 30),
                                                          ]),
                                                    ])));
                                      }

                                      else{
                                        return ListTile(

                                            title: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.blue,
                                                    width: 0.5,
                                                  )),
                                              margin: const EdgeInsets.only(left: 30.0, top: 30),
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                  children: [
                                                    Row(
                                                      children: [

                                                        SizedBox(width: 20,),
                                                        TextButton(
                                                            onPressed: () {
                                                              studentname = nodues.id;
                                                              print(studentname);
                                                              Navigator.of(context).push(
                                                                  new MaterialPageRoute(builder: (context) => new StudentDetails_LOR()));
                                                            },
                                                            child: Text(nodues.id,
                                                              style: TextStyle(fontSize: 20, color: HexColor("#0E34A0")),)),
                                                        TextButton(
                                                          onPressed: () => showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext context) => AlertDialog(
                                                              title: const Text(
                                                                  'Are you sure you want undo the action??'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed:() {
                                                                    undo(nodues.id);
                                                                  },
                                                                  child: const Text('YES'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(context, 'Cancel'),
                                                                  child: const Text('Cancel'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          child: Container(
                                                            width: 80,
                                                            height: 20,

                                                            margin: const EdgeInsets.only(left: 15.0),
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              'Rejected',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.red,
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                    Row(
                                                        children:[
                                                          Text(
                                                            nodues.get('branch'),
                                                            style: TextStyle(
                                                                fontSize: 20, color: HexColor("#0E34A0")),
                                                          ),

                                                        ])]),));

                                      }


                                    }else{
                                      return Text("");

                                    }});}
                            else {
                              // Still loading
                              return CircularProgressIndicator();
                            }

                          }),

                    ],
                  ),
                ),
              ),

            ],
          ),




          Stack(
              children: [
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 30.0, top: 30),
                          alignment: Alignment.topLeft,
                          child: Text(
                            'LOR Documents',
                            style:
                            TextStyle(fontSize: 30, color: HexColor("#0E34A0")),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: HexColor("#0E34A0"),
                          height: 20,
                          thickness: 2,
                          indent: 30,
                          endIndent: 30,
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        FutureBuilder(
                            future: listFiles(),
                            builder: (BuildContext context, AsyncSnapshot<firebase_storage.ListResult> snapshot)
                            {
                              if(snapshot.hasData){
                                return Container(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data!.items.length,
                                        itemBuilder: (BuildContext context, int index){
                                          return TextButton(onPressed:(){
                                            downloadURLExample(snapshot.data!.items[index].name);
                                          },
                                              child: Text(snapshot.data!.items[index].name)
                                          );
                                        } )
                                );
                              }
                              else{
                                return CircularProgressIndicator();
                                //return Text('');
                              }
                            }
                        )


                      ],
                    ),
                  ),
                ),]),


        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          if (currentIndex == 0) {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (context) => new HomeTeachers()));
          } else if (currentIndex == 2) {
            Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (context) => new AccountSettingsTeachers()));
          } else {
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
              icon: new Icon(
                Icons.home,
              ),
              label:'Home'
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.import_contacts_sharp,
              //color: Colors.white,
            ),
            label: 'LOR',
            //  style: TextStyle(color:Colors.white),
          ),
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.manage_accounts,
              //color: Colors.white,
            ),
            label:
            'Account',

          ),
        ],
      ),

    );

  }
}
