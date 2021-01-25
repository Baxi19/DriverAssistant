import 'dart:io';

import 'package:driver_assistant/widgets/gradient_back.dart';
import 'package:driver_assistant/widgets/title_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';


class Semantic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SemanticSegmentation(),
    );
  }
}


class SemanticSegmentation extends StatefulWidget {
  @override
  _SemanticSegmentationState createState() => _SemanticSegmentationState();
}
// setting up a string constant for the name of the model
const String dlv3 = 'DeepLabv3';

class _SemanticSegmentationState extends State<SemanticSegmentation> {
  BuildContext _context;
  String _model = dlv3;
  final picker = ImagePicker();
  File _image;

  double _imageWidth;
  double _imageHeight;
  bool _busy = false;

  var _recognitions;

  // when the widget initiates try to load the model for further actions
  @override
  void initState() {
    super.initState();
    _busy = true;
    loadModelSemantic().then((val) {
      setState(() {
        _busy = false;
      });
    });
  }
  // method responsible for loading the model from the assets folder
  loadModelSemantic() async {
    Tflite.close();
    try {
      String res;
      if(_model == dlv3) {
        res = await Tflite.loadModel(
          model: 'assets/models/deeplabv3.tflite',
          labels: 'assets/models/deeplabv3_labels.txt',
        );
      }
    } on PlatformException {
      print("cant load model");
    }
  }


  // method responsible for loading an image from image gallery of the device
  selectFromImagePicker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, ); // ignore: deprecated_member_use
    if(image == null) return;
    setState(() {
      _busy = true;
    });
    predictImage(image);
  }
  // method responsible for loading image from live camera of the device
  selectFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _busy = true;
        predictImage(File(pickedFile.path));
      } else {
        print('===>No image selected.');
      }
    });
  }

  // method responsible for predicting segmentation for the selected image
  predictImage(File image) async {
    if(image == null) return;
    if(_model == dlv3) {
      await dlv(image);
    }
    // get the width and height of selected image
    FileImage(image).resolve(ImageConfiguration()).addListener((ImageStreamListener((ImageInfo info, bool _){
      setState(() {
        _imageWidth = info.image.width.toDouble();
        _imageHeight = info.image.height.toDouble();
      });
    })));

    setState(() {
      _image = image;
      _busy = false;
    });
  }
  // method responsible for giving actual prediction from the model
  dlv(File image) async {
    var recognitions = await Tflite.runSegmentationOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      outputType: "png",
      asynch: true,
    );
    setState(() {
      _recognitions = recognitions;
    });
  }

  // build method is run each time app needs to re-build the widget
  @override
  Widget build(BuildContext context) {
    _context = context;
    // get the width and height of current screen the app is running on
    Size size = MediaQuery.of(context).size;

    // initialize two variables that will represent final width and height of the segmentation
    // and image preview on screen
    double finalW;
    double finalH;

    // when the app is first launch usually image width and height will be null
    // therefore for default value screen width and height is given
    if(_imageWidth == null && _imageHeight == null) {
      finalW = size.width;
      finalH = size.height;
    }else {

      // ratio width and ratio height will given ratio to
      // scale up or down the preview image and segmentation
      double ratioW = size.width / _imageWidth;
      double ratioH = size.height / _imageHeight;

      // final width and height after the ratio scaling is applied
      finalW = _imageWidth * ratioW;
      finalH = _imageHeight * ratioH;
    }

    List<Widget> stackChildren = [];

    // when busy load a circular progress indicator
    if(_busy) {
      stackChildren.add(Positioned(
        //top: 0,
        //left: 0,
        //TODO
        child: Center(child: CircularProgressIndicator(),),
        //child: buildShowDialog(context),
      ));
    }

    // widget to show image preview, when preview not available default text is shown
    stackChildren.add(Positioned(
      top: 0.0,
      left: 0.0,
      width: finalW,
      height: finalH,
      child: _image == null ?
      //Center(child: Text('Please Select an Image From Camera or Gallery'),)
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Please Select an Image"),
              ],
            ),
          )
          : Image.file(_image, fit: BoxFit.fill,),
    ));

    // widget to show segmentation preview, when segmentation not available default blank text is shown
    stackChildren.add(Positioned(
      top: 0,
      left: 0,
      width: finalW,
      height: finalH,
      child: Opacity(
        opacity: 0.7,
        child: _recognitions == null ? Center(child: Text(''),)
            : Image.memory(_recognitions, fit: BoxFit.fill),
      ),
    ));

    return Scaffold(
      body:Stack(
        children: [
          GradientBack(height: null),
          Row( //App Bar
            children: <Widget> [
              Flexible(
                child: TitleApp(title: "Image Segmentation"),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 100.0),
            child: Center(
              child: Stack(
                children: stackChildren,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Camera Picker",
            child: Icon(Icons.camera_alt),
            onPressed: selectFromCamera,
            backgroundColor: Color(0xFF11DA53),
            tooltip: 'Pick Image from Camera',
          ),
          SizedBox(width: 10,),
          FloatingActionButton(
            heroTag: "Gallery Picker",
            child: Icon(Icons.photo),
            tooltip: 'Pick Image from Gallery',
            backgroundColor: Color(0xFF11DA53),
            onPressed: selectFromImagePicker,
          ),
        ],
      ),
    );
  }
}

