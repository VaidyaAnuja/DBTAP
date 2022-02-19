import 'package:beproject/examcell/HomeExamCell.dart';
import 'package:beproject/examcell/account_ExamCell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class Approved_List extends StatefulWidget {
  @override
  _Approved_ListState createState() => _Approved_ListState();
}
List<bool> checkiftrue1 = List.filled(300, false, growable: true);


class _Approved_ListState extends State<Approved_List> with SingleTickerProviderStateMixin {

  Future<bool> getifapproved(count) async {
    var j;
    bool checkiftrue = false;
    for(j =0 ; j<count; j++){
    final snap = await FirebaseFirestore.instance.collection('users').where("username", isEqualTo: studentname[j]).get();
    var uid = snap.docs[0].data()['uid'];
    final data = await FirebaseFirestore.instance.collection('users').doc(uid).collection('No Dues').get();

    int i;
    for (i=0; i<data.size; i++){
      if(data.docs[i].data()['status'] == 'approved'){
         checkiftrue = true;
      }
      else{

        checkiftrue = false;
        break;
      }
    }
    checkiftrue1.insert(j,checkiftrue);

    }

    return true;
  }

  Future<void> undodisable(id, TextEditingController message) async {

      // var snap = await FirebaseFirestore.instance.collection('users').where('username',isEqualTo: id).get().then((list){
      //   FirebaseFirestore.instance.collection('users')
      //       .doc(list.docs[0].id)
      //       .get();});
      // print(snap.docs[0].data()['canundo']);

    // if(snap.docs[0].data()['canundo']){
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String username = snap['username'];
    // FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').doc(id).update(
    //     {
    //       'message':message.text,
    //     });
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('No Dues')
          .doc('$username')
          .update({
        'message':message.text,
      });
    });
    FirebaseFirestore.instance.collection('users').where('username', isEqualTo: id).get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id).update(
        {
          'canundo':false,
        });});

  //}
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new Approved_List()));

  }
  late int currentIndex;
  late TabController _controller ;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    currentIndex = 0;
  }

  List studentname = [];
  // int currentIndex = 0;
  final TextEditingController message = TextEditingController();
  final TextEditingController reqdept = TextEditingController();
  String whatisdept ="";
  bool isSelectedcomp = false;
  bool isSelectedit = false;
  bool isSelectedextc = false;
  bool isSelectedmech = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: new TabBar(controller: _controller, tabs: <Tab>[

          new Tab(text: "Time"),
          new Tab(text: "SeatNumber"),
          new Tab(text: "Branch"),
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
                      'Students for which all faculties have approved',
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
                                studentname.insert(index,nodues.id);
                                var count = snapshot.data!.docs.length;
                                getifapproved(count);
                                if(checkiftrue1[index]){
                                  return new ListTile(

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
                                          SizedBox(width: 20,),
                                          Text(
                                            nodues.id,
                                            style: TextStyle(
                                                fontSize: 20, color: HexColor("#0E34A0")),
                                          ),
                                          SizedBox(width:30),
                                          ElevatedButton(
                                            onPressed: () => showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: const Text(
                                                    'Send Message'),
                                                actions: <Widget>[
                                                  TextField(
                                                    controller: message,
                                                    decoration: InputDecoration(
                                                        labelText: "Please write a message",

                                                        labelStyle: TextStyle(fontSize: 20)
                                                    ),
                                                    style: TextStyle(fontSize: 15,),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      undodisable(nodues.id,message);
                                                      },
                                                    child: const Text('SEND'),
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
                                                'Send Message',
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
                                            ]),])

                                    ),);
                                }
                                else{
                                  return Text('');
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
          ]),

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
                              'Students for which all faculties have approved',
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
                                        studentname.insert(index,nodues.id);
                                        var count = snapshot.data!.docs.length;
                                        getifapproved(count);
                                        if(checkiftrue1[index]){
                                          return new ListTile(

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
                                                    SizedBox(width: 20,),
                                                    Text(
                                                      nodues.id,
                                                      style: TextStyle(
                                                          fontSize: 20, color: HexColor("#0E34A0")),
                                                    ),
                                                    SizedBox(width:30),
                                                    ElevatedButton(
                                                      onPressed: () => showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text(
                                                              'Send Message'),
                                                          actions: <Widget>[
                                                            TextField(
                                                              controller: message,
                                                              decoration: InputDecoration(
                                                                  labelText: "Please write a message",

                                                                  labelStyle: TextStyle(fontSize: 20)
                                                              ),
                                                              style: TextStyle(fontSize: 15,),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                undodisable(nodues.id,message);
                                                              },
                                                              child: const Text('SEND'),
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
                                                          'Send Message',
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
                                                      ]),])

                                            ),);
                                        }
                                        else{
                                          return Text('');
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
                ]),


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
                              'Students for which all faculties have approved',
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
                                        studentname.insert(index,nodues.id);
                                        var count = snapshot.data!.docs.length;
                                        getifapproved(count);
                                        if(nodues.get('branch') == whatisdept){
                                        if(checkiftrue1[index]){
                                          return new ListTile(

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
                                                    SizedBox(width: 20,),
                                                    Text(
                                                      nodues.id,
                                                      style: TextStyle(
                                                          fontSize: 20, color: HexColor("#0E34A0")),
                                                    ),
                                                    SizedBox(width:30),
                                                    ElevatedButton(
                                                      onPressed: () => showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext context) => AlertDialog(
                                                          title: const Text(
                                                              'Send Message'),
                                                          actions: <Widget>[
                                                            TextField(
                                                              controller: message,
                                                              decoration: InputDecoration(
                                                                  labelText: "Please write a message",

                                                                  labelStyle: TextStyle(fontSize: 20)
                                                              ),
                                                              style: TextStyle(fontSize: 15,),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                undodisable(nodues.id,message);
                                                              },
                                                              child: const Text('SEND'),
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
                                                          'Send Message',
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
                                                      ]),])

                                            ),);
                                        }
                                        else{
                                          return Text('');
                                        }


                                      }
                                      else{
                                      return Text("");

                                      }}
                                        );}
                                else {
                                  // Still loading
                                  return CircularProgressIndicator();
                                }

                              }),

                        ],
                      ),
                    ),
                  ),
                ]),




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
                // Navigator.of(context).pushNamedAndRemoveUntil('/firstexam', (Route<dynamic> route) => false);
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                builder: (context) => new Approved_List()));
                } else  {
                Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new AccountSettingsExamCell()));
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
