import 'dart:typed_data';
import 'dart:io';
import 'package:beproject/students/Homeforstudents.dart';
import 'package:beproject/students/accounts_students.dart';
import 'package:beproject/students/notificationforstudents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:screenshot/screenshot.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart ' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';


class LOR_PROGRESS extends StatefulWidget{

  @override
  _LOR_PROGRESSState createState() => _LOR_PROGRESSState();

}

bool checkiftrue = false;
class _LOR_PROGRESSState extends State<LOR_PROGRESS>{

  int currentIndex=0;
  final TextEditingController yearofpassing = TextEditingController();
  final TextEditingController topicofbeproject = TextEditingController();
  final TextEditingController Name = TextEditingController();
  final TextEditingController currentstat = TextEditingController();
  final TextEditingController reasonforlor = TextEditingController();
  final TextEditingController emailid = TextEditingController();
  final TextEditingController contactnum = TextEditingController();

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
  bool atleastone = false;
  Future<void> changestate(TextEditingController name, TextEditingController yearofpassing, TextEditingController topicofbeproject, TextEditingController currentstat, TextEditingController reasonforlor, TextEditingController email, TextEditingController contact) async{


    User user = FirebaseAuth.instance.currentUser!;

    //print(username);
    if(name.text=="" || contact.text.length != 10 || double.tryParse(contact.text)== null || double.tryParse(yearofpassing.text)== null || topicofbeproject.text=="" || currentstat.text=="" || reasonforlor.text=="" || email.text==""){

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
    else {


      FirebaseFirestore.instance.collection('users').doc(user.uid)
          .collection('LOR_General').doc('General')
          .update(
          {
            'fullname':name.text.trim(),
            'contactnum':contact.text.trim(),
            'yearofpassing':yearofpassing.text.trim(),
            'beproject':topicofbeproject.text.trim(),
            'reasonforlor':reasonforlor.text.trim(),
            'currentstat':currentstat.text.trim(),
            'emailid':emailid.text.trim()
          });




      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new LOR_PROGRESS()));
    }

  }



  Future<bool> getifapproved() async {
    User user = FirebaseAuth.instance.currentUser!;
      final data = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('LOR').get();

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


    return checkiftrue;
  }
  Future<void> reapply(String nameofteacher) async {
    User user = FirebaseAuth.instance.currentUser!;

    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    String username = snap['username'];
    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('LOR').doc(nameofteacher).update(
        {
          'status':'pending',
          'reason':'',
        });
    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: nameofteacher).get().then((list){
      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('LOR')
          .doc('$username')
          .update({
        'status':'pending',
        'reason':'',
        'time':Timestamp.now(),
      });
    });
  }


  Future<void> deleteapplication(int numofdocs, String nameofteachers) async {
    User user = FirebaseAuth.instance.currentUser!;
    var snapss = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    var username = snapss.data()!['username'];


    //String name = nameofteachers[i];

    FirebaseFirestore.instance.collection('users').where("username", isEqualTo: nameofteachers).get().then((list){

      FirebaseFirestore.instance.collection('users')
          .doc(list.docs[0].id)
          .collection('LOR')
          .doc('$username')
          .delete();
    });

    FirebaseFirestore.instance.collection('users').doc(user.uid).collection('LOR').doc(nameofteachers).delete();
    if(numofdocs==1){
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'LOR_applied' : false,
      });
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeStudents()));
    }

 else{
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => new LOR_PROGRESS()));}

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

                  // Screenshot(
                             //     controller: screenshotController,
                             //     child:
                      Column(children:[


                        SizedBox(height:10),
                        Text('LOR progress here'),

                        StreamBuilder(
                            stream:
                            FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('LOR').snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                               int numofdocs = snapshot.data!.docs.length;
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
                                                    width: 140,
                                                    child: Text(nodues.id

                                                    ),
                                                  ),
                                                  Text(':'),
                                                  SizedBox(
                                                    width: 20,),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text('Pending', style: TextStyle( color:Colors.blue),

                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,),
                                                  IconButton(onPressed: (){
                                                    deleteapplication(numofdocs, nodues.id);
                                                  },
                                                    iconSize: 30,
                                                    icon: Icon(Icons.delete),
                                                  )
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
                                                    width: 140,
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
                                            Row(
                                                children: <Widget>[
                                                  TextButton(onPressed: ()=> showDialog<String>(
                                                      context: context,
                                                      builder: (BuildContext context) => AlertDialog(
                                                        title: Column(children:[
                                                          Text(nodues.get('message')),
                                                          SizedBox(height: 10,),
                                                          Text(nodues.get('availability')),
                                                          SizedBox(height: 10,),
                                                          Text(nodues.get('emailteacher')),
                                                          SizedBox(height: 10,),
                                                          Text(nodues.get('contactteacher')),
                                                        ]))),
                                                    child: Row(children:[
                                                      SizedBox(
                                                        width: 5,),
                                                      SizedBox(
                                                        width: 170,
                                                        child: Text('See Message', style: TextStyle( color:Colors.green),

                                                        ),
                                                      ),]),

                                                  ),
                                                ]),

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
                                                    width: 140,
                                                    child: Text(nodues.id

                                                    ),
                                                  ),
                                                  Text(':'),
                                                  SizedBox(
                                                    width: 20,),
                                                  SizedBox(
                                                    width: 140,
                                                    child: Text('Rejected', style: TextStyle( color:Colors.red),

                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,),
                                                  IconButton(onPressed: (){
                                                    deleteapplication(numofdocs, nodues.id);
                                                  },
                                                    iconSize: 30,
                                                    icon: Icon(Icons.delete),
                                                  )

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

                                                  ),
                                                  // SizedBox(
                                                  //   width: 10,),
                                                  TextButton(
                                                      onPressed: () {
                                                        reapply(nodues.id);
                                                      },
                                                      child: Text('Reapply',
                                                          style: TextStyle( color: HexColor(
                                                              "#0E34A0")))),
                                                ]),

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
                        ),]),
                  // ElevatedButton(
                  //   // style: ,
                  //   onPressed: (){
                  //     screenshotController
                  //         .capture(
                  //       //delay: Duration(milliseconds: 10)
                  //     )
                  //         .then((image) async {
                  //       getPdf(image!);
                  //       // setState(() {
                  //       //    screenShot = image!;
                  //       // });
                  //     }).catchError((onError) {
                  //       print(onError);
                  //     });
                  //     // getPdf(screenShot);
                  //   },
                  //   child: const Text('Print'),
                  // ),
                  SizedBox(height:80),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('LOR_General').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot studentdetails = snapshot.data!.docs[index];

                                //var count = snapshot.data!.docs.length;
                                getifapproved();
                                if(checkiftrue){
                                  return ListTile(
                                    //dense:true,
                                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                    // Access the fields as defined in FireStore
                                    title: Column(
                                      children: <Widget>[
                                        //SizedBox(height: 10,),
                                        SizedBox(
                                          width: 170,
                                          child: Text('Full Name',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 170,
                                          child: Text(studentdetails.get('fullname'),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 170,
                                          child: Text('Year of passing',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 170,
                                          child: Text(studentdetails.get('yearofpassing'),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 170,
                                          child: Text('BE project topic',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 170,
                                          child: Text(studentdetails.get('beproject'),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 170,
                                          child: Text('Current status',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 170,
                                          child: Text(studentdetails.get('currentstat'),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 170,
                                          child: Text('Reason for LOR',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 170,
                                          child: Text(studentdetails.get('reasonforlor'),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 170,
                                          child: Text('Email ID',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 170,
                                          child: Text(studentdetails.get('emailid'),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          width: 170,
                                          child: Text('Contact number',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),

                                        SizedBox(
                                          width: 170,
                                          child: Text(studentdetails.get('contactnum'),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),



                                        SizedBox(height: 80),
                                        //SizedBox(height: 10,),
                                      ],
                                    ),
                                  );
                                }
                                else{
                                  return ListTile(
                                  //dense:true,
                                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                                  // Access the fields as defined in FireStore
                                  title: Column(
                                  children: <Widget>[
                                  //SizedBox(height: 10,),
                                    SizedBox(
                                      width: 170,
                                      child: Text('Full Name',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 170,
                                      child: TextField(
                                        controller: Name..text= studentdetails.get('fullname'),
                                        decoration: InputDecoration(
                                            hintText: studentdetails.get('fullname'),
                                        ),
                                        style: TextStyle(fontSize: 25,),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 170,
                                      child: Text('Year of passing',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 170,
                                      child: TextField(
                                        controller: yearofpassing..text=studentdetails.get('yearofpassing'),
                                        decoration: InputDecoration(
                                          hintText: studentdetails.get('yearofpassing'),
                                        ),
                                        style: TextStyle(fontSize: 25,),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 170,
                                      child: Text('BE project topic',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 170,
                                      child: TextField(
                                        controller: topicofbeproject..text=studentdetails.get('beproject'),
                                        decoration: InputDecoration(
                                          hintText: studentdetails.get('beproject'),
                                        ),
                                        style: TextStyle(fontSize: 25,),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 170,
                                      child: Text('Current status',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 170,
                                      child: TextField(
                                        controller: currentstat..text=studentdetails.get('currentstat'),
                                        decoration: InputDecoration(
                                          hintText: studentdetails.get('currentstat'),
                                        ),
                                        style: TextStyle(fontSize: 25,),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 170,
                                      child: Text('Reason for LOR',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 170,
                                      child: TextField(
                                        controller: reasonforlor..text=studentdetails.get('reasonforlor'),
                                        decoration: InputDecoration(
                                          hintText: studentdetails.get('reasonforlor'),
                                        ),
                                        style: TextStyle(fontSize: 25,),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 170,
                                      child: Text('Email ID',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 170,
                                      child: TextField(
                                        controller: emailid..text=studentdetails.get('emailid'),
                                        decoration: InputDecoration(
                                          hintText: studentdetails.get('emailid'),
                                        ),
                                        style: TextStyle(fontSize: 25,),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    SizedBox(
                                      width: 170,
                                      child: Text('Contact number',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),

                                    SizedBox(
                                      width: 170,
                                      child: TextField(
                                        controller: contactnum..text=studentdetails.get('contactnum'),
                                        decoration: InputDecoration(
                                          hintText: studentdetails.get('contactnum'),
                                        ),
                                        style: TextStyle(fontSize: 25,),
                                      ),
                                    ),
                                    SizedBox(height:10),
                                    TextButton(
                                        onPressed: () {
                                          bool isValid = EmailValidator.validate(emailid.text);
                                          if (isValid) {
                                            changestate(Name, yearofpassing, topicofbeproject, currentstat, reasonforlor, emailid, contactnum);}
                                          else{
                                            emailerror();
                                          }

                                        },
                                        child: Text('Save Changes',
                                            style: TextStyle(fontSize: 30, color: HexColor(
                                                "#0E34A0")))),


                                    SizedBox(height: 80),
                                          //SizedBox(height: 10,),
                                          ],
                                          ),
                                          );
                                }
                              });}
                        else {
                          // Still loading
                          return CircularProgressIndicator();
                        }

                      }),


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