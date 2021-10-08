import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';



class LoginScr extends StatefulWidget{
  static const routeName = '/login';
  @override
  _LoginScrState createState() => _LoginScrState();

}

class _LoginScrState extends State<LoginScr>{
  final GlobalKey<FormState> _formkey = GlobalKey();


  void _submit(){

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
            margin: const EdgeInsets.only(top: 530.0),
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

                child: Form(
                  key: _formkey ,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('Login',
                            style: TextStyle(fontSize: 30,color: HexColor("#0E34A0")),
                          ),
                        ),

                        TextFormField(
                            decoration: InputDecoration(labelText: 'Username', labelStyle: TextStyle(fontSize: 30)),
                            keyboardType: TextInputType.text,
                            style: TextStyle(fontSize: 30,),
                            validator: (value)
                            {
                              if(value!.isEmpty || value.contains('@'))
                              {
                                return 'invalid email';
                              }
                              return null;
                            },
                            onSaved :(value){

                            }
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Password', labelStyle: TextStyle(fontSize: 30)),
                          obscureText: true,
                          style: TextStyle(fontSize: 30,),
                          validator: (value){
                            if(value!.isEmpty || value.length<=5){
                              return 'invalid password';
                            }
                            return null;
                          },
                          onSaved: (value){

                          },
                        ),
                        Container(
                          alignment: Alignment.bottomRight,

                          margin: const EdgeInsets.only(top: 15.0),
                          child: RaisedButton(

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            onPressed: (){
                              _submit();
                            },

                            color: HexColor("#0E34A0"),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),

                        ),

                      ],

                    ),
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

//
// Container(
// height: 130,
// width: 60,
// decoration: new BoxDecoration(
// color:HexColor("#0E34A0"),
// shape: BoxShape.rectangle,
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(15),
// bottomLeft: Radius.circular(15),
// )),
// margin: const EdgeInsets.only(left: 355.0,top: 220),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: <Widget>[
//
// FlatButton(
// onPressed: (){},
// child: Icon(
// Icons.notifications_none_rounded,
// size: 40,
// color: Colors.white,
// ),),
// FlatButton(
// onPressed: (){},
// child: Icon(
// Icons.logout_rounded,
// size: 40,
// color: Colors.white,
// ),)
// ])
// ),