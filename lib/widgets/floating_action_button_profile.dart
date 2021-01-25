import 'dart:io';
import 'package:driver_assistant/AI/ui/screens/semantic_segmentation.dart';
import 'package:driver_assistant/AI/ui/screens/object_detection.dart';
import 'package:driver_assistant/Place/ui/screens/add_place_screen.dart';
import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:image_picker/image_picker.dart';

class FloatingActionButtonProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FloatingActionButtonProfile();
  }
}

class _FloatingActionButtonProfile extends State<FloatingActionButtonProfile> {
  UserBloc userBloc;
  File _image;
  final picker = ImagePicker();


  //Get normal picture from camera
  Future<File> getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('===>No image selected.');
      }
    });


    if(_image != null){
      print("\n\n===>Image path: " + _image.path.toString());

      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => AddPlaceScreen(
            image: _image,
          )),
      );
    }else{
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => AddPlaceScreen(
            image: File('assets/img/img.png'),
          )),
      );
    }

  }

  //Get normal picture from Gallery
  Future<File> getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('===>No image selected.');
      }
    });
    if(_image != null){
      print("\n\n===>Image path: " + _image.path.toString());
      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => AddPlaceScreen(
            image: _image,
          )),
      );
    }
  }

  // Change password
  changePassword(){

  }


  // Object detection
  takePictureObjectDetection(){
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) => ObjectDetection()),
    );
  }

  //Semantic Segmentation
  takePictureSemanticSegmentation(){
    Navigator.push(context, MaterialPageRoute(
        builder: (BuildContext context) => Semantic()),
    );
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

    // Close all sessions
    logOut(){
      setState(() {
        userBloc.signOut();
        //Navigator.pop(context);
      });
    }

    /*
    // Take simple picture
    takeNormalPicture() async {
      await ImagePicker.pickImage(source: ImageSource.camera)
          .then((File image) => {
        if(image != null){
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => AddPlaceScreen(
              image: image,
            ),),
          ),
        }
      }).catchError((onError) => print("===>Error: " + onError.toString()));
    }
*/
    // En este caso crearemos un boton
    // Witget Marcador
    final button_key = Container(
      margin: EdgeInsets.only(
        top: 200.0,//Posision en la pantalla
      ),

      child: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF584CD1),
        mini: true,//Tipo de tamaño mini
        tooltip: "Password", //Si se pasa un el elemento con un mouse
        onPressed: changePassword,
        child: Icon(
            Icons.vpn_key
        ),
        heroTag: null,
      ),
    );

    final button_object_detection = Container(
      margin: EdgeInsets.only(
        top: 200.0,//Posision en la pantalla
      ),

      child: FloatingActionButton(
        //backgroundColor: Color(0xFFA7B2E3),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF584CD1),
        mini: true,//Tipo de tamaño mini
        tooltip: "Detection", //Si se pasa un el elemento con un mouse
        onPressed: takePictureObjectDetection,
        child: Icon(
            Icons.camera_outlined
        ),
        heroTag: null,
      ),
    );

    final button_add = Container(
      margin: EdgeInsets.only(
        top: 200.0,//Posision en la pantalla
      ),

      child: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF584CD1),
        //mini: true,//Tipo de tamaño mini
        tooltip: "Picture", //Si se pasa un el elemento con un mouse
        //onPressed: getImage,
        onPressed: _showDialogNormalPicture,

        child: Icon(
            Icons.add
        ),
        heroTag: null,
      ),
    );

    final button_semantic_segmentation = Container(
      margin: EdgeInsets.only(
        top: 200.0,//Posision en la pantalla
      ),

      child: FloatingActionButton(
        //backgroundColor: Color(0xFFA7B2E3),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF584CD1),
        mini: true,//Tipo de tamaño mini
        tooltip: "Semantic", //Si se pasa un el elemento con un mouse
        onPressed: takePictureSemanticSegmentation,
        /*onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => Semantic()),
          );
        },*/
        child: Icon(
            Icons.image_outlined
        ),
        heroTag: null,
      ),
    );

    final button_signOut = Container(
      margin: EdgeInsets.only(
        top: 200.0,//Posision en la pantalla
      ),

      child: FloatingActionButton(
        //backgroundColor: Color(0xFFA7B2E3),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF584CD1),
        mini: true,//Tipo de tamaño mini
        tooltip: "Log out", //Si se pasa un el elemento con un mouse
        onPressed: logOut,
        child: Icon(
            Icons.exit_to_app,
        ),
        heroTag: null,
      ),
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,//Coloque el espacio libre de manera uniforme entre los hijos, así como la mitad de ese espacio antes y después del primer y último hijo
          children: [
            button_key,
            button_object_detection,
            button_add,
            button_semantic_segmentation,
            button_signOut
          ],
        )
      ],
    );
  }

  //Normal picture
  _showDialogNormalPicture() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Please select an option!"),
          content: new Text("Would you like to use the camera or the gallery?"),
          actions: <Widget>[
            TextButton.icon(
              onPressed: () {
                getImageCamera();
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
                getImageGallery();
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
}

