import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:beproject/authorization.dart';
 //import 'package:responsive_widgets/responsive_widgets.dart';


class LoginScr extends StatefulWidget{
  static const routeName = '/login';
  @override
  _LoginScrState createState() => _LoginScrState();
}

class _LoginScrState extends State<LoginScr>{
  String email = '';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _checkUser( TextEditingController usernameController, TextEditingController passwordController) async {
    final snap = await FirebaseFirestore.instance.collection('users').where("username", isEqualTo: usernameController.text.trim()).get();
    print(snap.docs);
    if(snap.size != 0){
      email = snap.docs[0].data()['email'];
      context.read<AuthenticationService>().signIn(
        email: email,
        password: passwordController.text.trim(),
        context: context,
      );
    }
    else{
      final text = 'Incorrect username. Please check again.';
      final snackBar = SnackBar(

        duration: Duration(seconds: 30),
        content: Text(text,
          style: TextStyle(fontSize:16, color: Colors.white),),
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

  }


  @override
  Widget build(BuildContext context){
     return Scaffold(
        appBar: AppBar(
          title: Text('DBTap', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: HexColor("#0E34A0"),
        ),
        body: Stack(
        children: <Widget>[
          Container(

            decoration: BoxDecoration(

                color: Colors.white
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   colors: [
              //
              //     HexColor("#0E34A0"),
              //     HexColor("#5497A7"),
              //     HexColor("#FFFFFF"),
              //     HexColor("#544B3D"),
              //     HexColor("#140D4F"),
              //
              //   ]
              // )
            ),
          ),

          Container(
            height: 30,
            margin:  const EdgeInsets.only(top: 530.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: HexColor("#0E34A0"),),),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),

              child: Container(
                height: 330,
                width: 300,
                padding: EdgeInsets.all(16),

                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Login',
                            style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                          ),
                        ),

                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            labelText: "Username",

                              labelStyle: TextStyle(fontSize: 30)
                          ),
                          style: TextStyle(fontSize: 25,),
                        ),

                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                              labelStyle: TextStyle(fontSize: 30)
                          ),
                          obscureText: true,
                          style: TextStyle(fontSize: 25,),
                        ),




                        Container(
                          //alignment: Alignment.bottomRight,
                          width: 250,
                          height: 60,
                          margin: const EdgeInsets.only(top: 15.0),
                          child: RaisedButton(

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            onPressed: (){
                              _checkUser(usernameController, passwordController);

                            },

                            color: HexColor("#0E34A0"),
                            child: Text('Login',
                              style:TextStyle(fontSize: 30,
                                color: Colors.white,)

                            ),
                          ),

                        ),


                        // BottomNavigationBar(
                        //   backgroundColor: HexColor("#0E34A0"),
                        //   currentIndex: 0, // this will be set when a new tab is tapped
                        //   items: [
                        //     BottomNavigationBarItem(
                        //       icon: new Icon(Icons.home),
                        //       title: new Text('Home'),
                        //     ),
                        //     BottomNavigationBarItem(
                        //       icon: new Icon(Icons.mail),
                        //       title: new Text('Messages'),
                        //     ),
                        //
                        //   ],
                        // ),
                      ],

                    ),
                  ),
                ),
              ),
            ),



        ],
      ),
    );
  }
}