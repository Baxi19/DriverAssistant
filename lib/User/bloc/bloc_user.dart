import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_assistant/Place/model/place.dart';
import 'package:driver_assistant/Place/repository/firebase_storage_repository.dart';
import 'package:driver_assistant/Place/ui/widgets/card_image.dart';
import 'package:driver_assistant/Place/ui/widgets/home_card_image.dart';
import 'package:driver_assistant/User/repository/cloud_firestore_api.dart';
import 'package:driver_assistant/User/repository/cloud_firestore_repository.dart';
import 'package:driver_assistant/User/ui/widgets/profile_card_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../model/user.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../repository/auth_repository.dart';

class UserBloc implements Bloc {
  User user;
  String placeName = 'Ruta 1';
  String placeDescription = 'La Carretera Interamericana Norte, enumerada como Ruta Nacional Primaria 1 o simplemente Ruta 1, es uno de los dos tramos de la Carretera Panamericana que atraviesan Costa Rica, siendo el otro la Carretera Interamericana Sur (Ruta 2). \n\nEs una carretera primaria de la red vial costarricense. Se divide en tres segmentos: Autopista General Cañas (San José-Alajuela), Autopista Bernardo Soto (Alajuela-San Ramón), Carretera Interamericana Norte (San Ramón-Peñas Blancas).';
  Place place;

  //Flujo de datos - Streams
  //Stream - Firebase
  //StreamController
  Stream<FirebaseUser> streamFirebase = FirebaseAuth.instance.onAuthStateChanged;
  Stream<FirebaseUser> get authStatus => streamFirebase;
  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();

  final _auth_repository = AuthRepository();

  // Casos de uso
  // 1. SignIn a la aplicación Google
  Future<FirebaseUser> signIn() => _auth_repository.signInFirebase();


  // 2. Sign Out
  signOut() {
    _auth_repository.signOut();
  }

  // 3. Registrar usuario en base de datos
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(User user) => _cloudFirestoreRepository.updateUserDataFirestore(user);

  //guardar un lugar en la bd
  Future<void> updatePlaceData(Place place) => _cloudFirestoreRepository.updatePlaceData(place);

  //Home data
  Stream<QuerySnapshot> placesListStream = Firestore.instance.collection(CloudFirestoreAPI().PLACES).snapshots();
  Stream<QuerySnapshot> get placesStream => placesListStream;
  List<HomeCardImage> buildPlaces(List<DocumentSnapshot> placesListSnapshot, BuildContext context, User user, VoidCallback onTapImage) => _cloudFirestoreRepository.buildPlaces(placesListSnapshot, context, user, onTapImage);
  List<Place> buildPlacesAsList(List<DocumentSnapshot> placesListSnapshot, BuildContext context, User user) => _cloudFirestoreRepository.buildPlacesAsList(placesListSnapshot, context, user);

  //Description
  StreamController<Place> placeSelectedStreamController = StreamController<Place>();
  Stream<Place> get placeSelectedStream => placeSelectedStreamController.stream;
  StreamSink<Place> get placeSelectedSink =>  placeSelectedStreamController.sink;

  //Datos filtrados por uid
  Stream<QuerySnapshot> myPlacesListStream(String uid) => Firestore.instance.collection(CloudFirestoreAPI().PLACES).where("userOwner", isEqualTo: Firestore.instance.document("${CloudFirestoreAPI().USERS}/${uid}")).snapshots();
  List<ProfileCardImage> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) => _cloudFirestoreRepository.buildMyPlaces(placesListSnapshot);


  // 4.
  final _firebaseStorageRepository = FirebaseStorageRepository();
  Future<StorageUploadTask> uploadFile(String path, File image) => _firebaseStorageRepository.uploadFile(path, image);


  @override
  void dispose() {

  }
}