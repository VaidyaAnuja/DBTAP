
import 'package:beproject/library/account_library.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class HomeLibrary extends StatefulWidget {
  @override
  _HomeLibraryState createState() => _HomeLibraryState();
}

class _HomeLibraryState extends State<HomeLibrary> with SingleTickerProviderStateMixin {

  Future<void> approve(id) async {
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    String username = snap['username'];
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').doc(id).update(
        {'status':'approved',
        'reason':''
        });
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('No Dues')
          .doc('$username')
          .update({
        'status':'approved',
        'reason':'',
      });
    });
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new HomeLibrary()));
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
        new MaterialPageRoute(builder: (context) => new HomeLibrary()));
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
        'reason':''
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
        new MaterialPageRoute(builder: (context) => new HomeLibrary()));
  }}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: new TabBar(controller: _controller, tabs: <Tab>[

          new Tab(text: "All"),
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
                                    SizedBox(width: 20,),
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
                                                  SizedBox(width: 20,),
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
                                                  ])
                                            ]),));

                                }


                              });}
                        else {
                          // Still loading
                          return CircularProgressIndicator();
                        }

                      }),

                ],
              ),
            ),)],
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
                                                      SizedBox(width: 20,),
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
                                                        SizedBox(width: 20,),
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
                                                        ])
                                                  ]),));

                                      }


                                    });}
                              else {
                                // Still loading
                                return CircularProgressIndicator();
                              }

                            }),

                      ],
                    ),
                  ),)],
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
                        Row(children:[
                          Container(
                              width: 200,
                              margin: const EdgeInsets.only(left: 50.0),
                              child: TextField(
                                controller: reqdept,
                                decoration: InputDecoration(
                                    labelText: "Enter department",

                                    labelStyle: TextStyle(fontSize: 25)
                                ),
                                style: TextStyle(fontSize: 25,),
                              )),
                          SizedBox(width:20),
                          TextButton(
                              onPressed: (){
                                setState(() {
                                  whatisdept = reqdept.text.trim();
                                });
                                // whatisdept = reqdept.text.trim();
                              },
                              child: Icon(
                                Icons.person_search ,
                                color: HexColor("#0E34A0"),
                                size: 40,
                              )

                          ),

                        ]),
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
                                      if(nodues.get('branch') == whatisdept){
                                      if(nodues.get('status') == 'pending'){
                                        return ListTile(

                                          title: Container(
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
                                                      SizedBox(width: 20,),
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
                                                        SizedBox(width: 20,),
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
                                                        ])
                                                  ]),));

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
                  ),)],
            ),


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
                      builder: (context) => new HomeLibrary()));
                      } else  {
                      Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => new AccountSettingsLibrary()));
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
