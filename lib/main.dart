import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Driver Assistant Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF3F51b5),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget> [
          SizedBox(
            height: 70
          ),
          _topheader(),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top:32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.grey[50],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _topheader() {
    return Padding(padding: EdgeInsets.only(left: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Create\nYour\nAccount',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 28,
            ),
          ),
          //Image.asset('assets/images/map.png',
          //  height: 170,
          //  fit: BoxFit.fitHeight,
          //),
        ],
      ),

    );
  }
}
