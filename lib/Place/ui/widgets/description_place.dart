import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:driver_assistant/widgets/button_bar.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import '../../../widgets/button_purple.dart';


class DescriptionPlace extends StatelessWidget {
  UserBloc userBloc;
  final String titleStars;
  final double stars;
  final String descriptionRoute ;
  final VoidCallback onPresset;

  //Constructor
  DescriptionPlace({Key key, @required this.onPresset,this.titleStars, this.stars, this.descriptionRoute,});

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

  /*  return Container(
        child: StreamBuilder(
          stream: userBloc.placesStream,
          builder: (context, AsyncSnapshot snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return  Center(
                  child: CircularProgressIndicator()
              );
            default:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  title_stats(titleStars),
                  description(descriptionRoute),
                  ButtonPurple(
                    buttonText: 'Navigate',
                    onPressed: (){
                      Navigator.of(context).
                      push(MaterialPageRoute(
                        builder: (context) =>
                            ButtonsBar(1),
                      ));
                    },
                  ),
                ],
              );
          }
        }),
    );

*/

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title_stats(titleStars),
        description(descriptionRoute),
        ButtonPurple(
          buttonText: 'Navigate',
          onPressed: onPresset,
        ),
      ],
    );

  }
}


// Titulo con estrellas
Widget title_stats(String titleStars){
  return Row(
    children: <Widget>[
      // Titulo
      Container(
          margin: EdgeInsets.only(
              top: 320.0,
              left: 20.0,
              right: 20.0
          ),
          child: Text(
            titleStars,
            style: TextStyle(
                fontFamily: "Lato",
                fontSize: 30.0,
                fontWeight: FontWeight.w900
            ),
            textAlign: TextAlign.left,
          )
      ),
      // Estrellas
      Row(
        children: <Widget>[
          star,
          star,
          star,
          star,
          star_half
        ],
      )
    ],
  );
}

Widget description(String descriptionRoute){
  return Container(
    margin: EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0
    ),
    child: new Text(
      descriptionRoute,
      style: const TextStyle(
          fontFamily: "Lato",
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF56575a)
      ),
    ),
  );
}

// Media estrella
final star_half = Container(
  margin: EdgeInsets.only(
      top: 323.0,
      right: 3.0
  ),
  child: Icon(
    Icons.star_half,
    color: Color(0xFFf2C611),
  ),
);

// Borde de estrella
final star_border = Container(
  margin: EdgeInsets.only(
      top: 323.0,
      right: 3.0
  ),
  child: Icon(
    Icons.star_border,
    color: Color(0xFFf2C611),
  ),
);

//Estrella completa
final star = Container(
  margin: EdgeInsets.only(
      top: 323.0,
      right: 3.0
  ),
  child: Icon(
    Icons.star,
    color: Color(0xFFf2C611),
  ),
);
