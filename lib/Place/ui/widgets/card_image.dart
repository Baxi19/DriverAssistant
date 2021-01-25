import 'package:flutter/material.dart';
import '../../../widgets/floating_action_button_green.dart';
import 'dart:io';

class CardImageWithFabIcon extends StatefulWidget {
  //final double height = 350.0;
  final double height;
  //final double width = 250.0;
  final double width;
  double left;
  final String pathImage;
  //final File pathImage;
  final VoidCallback onPressFabIcon;
  final IconData iconData;

  CardImageWithFabIcon({
    Key key,
    @required this.pathImage,
    @required this.width,
    @required this.height,
    @required this.onPressFabIcon,
    @required this.iconData,
    this.left
  });
  @override
  _CardImageWithFabIconState createState() => _CardImageWithFabIconState();
}

class _CardImageWithFabIconState extends State<CardImageWithFabIcon> {
  @override
  Widget build(BuildContext context) {
    // card image
    final card = new Container(
      height: widget.height,
      width: widget.width,
      margin: EdgeInsets.only(
        left: widget.left,
      ),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: widget.pathImage.contains('assets')? AssetImage(widget.pathImage):new FileImage(new File(widget.pathImage))
              //image: widget.internet ? CachedNetworkImageProvider(widget.pathImage): AssetImage(widget.pathImage)
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black38,
                blurRadius: 15.0,
                offset: Offset(0.0, 7.0)
            )
          ]
      ),
    );

    return Stack(
      alignment: Alignment(0.9, 1.1),
      children: [
        card,
        FloatingActionButtonGreenC(iconData: widget.iconData, onPressed: widget.onPressFabIcon,),
      ],
    );
  }
}

/*
class CardImageWithFabIcon extends StatelessWidget {
  //final double height = 350.0;
  final double height;
  //final double width = 250.0;
  final double width;
  double left;
  final String pathImage;
  //final File pathImage;
  final VoidCallback onPressFabIcon;
  final IconData iconData;

  CardImageWithFabIcon({
    Key key,
    @required this.pathImage,
    @required this.width,
    @required this.height,
    @required this.onPressFabIcon,
    @required this.iconData,
    this.left
  });

  @override
  Widget build(BuildContext context) {
    // card image
    final card = new Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(
        left: left,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image: pathImage.contains('assets')? AssetImage(pathImage):new FileImage(new File(pathImage))
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        shape: BoxShape.rectangle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black38,
            blurRadius: 15.0,
            offset: Offset(0.0, 7.0)
          )
        ]
      ),
    );

    return Stack(
      alignment: Alignment(0.9, 1.1),
      children: [
        card,
        FloatingActionButtonGreenC(iconData: iconData, onPressed: onPressFabIcon,),
      ],
    );
  }
}
*/