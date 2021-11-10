
import 'package:beproject/students/accounts_students.dart';
import 'package:beproject/students/commonapplications.dart';
import 'package:beproject/students/deletefromothers.dart';
import 'package:beproject/students/lcprogress.dart';
import 'package:beproject/students/notificationforstudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class HomeStudents extends StatefulWidget{

  @override
  _HomeStudentsState createState() => _HomeStudentsState();

}



class _HomeStudentsState extends State<HomeStudents>{
  int currentIndex =0;
  // Future<void> deleteapplication() async {
  //   User user = FirebaseAuth.instance.currentUser!;
  //
  //   FirebaseFirestore.instance.collection('users').doc(user.uid).update({
  //     'is_enabled_LC' : true,
  //   });
  //
  //   final collectionRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('No Dues');
  //   final futureQuery = collectionRef.get();
  //   await futureQuery.then((value) => value.docs.forEach((element) {
  //     element.reference.delete();
  //   }));
  //
  //   // FirebaseFirestore.instance.collection('users')
  //   //     .doc(user.uid)
  //   //     .collection('Applications')
  //   //     .where("applicationtype", isEqualTo: 'No Dues')
  //   //     .get()
  //   //     .then((list) {
  //   //   FirebaseFirestore.instance.collection('users')
  //   //       .doc(user.uid)
  //   //       .collection('Applications')
  //   //       .doc(list.docs[0].id)
  //   //       .delete();
  //   // });
  // }

  Future<bool> displayifallapproved() async{
     final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    String username = snap['username'];

    final snapss = await await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('No Dues').doc('ExamCell').get();
    mssg = snapss['message'];
    return true;

  }

  Future<DocumentSnapshot>_getuserdetails() async{

    User user = FirebaseAuth.instance.currentUser!;

    return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  }
static String mssg = '';
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  // final FirebaseMessaging _fcm = FirebaseMessaging();


  @override
  // void initState() {
  //   super.initState();
  //   if (Platform.isIOS) {
  //     var iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
  //       // save the token  OR subscribe to a topic here
  //     });
  //     _fcm.requestNotificationPermissions(IosNotificationSettings());
  //   }
  //   else{
  //     _saveDeviceToken();
  //   }
  //
  //   _fcm.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //       showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           content: ListTile(
  //             title: Text(message['notification']['title']),
  //             subtitle: Text(message['notification']['body']),
  //           ),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: Text('Ok'),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //       // TODO optional
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //       // TODO optional
  //     },
  //   );
  // }
  //
  // _saveDeviceToken() async {
  //   // Get the current user
  //   User user = FirebaseAuth.instance.currentUser!;
  //
  //   final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  //   String uid = snap['uid'];
  //   // FirebaseUser user = await _auth.currentUser();
  //
  //   // Get the token for this device
  //   String fcmToken = await _fcm.getToken();
  //
  //   // Save it to Firestore
  //   if (fcmToken != null) {
  //     var tokens = _db
  //         .collection('users')
  //         .doc(uid)
  //         .collection('tokens')
  //         .doc(fcmToken);
  //
  //     await tokens.set({
  //       'token': fcmToken,
  //
  //       'createdAt': FieldValue.serverTimestamp(), // optional
  //       'platform': Platform.operatingSystem // optional
  //     });
  //   }
  // }


  Widget build(BuildContext context){
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
                    margin: const EdgeInsets.only(left: 30.0,top:30),
                    alignment: Alignment.topLeft,
                    child: Text('Applications',
                      style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                    ),
                  ),
                  //SizedBox(height: 20),

                  FutureBuilder(
                    future: _getuserdetails(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData){
                        // displayifallapproved();
                        if (snapshot.data!['is_enabled_LC'] ) {
                          return Text("");
                        }

                        else  if (snapshot.data!['is_enabled_LC']== false && snapshot.data!['canundo'] == true){
                          return Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                Container(
                                    padding: EdgeInsets.only(left:75),
                                    child:Row(
                                        children: <Widget>[
                                          TextButton(
                                              onPressed: (){
                                                Navigator.of(context).push(
                                                    new MaterialPageRoute(builder: (context) => new LC_PROGRESS()));
                                              },
                                              child: Text('No Dues',
                                                style: TextStyle(fontSize: 30, color:Colors.black),
                                              )),
                                          SizedBox(width: 125),
                                          IconButton(onPressed: (){
                                            Navigator.of(context).pushReplacement(
                                                new MaterialPageRoute(builder: (context) => new delete_Others()));
                                          },
                                            iconSize: 30,
                                            icon: Icon(Icons.delete),
                                          )


                                        ]))]);
                        }
                          else{
                          displayifallapproved();
                            return Column(
                              children: <Widget>[
                                SizedBox(height: 20,),
                                Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      SizedBox(width: 45,),
                                      Text('No Dues',
                                        style: TextStyle(fontSize: 30, color:Colors.black),
                                      ),
                                      SizedBox(width: 90),
                                      Text('All Approved', style: TextStyle(fontSize: 25, color:Colors.blue),),
                                    ]
                                ),
                                Row(
                                    children: <Widget>[
                                      SizedBox(width: 45,),
                                      TextButton(onPressed: ()=> showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) => AlertDialog(
                                            title: Text(mssg),)),
                                        child: Text('See Message', style: TextStyle(fontSize: 20, color:Colors.green),),),
                                    ]
                                ),
                                SizedBox(height: 10,),
                              ],
                            );
                        }

                      }
                      else{
                        return CircularProgressIndicator();
                      }

                      // return CircularProgressIndicator();
                    },
                  ),




                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 290.0),
                    child: TextButton(
                        onPressed: (){
                          Navigator.of(context).push(
                              new MaterialPageRoute(builder: (context) => new Common_App()));
                        },
                        child: Icon(
                          Icons.my_library_add ,
                          color: HexColor("#0E34A0"),
                          size: 40,
                        )

                    ),),
                  Divider(
                    color: HexColor("#0E34A0"),
                    height: 20,
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  ),
                  SizedBox(height: 30),


                  Container(
                    margin: const EdgeInsets.only(left: 30.0,top:30),
                    alignment: Alignment.topLeft,
                    child: Text('Academics',
                      style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 290.0),
                    child: TextButton(
                        onPressed: (){},
                        child: Icon(
                          Icons.my_library_add ,
                          color: HexColor("#0E34A0"),
                          size: 40,
                        )

                    ),),
                  Divider(
                    color: HexColor("#0E34A0"),
                    height: 20,
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  ),

                  SizedBox(height: 30),


                  Container(
                    margin: const EdgeInsets.only(left: 30.0,top:30),
                    alignment: Alignment.topLeft,
                    child: Text('Internships',
                      style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 290.0),
                    child: TextButton(
                        onPressed: (){},
                        child: Icon(
                          Icons.my_library_add ,
                          color: HexColor("#0E34A0"),
                          size: 40,
                        )

                    ),),
                  Divider(
                    color: HexColor("#0E34A0"),
                    height: 20,
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  ),

                  SizedBox(height: 30),


                  Container(
                    margin: const EdgeInsets.only(left: 30.0,top:30),
                    alignment: Alignment.topLeft,
                    child: Text('Extra-curricular',
                      style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 290.0),
                    child: TextButton(
                        onPressed: (){},
                        child: Icon(
                          Icons.my_library_add ,
                          color: HexColor("#0E34A0"),
                          size: 40,
                        )

                    ),),
                  Divider(
                    color: HexColor("#0E34A0"),
                    height: 20,
                    thickness: 2,
                    indent: 30,
                    endIndent: 30,
                  ),
                  SizedBox(height: 100),
                ],

              ),
            ),
          ),


          Container(
            margin: const EdgeInsets.only(top: 564.0),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 0,
              onTap: (index) { setState(() { currentIndex = index;});
              if(currentIndex==0){
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => new HomeStudents()));
              }
              else if(currentIndex==2){
                Navigator.of(context).pushReplacement(
                    new MaterialPageRoute(builder: (context) => new AccountSettings()));
              }
              else{
                Navigator.of(context).pushReplacement(
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