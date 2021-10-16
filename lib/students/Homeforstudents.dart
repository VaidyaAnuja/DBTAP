import 'package:beproject/students/accounts_students.dart';
import 'package:beproject/students/commonapplications.dart';
import 'package:beproject/students/deletefromothers.dart';
import 'package:beproject/students/lcprogress.dart';
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
  //   print(numofdocs);
  //   print(nameofteachers);
  //   final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  //   String username = snap['username'];
  //
  //   var i;
  //   // for(i = 0 ; i<numofdocs; i++){
  //   //   //String name = nameofteachers[i];
  //   //
  //   //   FirebaseFirestore.instance.collection('users').where("username", isEqualTo: nameofteachers[i]).get().then((list){
  //   //
  //   //     FirebaseFirestore.instance.collection('users')
  //   //         .doc(list.docs[0].id)
  //   //         .collection('NoDues')
  //   //         .doc('$username')
  //   //         .delete();
  //   //   });
  //   // }
  //   nameofteachers.clear();
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
  //
  //
  //
  //   Navigator.of(context).pushReplacement(
  //       new MaterialPageRoute(builder: (context) => new HomeStudents()));
  //
  // }

  Future<DocumentSnapshot>_getuserdetails() async{
    User user = FirebaseAuth.instance.currentUser!;
    return FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('DBTap', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        toolbarHeight: 35,
        centerTitle: true,
        backgroundColor: HexColor("#0E34A0"),
        actions: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded ,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
              },
            ),),
        ],
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
                      if (snapshot.data!['is_enabled_LC']) {
                        return Text("");
                      }

                      else  {
                        return Column(
                            children: <Widget>[
                            SizedBox(height: 20),
                            Container(
                            padding: EdgeInsets.only(left:75),
                            child:Row(
                                children: <Widget>[
                                  TextButton(
                                      onPressed: (){
                                        Navigator.of(context).pushReplacement(
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
                      }}
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
                          Navigator.of(context).pushReplacement(
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
              else{}
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