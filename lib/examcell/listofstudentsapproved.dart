import 'package:beproject/examcell/account_ExamCell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class Approved_List extends StatefulWidget {
  @override
  _Approved_ListState createState() => _Approved_ListState();
}

class _Approved_ListState extends State<Approved_List> {

  Future<Text> getifapproved(id) async {
    final snap = await FirebaseFirestore.instance.collection('users').where("username", isEqualTo: '$id').get();
    var uid = snap.docs[0].data()['uid'];
    final snapshot = FirebaseFirestore.instance.collection('users').doc(uid).collection('No Dues').snapshots();

    int i;
    print('something');
    // for (i=0; i<snap.size; i++){
    //   if(snap.docs[i].data()['status'] == 'approved'){
    //      checkiftrue = true;
    //   }
    //   else{
    //     checkiftrue = false;
    //   }
    // }
    return Text('');
  }

  bool checkiftrue = false;
  int currentIndex = 0;
  final TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DBTap',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        toolbarHeight: 35,
        centerTitle: true,
        backgroundColor: HexColor("#0E34A0"),
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
      body: Stack(
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
                      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('NoDues').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot nodues = snapshot.data!.docs[index];
                                getifapproved(nodues.id);
                                print(checkiftrue);
                                if(checkiftrue == 'true'){
                                  return ListTile(

                                    title: Container(
                                      margin: const EdgeInsets.only(left: 30.0, top: 30),
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            nodues.id,
                                            style: TextStyle(
                                                fontSize: 20, color: HexColor("#0E34A0")),
                                          ),
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
                  Navigator.of(context).pushNamedAndRemoveUntil('/firstexam', (Route<dynamic> route) => false);
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
          ),
        ],
      ),
    );
  }
}
