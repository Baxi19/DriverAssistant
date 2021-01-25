import 'package:flutter/material.dart';

class Dialog extends StatelessWidget {
  final VoidCallback onPressed1;
  final VoidCallback onPressed2;

  Dialog({
    Key key,
    @required this.onPressed1,
    @required this.onPressed2
  });

  @override
  Widget build(BuildContext context) {
    _showDialog() {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("Please select an option!"),
            content: new Text("Would you like to use the camera or the gallery?"),
            actions: <Widget>[
              TextButton.icon(
                onPressed: () {
                  onPressed1;
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                label: Text("CAMERA",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.indigo
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  onPressed2;
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.image, size: 18, color: Colors.white),
                label: Text("GALLERY",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.indigo
                ),
              ),
            ],
          ));
    }

    return _showDialog();
  }
}
