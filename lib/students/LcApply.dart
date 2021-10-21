import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/students/accounts_students.dart';
import 'package:beproject/students/notificationforstudents.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LC_APPLY extends StatefulWidget{


  @override
  _LC_APPLYState createState() => _LC_APPLYState();

}


List select = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
List TeacherName = [];

class _LC_APPLYState extends State<LC_APPLY>{
  // bool isSana = false;
  // bool isDeepali = false;
  // bool isSejal = false;
  int currentIndex=0;
  int count =0;


  Future<void> changestate() async{


    User user = FirebaseAuth.instance.currentUser!;

    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    String username = snap['username'];


    FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'is_enabled_LC' : false,
      'canundo':true,
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
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('admin').set(
        {
          'status':'pending',
          'reason':'',
        });
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('ExamCell').set(
        {
          'status':'pending',
          'reason':'',
        });
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('TPO').set(
        {
          'status':'pending',
          'reason':'',
        });
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'admin').get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('NoDues')
          .doc('$username')
          .set({
        'status':'pending',
        'reason':'',
        'time':Timestamp.now(),
      });
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
          });
        });
      }
    }

    // Navigator.of(context).pushReplacement(
    //     new MaterialPageRoute(builder: (context) => new HomeStudents()));
    Navigator.of(context).pushNamedAndRemoveUntil('/firststudents', (Route<dynamic> route) => false);

  }


  // Future<void> apply(isSana, isDeepali) async
  // {
  //
  //   User user = FirebaseAuth.instance.currentUser!;
  //
  //   final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  //   String username = snap['username'];
  //
  //
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).update({
  //     'is_enabled_LC' : false,
  //   });
  //
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('workshop').set(
  //       {
  //         'status':'pending',
  //         'reason':'',
  //       });
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('library').set(
  //       {
  //         'status':'pending',
  //         'reason':'',
  //       });
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('accounts').set(
  //       {
  //         'status':'pending',
  //         'reason':'',
  //       });
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('admin').set(
  //       {
  //         'status':'pending',
  //         'reason':'',
  //       });
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('ExamCell').set(
  //       {
  //         'status':'pending',
  //         'reason':'',
  //       });
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('TPO').set(
  //       {
  //         'status':'pending',
  //         'reason':'',
  //       });
  //   FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'admin').get().then((list){
  //     FirebaseFirestore.instance.collection('users')
  //         .doc(list.docs[0].id)
  //         .collection('NoDues')
  //         .doc('$username')
  //         .set({
  //       'status':'pending',
  //       'reason':'',
  //       'time':Timestamp.now(),
  //     });
  //   });
  //
  //   FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'workshop').get().then((list){
  //     FirebaseFirestore.instance.collection('users')
  //         .doc(list.docs[0].id)
  //         .collection('NoDues')
  //         .doc('$username')
  //         .set({
  //       'status':'pending',
  //       'reason':'',
  //       'time':Timestamp.now(),
  //     });
  //   });
  //
  //   FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'library').get().then((list){
  //     FirebaseFirestore.instance.collection('users')
  //         .doc(list.docs[0].id)
  //         .collection('NoDues')
  //         .doc('$username')
  //         .set({
  //       'status':'pending',
  //       'reason':'',
  //       'time':Timestamp.now(),
  //     });
  //   });
  //
  //   FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'ExamCell').get().then((list){
  //     FirebaseFirestore.instance.collection('users')
  //         .doc(list.docs[0].id)
  //         .collection('NoDues')
  //         .doc('$username')
  //         .set({
  //       'status':'pending',
  //       'reason':'',
  //       'time':Timestamp.now(),
  //     });
  //   });
  //
  //   FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'TPO').get().then((list){
  //     FirebaseFirestore.instance.collection('users')
  //         .doc(list.docs[0].id)
  //         .collection('NoDues')
  //         .doc('$username')
  //         .set({
  //       'status':'pending',
  //       'reason':'',
  //       'time':Timestamp.now(),
  //     });
  //   });
  //   FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'accounts').get().then((list){
  //     FirebaseFirestore.instance.collection('users')
  //         .doc(list.docs[0].id)
  //         .collection('NoDues')
  //         .doc('$username')
  //         .set({
  //       'status':'pending',
  //       'reason':'',
  //       'time':Timestamp.now(),
  //     });
  //   });
  //
  //
  //
  //   if(isSana == true && isDeepali != true && isSejal != true){
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('sana').set(
  //         {
  //
  //           'status':'pending',
  //           'reason':'',
  //         });
  //     FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'sana').get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //   }
  //   else if(isDeepali == true && isSana != true && isSejal != true){
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('deepali').set(
  //         {
  //
  //           'status':'pending',
  //           'reason':'',
  //         });
  //     FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'deepali').get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //   }
  //
  //   else if(isSejal == true && isSana != true && isDeepali != true){
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('sejal').set(
  //         {
  //
  //           'status':'pending',
  //           'reason':'',
  //         });
  //     FirebaseFirestore.instance.collection('users').where("username", isEqualTo: 'sejal').get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //   }
  //
  //   else if(isDeepali == true && isSana == true && isSejal != true){
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('sana').set(
  //         {
  //           'status':'pending',
  //           'reason':'',
  //         });
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('deepali').set(
  //         {
  //           'status':'pending',
  //           'reason':'',
  //         });
  //
  //     FirebaseFirestore.instance.collection('users')
  //         .where("username", isEqualTo: 'sana')
  //         .get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //     FirebaseFirestore.instance.collection('users')
  //         .where("username", isEqualTo: 'deepali')
  //         .get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //   }
  //
  //   else if(isDeepali == true && isSana != true && isSejal == true){
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('sejal').set(
  //         {
  //           'status':'pending',
  //           'reason':'',
  //         });
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('deepali').set(
  //         {
  //           'status':'pending',
  //           'reason':'',
  //         });
  //
  //     FirebaseFirestore.instance.collection('users')
  //         .where("username", isEqualTo: 'sejal')
  //         .get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //     FirebaseFirestore.instance.collection('users')
  //         .where("username", isEqualTo: 'deepali')
  //         .get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //   }
  //
  //   else if(isDeepali != true && isSana == true && isSejal == true){
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('sana').set(
  //         {
  //           'status':'pending',
  //           'reason':'',
  //         });
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('sejal').set(
  //         {
  //           'status':'pending',
  //           'reason':'',
  //         });
  //
  //     FirebaseFirestore.instance.collection('users')
  //         .where("username", isEqualTo: 'sana')
  //         .get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //     FirebaseFirestore.instance.collection('users')
  //         .where("username", isEqualTo: 'sejal')
  //         .get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //   }
  //
  //   else {
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('sana').set(
  //         {
  //           'status':'pending',
  //           'reason':'',
  //         });
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('sejal').set(
  //         {
  //           'status':'pending',
  //           'reason':'',
  //         });
  //
  //     FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues').doc('deepali').set(
  //         {
  //           'status':'pending',
  //           'reason':'',
  //         });
  //
  //     FirebaseFirestore.instance.collection('users')
  //         .where("username", isEqualTo: 'sana')
  //         .get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //     FirebaseFirestore.instance.collection('users')
  //         .where("username", isEqualTo: 'sejal')
  //         .get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //
  //     FirebaseFirestore.instance.collection('users')
  //         .where("username", isEqualTo: 'deepali')
  //         .get().then((list){
  //       FirebaseFirestore.instance.collection('users')
  //           .doc(list.docs[0].id)
  //           .collection('NoDues')
  //           .doc('$username')
  //           .set({
  //         'status':'pending',
  //         'reason':'',
  //         'time':Timestamp.now(),
  //       });
  //     });
  //   }
  //   Navigator.of(context).pushReplacement(
  //       new MaterialPageRoute(builder: (context) => new HomeStudents()));
  // }

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

        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(

                children: <Widget>[

                  Container(

                    margin: const EdgeInsets.only(left: 30.0,top:75),
                    alignment: Alignment.topLeft,
                    child: Text('No Dues - Select your project guide.',
                      style: TextStyle(fontSize: 25,color: HexColor("#0E34A0")),
                    ),
                  ),
                  SizedBox(height: 20),

                  StreamBuilder(
                      stream:
                      FirebaseFirestore.instance.collection('users').where("role", isEqualTo: 'teachers').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {

                              DocumentSnapshot teachers = snapshot.data!.docs[index];
                              count  = snapshot.data!.docs.length;
                              TeacherName.insert(index,teachers.get('username'));
                              return ListTile(
                                // Access the fields as defined in FireStore
                                title: Column(
                                  children: <Widget>[
                                    SizedBox(height: 10,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[

                                          Text(teachers.get('username'),
                                            style: TextStyle(fontSize: 30, color:Colors.black),
                                          ),

                                          Transform.scale(
                                            scale: 2,
                                            child: Checkbox(

                                              checkColor: Colors.white,
                                              fillColor: MaterialStateProperty.resolveWith(getColor),
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
                        }  else {
                          // Still loading
                          return CircularProgressIndicator();
                        }
                      }
                  ),


                  // Container(
                  //   margin: const EdgeInsets.only(left: 20.0),
                  //   child:Row(
                  //
                  //     children: <Widget>[
                  //       Text('Prof. Sana Sheikh',
                  //         style: TextStyle(fontSize: 30),
                  //       ),
                  //       SizedBox(width: 86),
                  //       Transform.scale(
                  //         scale: 2,
                  //         child: Checkbox(
                  //
                  //           checkColor: Colors.white,
                  //           fillColor: MaterialStateProperty.resolveWith(getColor),
                  //           value: isSana,
                  //           onChanged: (bool? value) {
                  //             setState(() {
                  //               isSana = value!;
                  //             });
                  //           },
                  //         ),),
                  //     ],
                  //   ),),
                  //
                  // SizedBox(height: 20),
                  //
                  // Container(
                  //   margin: const EdgeInsets.only(left: 20.0),
                  //   child:Row(
                  //
                  //     children: <Widget>[
                  //       Text('Prof. Sejal Chopra',
                  //         style: TextStyle(fontSize: 30),
                  //       ),
                  //       SizedBox(width: 86),
                  //       Transform.scale(
                  //         scale: 2,
                  //         child: Checkbox(
                  //
                  //           checkColor: Colors.white,
                  //           fillColor: MaterialStateProperty.resolveWith(getColor),
                  //           value: isSejal,
                  //           onChanged: (bool? value) {
                  //             setState(() {
                  //               isSejal = value!;
                  //             });
                  //           },
                  //         ),),
                  //     ],
                  //   ),),
                  //
                  // SizedBox(height: 20),
                  //
                  // Container(
                  //   margin: const EdgeInsets.only(left: 20.0),
                  //   child:Row(
                  //
                  //     children: <Widget>[
                  //       Text('Prof. Deepali Kayande',
                  //         style: TextStyle(fontSize: 30),
                  //       ),
                  //       SizedBox(width: 30),
                  //       Transform.scale(
                  //         scale: 2,
                  //         child: Checkbox(
                  //
                  //           checkColor: Colors.white,
                  //           fillColor: MaterialStateProperty.resolveWith(getColor),
                  //           value: isDeepali,
                  //           onChanged: (bool? value) {
                  //             setState(() {
                  //               isDeepali = value!;
                  //             });
                  //           },
                  //         ),),
                  //     ],
                  //   ),),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: (){
                        changestate();
                      },
                      child: Text('Apply for No Dues', style:TextStyle(fontSize: 30, color:HexColor("#0E34A0")))),

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