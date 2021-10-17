import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/students/accounts_students.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class extra extends StatefulWidget{



  @override
  _extraState createState() => _extraState();

}
List select = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false];
List TeacherName = [];
class _extraState extends State<extra>{

  int currentIndex=0;
  int count = 0;

  Future<void> changestate() async{

    print(select);
    print(TeacherName[0]);
    print(TeacherName[1]);
    print(TeacherName[2]);
    User user = FirebaseAuth.instance.currentUser!;

    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    String username = snap['username'];


    FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'is_enabled_LC' : false,
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

    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new HomeStudents()));
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
                        count  = snapshot.data!.docs.length;
                        if (snapshot.hasData) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {

                              DocumentSnapshot teachers = snapshot.data!.docs[index];
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
                                                  TeacherName.insert(index,teachers.get('username'));

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


                  SizedBox(height: 20),
                  TextButton(
                      onPressed: (){
                        //apply(isSana,isDeepali);
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