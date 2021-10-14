
import 'package:beproject/accounts_teachers.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class HomeTeachers extends StatefulWidget {
  //static const routeName = '/logout';
  @override
  _HomeTeachersState createState() => _HomeTeachersState();
}

class _HomeTeachersState extends State<HomeTeachers> {
  int currentIndex = 0;
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
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, top: 30),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          'Anuja Vaidya',
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
                                  onPressed: () => Navigator.pop(context, 'OK'),
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
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, top: 30),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          'Srushti Shetye',
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
                                  onPressed: () => Navigator.pop(context, 'OK'),
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
                            margin: const EdgeInsets.only(left: 3.0),
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
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0, top: 30),
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          'Joel Parakal',
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
                                  onPressed: () => Navigator.pop(context, 'OK'),
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
                            margin: const EdgeInsets.only(left: 22.0),
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
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
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
                  ),
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
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => new HomeTeachers()));
                } else if (currentIndex == 2) {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => new AccountSettingsTeachers()));
                } else {}
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
                    Icons.import_contacts_sharp,
                  ),
                  label:
                    'LC',
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
