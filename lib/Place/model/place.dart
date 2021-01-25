import 'package:driver_assistant/User/model/user.dart';
import 'package:flutter/material.dart';


class Place {
  String uid;
  String name;
  String description;
  String urlImage;
  int likes;
  User userOwner;
  double lat;
  double lon;
  bool liked;

  Place({
    Key key,
    @required this.name,
    @required this.description,
    @required this.urlImage,
    this.likes,
    this.liked,
    //@required userOwner,
    //this.userOwner,
    @required this.lat,
    @required this.lon
  });

}