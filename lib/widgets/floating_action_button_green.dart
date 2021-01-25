import 'package:flutter/material.dart';


class FloatingActionButtonGreenC extends StatefulWidget {
  final IconData iconData;
  final VoidCallback onPressed;


  FloatingActionButtonGreenC({
    Key key,
    @required this.iconData,
    @required this.onPressed,
  });

  @override
  _FloatingActionButtonGreenState createState() => _FloatingActionButtonGreenState();
}

class _FloatingActionButtonGreenState extends State<FloatingActionButtonGreenC> {

  bool added = false;

  /*void onPressedFav() {
    setState(() {
      added = !added;
    });

    Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text(added ? "Agregado a favorito": "Ya no es favorito")
        )
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: widget.onPressed,
      backgroundColor: Color(0xFF11DA53),
      mini: true,
      tooltip: "FAB",
      heroTag: null,
      /*child: Icon(
          added ? Icons.favorite : Icons.favorite_border,
        ),
       */
      child: Icon(widget.iconData),

    );
  }

}