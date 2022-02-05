import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main() {
  runApp(GeeksForGeeks());
}

class GeeksForGeeks extends StatelessWidget {

// This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,

        ),
        body:Stack(
          children:<Widget>[
        Column(
          children: [
            Text('Don Bosco Institute of Technology'),
            Text('[Engineering College]'),
            Text('Approved by AICTE & Affiliated to University of Mumbai'),
            Text('Dues Clearance Certificate'),
            SizedBox(height: 10,),
            Text('Details of Candidate'),
            SizedBox(height: 10,),
            Row(
              children: [
                Column(
                  children: [

                    SizedBox(
                      width: 10,),
                    SizedBox(
                      width: 10,),
                    SizedBox(
                      width: 10,),

                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text('Name of Student',

                      ),
                    ),
                    SizedBox(
                      width: 130,
                      child: Text('Branch',

                      ),
                    ),
                    SizedBox(
                      width: 130,
                      child: Text('Academic Year of Admission',

                      ),
                    )
                    // Text('Academic Year of Admission'),
                  ],
                ),

                Column(
                  children: [
                    Text(':'),
                    Text(':'),
                    Text(':'),
                  ],
                ),
                Column(
                  children: [

                    SizedBox(
                      width: 20,),
                    SizedBox(
                      width: 20,),
                    SizedBox(
                      width: 20,),

                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text('Name of Student',

                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: Text('Branch',

                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: Text('Academic Year of Admission',

                      ),
                    )
                    // Text('Academic Year of Admission'),
                  ],
                ),
              ],
            ),

            SizedBox(height: 10,),
            Text('Other details of the Student'),
            Row(
              children: [
                Column(
                  children: [

                    SizedBox(
                      width: 10,),
                    SizedBox(
                      width: 10,),
                    SizedBox(
                      width: 10,),

                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text('You have opted for',

                      ),
                    ),
                    SizedBox(
                      width: 130,
                      child: Text('Details of above',

                      ),
                    ),
                    // Text('Academic Year of Admission'),
                  ],
                ),

                Column(
                  children: [
                    Text(':'),
                    Text(':'),
                  ],
                ),
                Column(
                  children: [

                    SizedBox(
                      width: 20,),
                    SizedBox(
                      width: 20,),
                    SizedBox(
                      width: 20,),

                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 180,
                      child: Text('Name of Student',

                      ),
                    ),
                    SizedBox(
                      width: 180,
                      child: Text('Branch',

                      ),
                    ),
                                        // Text('Academic Year of Admission'),
                  ],
                ),
              ],
            ),

          ],
        )

        ])));
  }
}
