import 'package:driver_assistant/Place/model/place.dart';
import 'package:driver_assistant/User/model/user.dart';


class Singleton{
  static final Singleton _singleton = Singleton._internal();

  factory Singleton() => _singleton;

  Singleton._internal(); // private constructor

  User user;
  Place place;

  List<Place> myPlacesList = List();
  List<Place> allPlacesList = List();
  List<User> userList = List();

  String name = "Ruta 1";
  String description = "La Carretera Interamericana Norte, enumerada como Ruta Nacional Primaria 1 o simplemente Ruta 1, es uno de los dos tramos de la Carretera Panamericana que atraviesan Costa Rica, siendo el otro la Carretera Interamericana Sur (Ruta 2). \n\nEs una carretera primaria de la red vial costarricense. Se divide en tres segmentos: Autopista General Cañas (San José-Alajuela), Autopista Bernardo Soto (Alajuela-San Ramón), Carretera Interamericana Norte (San Ramón-Peñas Blancas).";
  double calification = 4.5;

  void updatePlaceData(String name, String description, double calification){
    this.name = name;
    this.description = description;
    this.calification = calification;
  }

}