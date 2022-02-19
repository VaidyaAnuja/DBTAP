
import 'package:beproject/admin/accountadmin.dart';
import 'package:beproject/admin/checklistofstudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';


class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}
String namestudentprogress = '';
String usernameofstudent = '';
double progress = 0.0;
String currentusername = '';
class _HomeAdminState extends State<HomeAdmin> with SingleTickerProviderStateMixin {

  // double progress = 0.0;
  Future<void> check_studentprogress(String id) async {
    usernameofstudent = id;
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    currentusername = snap['username'];
    final snaps = await FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get();
    namestudentprogress = snaps.docs[0].data()['uid'];
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) => new student_checklist()));
  }


  Future<void> approve(id) async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String username = snap['username'];
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').doc(id).update(
        {'status':'approved'});
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('No Dues')
          .doc('$username')
          .update({
        'status':'approved',
        'reason':''
      });
    });
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new HomeAdmin()));
  }

  Future<void> reject(id, TextEditingController reason) async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String username = snap['username'];
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').doc(id).update(
        {'status':'rejected',
          'reason':reason.text,
        });
    // FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').doc(id).set(
    //     {'reason':reason.text,
    //     });
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('No Dues')
          .doc('$username')
          .update({
        'status':'rejected',
        'reason':reason.text,
      });
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
        new MaterialPageRoute(builder: (context) => new HomeAdmin()));
  }

  Future<void> undo(id) async {
    var snapss = await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: id).get();
    //   .then((list){
    // FirebaseFirestore.instance.collection('users')
    //     .doc(list.docs[0].id)
    //     .get();});
    print(snapss.docs[0].data()['canundo']);
    if(snapss.docs[0].data()['canundo']){
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String username = snap['username'];
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').doc(id).update(
        {'status':'pending',
          'reason':'',
        });
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('No Dues')
          .doc('$username')
          .update({
        'status':'pending',
        'reason':''
      });
    });
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new HomeAdmin()));
  }}


  Future<firebase_storage.ListResult>listFiles() async{
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
       String username = snap['username'];
       if(username == "HODCOMP"){
    firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref().child('Computer').listAll();
    result.items.forEach((firebase_storage.Reference ref) {print('Found file:$ref'); });
    return result;}

    else if(username == "HODIT"){
      firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref().child('IT').listAll();
      result.items.forEach((firebase_storage.Reference ref) {print('Found file:$ref'); });
      return result;}
    else{
      firebase_storage.ListResult result = await firebase_storage.FirebaseStorage.instance.ref().child('EXTC').listAll();
      result.items.forEach((firebase_storage.Reference ref) {print('Found file:$ref'); });
      return result;}
  }
  Future<void> downloadURLExample(String name) async {
    Dio dio = Dio();
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String username = snap['username'];
    if(username == "HODCOMP"){
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref().child('Computer').child(name)
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
    }

    else if(username == "HODIT"){
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref().child('IT').child(name)
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
    }
    else{
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref().child('EXTC').child(name)
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
      }
     //Notice the Push Route once this is done.
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
     // print((received / total * 100).toStringAsFixed(0) + "%");
    }
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
  final TextEditingController reqdept = TextEditingController();
  String whatisdept ="";
  bool isSelectedcomp = false;
  bool isSelectedit = false;
  bool isSelectedextc = false;
  bool isSelectedmech = false;
  @override
  Widget build(BuildContext context) {
    // String downloadingprogress = (progress * 100).toInt().toString();
    return Scaffold(
      appBar: AppBar(
        bottom: new TabBar(controller: _controller, tabs: <Tab>[

          new Tab(text: "Time"),
          new Tab(text: "SeatNumber"),
          new Tab(text: "Documents"),
        ],
        ),
        title: Text(
          'DBTap',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: HexColor("#0E34A0"),
        // actions: [
        //   Container(
        //     alignment: Alignment.topRight,
        //     child: IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.arrow_back_rounded,
        //       ),
        //     ),
        //   )
        // ],
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
                      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').orderBy(
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
                                      child: Column(children:[Row(
                                      children: [
                                      Text(
                                      nodues.get('seatnumber').toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: HexColor("#0E34A0")),
                                    ),
                                    SizedBox(width: 10,),
                                          Text(
                                            nodues.id,
                                            style: TextStyle(
                                                fontSize: 20, color: HexColor("#0E34A0")),
                                          ),
                                          TextButton(
                                            onPressed: () => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text(
                                                    'Are you sure you want to approve??'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      approve(nodues.id);},
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
                                          IconButton(onPressed: (){
                                            check_studentprogress(nodues.id);

                                          },
                                              icon: Icon(Icons.double_arrow),
                                            iconSize: 20,
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
                                            ]),])
                                    ),);
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
                                      Text(
                                      nodues.get('seatnumber').toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: HexColor("#0E34A0")),
                                    ),
                                    SizedBox(width: 10,),
                                          Text(
                                            nodues.id,
                                            style: TextStyle(
                                                fontSize: 20, color: HexColor("#0E34A0")),
                                          ),
                                          TextButton(
                                            onPressed: () => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text(
                                                    'Are you sure you want undo the action??'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
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
                                                'Approved',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(onPressed: (){
                                            check_studentprogress(nodues.id);

                                          },
                                            icon: Icon(Icons.double_arrow),
                                            iconSize: 20,
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
                                          ])

                                    ),);
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
                                                  Text(
                                                    nodues.get('seatnumber').toString(),
                                                    style: TextStyle(
                                                        fontSize: 20, color: HexColor("#0E34A0")),
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Text(
                                                    nodues.id,
                                                    style: TextStyle(
                                                        fontSize: 20, color: HexColor("#0E34A0")),
                                                  ),
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
                                                  IconButton(onPressed: (){
                                                    check_studentprogress(nodues.id);

                                                  },
                                                    icon: Icon(Icons.double_arrow),
                                                    iconSize: 20,
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
                                                    SizedBox(width: 20,),
                                                    TextButton(onPressed: ()=> showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: Text(nodues.get('reason')),)),
                                                      child: Text('See Reason', style: TextStyle(fontSize: 20, color:Colors.green),),),
                                                    SizedBox(height: 30),
                                                  ])])

                                      ));

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
          ),]),





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
                              stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').orderBy(
                                  'seatnumber', descending: false).snapshots(),
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
                                                child: Column(children:[Row(
                                                  children: [
                                                    Text(
                                                      nodues.get('seatnumber').toString(),
                                                      style: TextStyle(
                                                          fontSize: 20, color: HexColor("#0E34A0")),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Text(
                                                      nodues.id,
                                                      style: TextStyle(
                                                          fontSize: 20, color: HexColor("#0E34A0")),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text(
                                                              'Are you sure you want to approve??'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                approve(nodues.id);},
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
                                                    IconButton(onPressed: (){
                                                      check_studentprogress(nodues.id);

                                                    },
                                                      icon: Icon(Icons.double_arrow),
                                                      iconSize: 20,
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
                                                      ]),])
                                            ),);
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
                                                        Text(
                                                          nodues.get('seatnumber').toString(),
                                                          style: TextStyle(
                                                              fontSize: 20, color: HexColor("#0E34A0")),
                                                        ),
                                                        SizedBox(width: 10,),
                                                        Text(
                                                          nodues.id,
                                                          style: TextStyle(
                                                              fontSize: 20, color: HexColor("#0E34A0")),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext context) => AlertDialog(
                                                              title: const Text(
                                                                  'Are you sure you want undo the action??'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () {
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
                                                              'Approved',
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors.green,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        IconButton(onPressed: (){
                                                          check_studentprogress(nodues.id);

                                                        },
                                                          icon: Icon(Icons.double_arrow),
                                                          iconSize: 20,
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
                                                    ])

                                            ),);
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
                                                            Text(
                                                              nodues.get('seatnumber').toString(),
                                                              style: TextStyle(
                                                                  fontSize: 20, color: HexColor("#0E34A0")),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            Text(
                                                              nodues.id,
                                                              style: TextStyle(
                                                                  fontSize: 20, color: HexColor("#0E34A0")),
                                                            ),
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
                                                            IconButton(onPressed: (){
                                                              check_studentprogress(nodues.id);

                                                            },
                                                              icon: Icon(Icons.double_arrow),
                                                              iconSize: 20,
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
                                                              SizedBox(width: 20,),
                                                              TextButton(onPressed: ()=> showDialog<String>(
                                                                  context: context,
                                                                  builder: (BuildContext context) => AlertDialog(
                                                                    title: Text(nodues.get('reason')),)),
                                                                child: Text('See Reason', style: TextStyle(fontSize: 20, color:Colors.green),),),
                                                              SizedBox(height: 30),
                                                            ])])

                                              ));

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
                  ),]),





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
                              'Exam Documents',
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
              currentIndex: 0,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
                if (currentIndex == 0) {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => new HomeAdmin()));
                } else if (currentIndex == 2) {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => new AccountSettingsAdmin()));
                } else {}
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
