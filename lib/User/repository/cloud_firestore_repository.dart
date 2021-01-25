import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_assistant/Place/model/place.dart';
import 'package:driver_assistant/Place/ui/widgets/home_card_image.dart';
import 'package:driver_assistant/User/model/user.dart';
import 'package:driver_assistant/User/repository/cloud_firestore_api.dart';
import 'package:driver_assistant/User/ui/widgets/profile_card_image.dart';
import 'package:flutter/material.dart';

class CloudFirestoreRepository{
  final _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateUserDataFirestore(User user) => _cloudFirestoreAPI.updateUserData(user);
  Future<void> updatePlaceData(Place place) => _cloudFirestoreAPI.updatePlaceData(place);
  List<ProfileCardImage> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) => _cloudFirestoreAPI.buildMyPlaces(placesListSnapshot);
  List<HomeCardImage> buildPlaces(List<DocumentSnapshot> placesListSnapshot, BuildContext context, User user, VoidCallback onTapImage) => _cloudFirestoreAPI.buildPlaces(placesListSnapshot, context, user, onTapImage);
  List<Place> buildPlacesAsList(List<DocumentSnapshot> placesListSnapshot, BuildContext context, User user) => _cloudFirestoreAPI.buildPlacesAsList(placesListSnapshot, context, user);
}