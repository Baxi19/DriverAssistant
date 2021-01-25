import 'package:driver_assistant/widgets/title_header.dart';
import 'package:flutter/material.dart';

class TitleApp extends StatelessWidget {
  String title;

  TitleApp({Key key, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
        top: 45.0,
        left: 20.0,
        right: 10.0
    ),
    child: TitleHeader(title: title),);
  }
}
