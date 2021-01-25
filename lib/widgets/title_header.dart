import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  String title;
  TitleHeader({Key key, @required this.title});

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontFamily: "Lato",
        fontWeight: FontWeight.bold
      ),
    );
  }
}
