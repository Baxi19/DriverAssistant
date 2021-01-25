import 'dart:io';
import 'package:driver_assistant/widgets/gradient_back.dart';
import 'package:driver_assistant/widgets/title_app.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

// Class will be used by static images
class ObjectDetection extends StatefulWidget {
  @override
  _ObjectDetectionState createState() => _ObjectDetectionState();
}

class _ObjectDetectionState extends State<ObjectDetection> {
  File _image;
  List _recognitions;
  bool _busy;
  double _imageWidth, _imageHeight;

  final picker = ImagePicker();

  // This function loads the model
  loadTfModel() async {
    await Tflite.loadModel(
      model: "assets/models/ssd_mobilenet.tflite",
      labels: "assets/models/labels.txt",
    );
  }

  // This function detects the objects on the image
  detectObject(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
        path: image.path,       // required
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4,       // defaults to 0.1
        numResultsPerClass: 10,// defaults to 5
        asynch: true          // defaults to true
    );

    FileImage(image)
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageWidth = info.image.width.toDouble();
        _imageHeight = info.image.height.toDouble();
      });
    })));

    setState(() {
      _recognitions = recognitions;
    });
  }

  @override
  void initState() {
    super.initState();
    _busy = true;
    loadTfModel().then((val) {{
      setState(() {
        _busy = false;
      });
    }});
  }

  // display the bounding boxes over the detected objects
  List<Widget> renderBoxes(Size screen) {
    if (_recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    //TODO: check size factor y
    double factorX = screen.width;
    //double factorY = _imageHeight / _imageHeight * screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;


    //Color blue = Colors.blue;
    Color green = Color(0xFF11DA53);

    return _recognitions.map((re) {
      return Container(
        child: Positioned(
            left: re["rect"]["x"] * factorX,
            top: re["rect"]["y"] * factorY,
            width: re["rect"]["w"] * factorX,
            height: re["rect"]["h"] * factorY,
            //TODO: change almost 70% ?
            child: ((re["confidenceInClass"] > 0.50))? Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    //color: blue,
                    color: green,
                    width: 3,
                  )
              ),
              child: Text(
                "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  //background: Paint()..color = blue,
                  background: Paint()..color = green,
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ) : Container()
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> stackChildren = [];

    stackChildren.add(
        Positioned(
          // using ternary operator
          child: _image == null ?
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Please Select an Image"),
              ],
            ),
          )
              : // if not null then
          Container(
              child:Image.file(_image)
          ),
        )
    );

    stackChildren.addAll(renderBoxes(size));

    if(_busy){
      stackChildren.add(
          Center(
            child: CircularProgressIndicator(),
          )
      );
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child:Stack(
          //children: stackChildren,
          children: [
            GradientBack(height: null),
            Row( //App Bar
              children: <Widget> [
                Flexible(
                  child: TitleApp(title: "Object Detection"),
                ),
              ],
            ),
            Container(
              child: Center(
                child: Stack(
                  children: stackChildren,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Camera Picker",
            child: Icon(Icons.camera_alt),
            onPressed: getImageFromCamera,
            backgroundColor: Color(0xFF11DA53),
            tooltip: 'Pick Image from Camera',
          ),
          SizedBox(width: 10,),
          FloatingActionButton(
            heroTag: "Image Picker",
            child: Icon(Icons.photo),
            onPressed: getImageFromGallery,
            backgroundColor: Color(0xFF11DA53),
            tooltip: 'Pick Image from Gallery',
          ),
        ],
      ),
    );
  }
  // gets image from camera and runs detectObject
  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if(pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image Selected");
      }
    });
    detectObject(_image);
  }

  // gets image from gallery and runs detectObject
  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image Selected");
      }
    });
    detectObject(_image);
  }
}