import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_assistant/AI/bloc/singleton.dart';
import 'package:driver_assistant/Place/model/place.dart';
import 'package:driver_assistant/Place/ui/widgets/home_card_image.dart';
import 'package:driver_assistant/User/model/user.dart';
import 'package:driver_assistant/User/ui/widgets/profile_card_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CloudFirestoreAPI{
  final String USERS = "users";
  final String PLACES = "places";

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateUserData(User user) async{
    DocumentReference ref = _db.collection(USERS).document(user.uid);
    return await ref.setData({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photoURL': user.photoURL,
      'myPlaces': user.myPlaces,
      'myFavoritePlaces': user.myFavoritePlaces,
      'lastSignIn': DateTime.now()
    }, merge: true);
  }

  Future<void> updatePlaceData(Place place) async {
    CollectionReference refPlaces = _db.collection(PLACES);
    DocumentReference refUser;

    await _auth.currentUser().then((FirebaseUser user){
      refPlaces.add({
        'name': place.name,
        'description': place.description,
        'likes': place.likes,
        'urlImage': place.urlImage,
        'lat': place.lat,
        'lon': place.lon,
        //'userOwner': "${USERS}/${user.uid}", //reference
        'userOwner': _db.document("${USERS}/${user.uid}"), //reference
      }).then((DocumentReference documentReference) => {
        documentReference.get().then((DocumentSnapshot snapshot) => {
          refUser = _db.collection(USERS).document(user.uid),
          refUser.updateData({
            'myPlaces': FieldValue.arrayUnion([_db.document("${PLACES}/${snapshot.documentID}")])
          })
        })
      });
    });
  }

  //get my places
  List<ProfileCardImage> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot){
    List<ProfileCardImage> profilePlaces = List<ProfileCardImage>();
    Singleton().myPlacesList = List();

    placesListSnapshot.forEach((_place){
      var place = Place(
        name: _place.data['name'],
        description: _place.data['description'],
        urlImage: _place.data['urlImage'],
        likes: _place.data['likes'],
        liked: _place.data["liked"],
        lat: _place.data['lat'],
        lon: _place.data['lon'],
      );

      profilePlaces.insert(0, ProfileCardImage(place: place,));
      Singleton().myPlacesList.add(place);
    });
    print("===> Size of my Places: ${Singleton().myPlacesList.length}");
    return profilePlaces;
  }

  //get all places used in home
  List<HomeCardImage> buildPlaces(List<DocumentSnapshot> placesListSnapshot, BuildContext context, User user, VoidCallback onTapImage){
    List<HomeCardImage> placesCard = List<HomeCardImage>();
    Singleton().allPlacesList = List();
    IconData iconData = Icons.favorite_border;

    placesListSnapshot.forEach((_place){
      var place = Place(
        name: _place.data['name'],
        description: _place.data['description'],
        urlImage: _place.data['urlImage'],
        likes: _place.data['likes'],
        liked: _place.data["liked"],
        lat: _place.data['lat'],
        lon: _place.data['lon'],
      );

      placesCard.insert(0, HomeCardImage(
          place: place,
          onPressFabIcon: (){
            //Like
            likePlace(_place.documentID);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                 'You likes ${_place.data['name']}!'
                ),
                duration: Duration(milliseconds: 1500),
              ),
            );
          },
          onTapImage: onTapImage,
          iconData: iconData
      ));
      Singleton().allPlacesList.add(place);
    });
    print("===> Size of all Places: ${Singleton().allPlacesList.length}");
    return placesCard;
  }

  //get all list of places used in home
  List<Place> buildPlacesAsList(List<DocumentSnapshot> placesListSnapshot, BuildContext context, User user){
    List<Place> placesCard = List<Place>();
    placesListSnapshot.forEach((_place){
      placesCard.insert(0,
        Place(
          name: _place.data['name'],
          description: _place.data['description'],
          urlImage: _place.data['urlImage'],
          likes: _place.data['likes'],
          lat: _place.data['lat'],
          lon: _place.data['lon'],
        ),
      );
    });
    return placesCard;
  }

  //Method to sum 1 like to 1 specific place
  Future likePlace(String idPlace) async {
    await _db.collection(PLACES).document(idPlace).get()
        .then((DocumentSnapshot snapshot){
        int likes = snapshot.data["likes"];
        _db.collection(PLACES).document(idPlace).updateData({
          'likes': likes+1
        });
    });
  }

/*
  //Help to don't lose anything like
  Future likePlaceTransaction(String idPlace) async {
    _db.runTransaction((transaction) async {
      DocumentSnapshot placeDS = await _db.collection(this.PLACES).document(idPlace).get();
      await transaction.update(placeDS.reference, {"likes": placeDS.data['likes'] + 1});
    });
  }
*/
}