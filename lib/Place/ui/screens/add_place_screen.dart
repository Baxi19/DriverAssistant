import 'dart:io';

import 'package:driver_assistant/AI/ui/screens/filter_view.dart';
import 'package:driver_assistant/Place/model/place.dart';
import 'package:driver_assistant/Place/ui/screens/google_maps.dart';
import 'package:driver_assistant/Place/ui/widgets/card_image.dart';
import 'package:driver_assistant/Place/ui/widgets/title_input_location.dart';
import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:driver_assistant/widgets/button_purple.dart';
import 'package:driver_assistant/widgets/gradient_back.dart';
import 'package:driver_assistant/widgets/text_input.dart';
import 'package:driver_assistant/widgets/title_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';



class AddPlaceScreen extends StatefulWidget {
  File image;

  AddPlaceScreen({Key key, this.image});

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  //File _image;
  final picker = ImagePicker();
  final _controllerTitlePlace = TextEditingController();
  final _controllerDescriptionPlace = TextEditingController();
  LatLng location = LatLng(10.47134, -84.64351);

  refressLocalization(LatLng value){
    setState(() {
      location = value;
    });
  }
  refressImage(File value){
    setState(() {
      widget.image = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    String position = "${location.latitude.toString()} , ${location.longitude.toString()}";

    showAlertDialog(BuildContext context, String title, String description) {
      // Create button
      Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );

      // Create AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          okButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    buildShowDialog(BuildContext context) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          });
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBack(height: 300.0),
          Row( //App Bar
            children: <Widget> [
              Container(
                padding: EdgeInsets.only(
                  top: 25.0,
                  left: 5.0,
                ),
                child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 45,
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Flexible(
                child: TitleApp(title: "Add a new Place"),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 120.0, bottom: 20.0),
            child: ListView(
              children: <Widget>[
                Container(//Photo
                  alignment: Alignment.center,
                  child: CardImageWithFabIcon(
                      pathImage: widget.image.path, //'assets/img/img.png',
                      iconData: Icons.photo_filter_outlined,
                      width: MediaQuery.of(context).size.width-40.0,//tamaño de la pantalla automatico - 40.0
                      height: 250.0,
                      left: 0.0,
                      onPressFabIcon: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (BuildContext context) => FilterView(
                              widget.image
                            )
                          ),
                        ).then((result) async {
                          if(result != null){
                            //TODO: check if update the image
                            setState((){
                              widget.image = result;
                            });
                          }
                        });
                      },
                  ),
                ),
                Container( //Title
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: TextInput(
                    hintText: "Title",
                    inputType: null,
                    maxLines: 1,
                    controller: _controllerTitlePlace,
                  ),
                ),
                TextInput( // Description
                    hintText: "Description",
                    inputType: TextInputType.multiline,
                    maxLines: 4,
                    controller: _controllerDescriptionPlace,
                ),
                Container( // Location
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextInputLocation(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => GoogleMaps()),
                      ).then((value) => {
                        if(value != null){
                          refressLocalization(value),
                        }
                      });
                    },
                    hintText: "${location.latitude.toStringAsFixed(5)} , ${location.longitude.toStringAsFixed(5)}",
                    iconData: Icons.location_on_outlined,

                  ),
                ),
                Container(
                  width: 70.0,
                  child: ButtonPurple(
                    buttonText: "Add Place",
                    onPressed: (){
                      if(_controllerTitlePlace.text.isNotEmpty){
                        if(_controllerDescriptionPlace.text.isNotEmpty){
                          buildShowDialog(context);
                          //id user
                          String id;
                          String path;
                          Place newPlace;
                          userBloc.currentUser.then((FirebaseUser user) => {
                            if(user != null){
                              id = user.uid,
                              //1. Firebase Storage
                              //url -
                              path = "${id}/${DateTime.now().toString()}.jpg",
                              userBloc.uploadFile(path, widget.image)
                                .then((StorageUploadTask storageUploadTask) =>{
                                storageUploadTask.onComplete.then((StorageTaskSnapshot snapshot) => {
                                snapshot.ref.getDownloadURL().then((urlImage) => {
                                    print("URL IMAGE: ${urlImage}"),

                                    //2. Cloud Firestore
                                    //Place - title, description, url, userOwner, likes, lat, lon
                                    newPlace = Place(
                                        name: _controllerTitlePlace.text,
                                        description: _controllerDescriptionPlace.text,
                                        urlImage: urlImage,
                                        likes: 0,
                                        liked: false,
                                        lat: location.latitude,
                                        lon: location.longitude),
                                    //TODO:
                                    //Singleton().allPlacesList.add(newPlace),
                                    //Singleton().myPlacesList.add(newPlace),
                                    userBloc.updatePlaceData(newPlace).whenComplete(() => {
                                      Navigator.pop(context),
                                      print("==>Place added!"),
                                      Navigator.pop(context),
                                    }),

                                  }),
                                }),
                              }),
                            }
                          });
                        }else{
                          showAlertDialog(context, "Empty Description","Please enter a description of the place");
                        }
                      }else{
                        showAlertDialog(context, "Empty Title","Please enter a Title");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
