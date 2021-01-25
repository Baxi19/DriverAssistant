import 'package:driver_assistant/AI/bloc/singleton.dart';
import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:driver_assistant/widgets/button_bar.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'home_header.dart';
import '../widgets/description_place.dart';
import '../widgets/review_list.dart';


class Home extends StatefulWidget {
  String name = "Ruta 1";
  String description = "La Carretera Interamericana Norte, enumerada como Ruta Nacional Primaria 1 o simplemente Ruta 1, es uno de los dos tramos de la Carretera Panamericana que atraviesan Costa Rica, siendo el otro la Carretera Interamericana Sur (Ruta 2). \n\nEs una carretera primaria de la red vial costarricense. Se divide en tres segmentos: Autopista General Cañas (San José-Alajuela), Autopista Bernardo Soto (Alajuela-San Ramón), Carretera Interamericana Norte (San Ramón-Peñas Blancas).";
  double calification = 4.5;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserBloc userBloc;


  //TODO: Sent correct directions
  getPlaceDirections(){
    Navigator.of(context).
    push(MaterialPageRoute(
      builder: (context) =>
          ButtonsBar(1),
    ));

    setState(() {

    });
  }

  //TODO: Create a Inherit widget
  updatePlaceInfo(){
      widget.name = Singleton().name;
      widget.description = Singleton().description;
      widget.calification = Singleton().calification;
      print("Hello from Home, ==> ${Singleton().name}");
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            BlocProvider(
                child: DescriptionPlace(
                  onPresset: getPlaceDirections,
                  titleStars: widget.name,
                  stars: widget.calification,
                  descriptionRoute: widget.description,
                ),
                bloc: UserBloc()),
            ReviewList(),
          ],
        ),

        BlocProvider(
            child: HomeHeader(
              onTapImage: updatePlaceInfo,
            ),
            bloc: UserBloc()),
      ],
    );
  }
}



/*
class Home extends StatelessWidget {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            DescriptionPlace(userBloc.placeName, 4.5, userBloc.placeDescription),
            ReviewList(),
          ],
        ),
        BlocProvider(child: HomeHeader(), bloc: UserBloc()),
      ],
    );
  }
}
 */