import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_assistant/Place/model/place.dart';
import 'package:driver_assistant/Place/ui/screens/map.dart';
import 'package:flutter/material.dart';
import '../../../widgets/floating_action_button_green.dart';

class ProfileCardImage extends StatelessWidget {
  Place place;
  //String pathImage = "assets/img/beach.jpeg";
  //String titleImage = "Knuckles Mountains Range";
  //String descriptionImage = "Hiking water tall hunting, Natural bath, Scenery y Photography";
  //String steps = "Steps 123,123,123";
  var _imageFile;


  ProfileCardImage({Key key, @required this.place});


  getImage(){
      _imageFile = Image.network(place.urlImage);
  }

  @override
  Widget build(BuildContext context) {
    getImage();
    // Widget para titulo de la imagen
    final title_card = Container(
      margin: EdgeInsets.only(
          top: 10,
          left: 20
      ),
      child: Text(
        place.name,
        //titleImage,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: "Lato",
            fontSize: 15.0,
            fontWeight: FontWeight.bold
        ),
      ),
    );

    // Widget que contiene la descripcion
    final description_card = Container(
      margin: EdgeInsets.only(
          top: 10.0,//Posision en la pantalla
          left: 20
      ),
      child: Text(
        place.description,
        //descriptionImage,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: "Lato",
            fontSize: 10.0,
            color: Color(0xFFa3a5a7)
        ),
      ),
    );

    // Widget que contiene los likes
    final steps_card = Container(
      margin: EdgeInsets.only(
          top: 10.0,//Posision en la pantalla
          left: 20
      ),
      child: Text(
        "Likes : ${place.likes.toString()}",
        //steps,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: "Lato",
          fontSize: 12.0,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(232, 166, 90, 1),
        ),
      ),
    );




    final card = Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,//tamaño de la pantalla automatico
          height: 200,
          margin: EdgeInsets.only(
            top: 25,
            //left: 20
          ),
          //Agregamos la decoracion como imagen
          decoration: BoxDecoration(
              image:DecorationImage(
                  fit: BoxFit.fill,
                  //image: place.urlImage.contains("http") ? Image.network(place.urlImage.toString()) :AssetImage(place.urlImage),
                  //image: AssetImage(place.urlImage),
                    image: _imageFile == null
                    ? AssetImage('assets/img/img.png')
                    : //NetworkImage(place.urlImage),
                    CachedNetworkImageProvider(place.urlImage),


              ),


              //Asemos que la imagen sea redonda
              borderRadius: BorderRadius.all(Radius.circular(10)),
              shape: BoxShape.rectangle,//Haacemos que la imagen sea rectangular
              boxShadow: <BoxShadow>[//Agregamos una sombra
                BoxShadow(
                    color: Colors.black38,
                    blurRadius: 15,//Que tan degradado quiero que quede
                    offset: Offset(0,7)//la posicion de la sombra en X y en Y
                )
              ]
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width,//tamaño de la pantalla automatico
            height: 100.0,
            margin: EdgeInsets.only(
                top: 180,
                left: 40,
                right: 40
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,//Alineamos al inicio que es como si se alineara a la izquierda
              children: [//Realizamos la apilacion de nuestros widgets
                title_card,
                description_card,
                steps_card
              ],
            ),
            //Agregamos la decoracion como imagen
            decoration: BoxDecoration(
                color: Colors.white,
                //Asemos que la imagen sea redonda
                borderRadius: BorderRadius.all(Radius.circular(10)),
                shape: BoxShape.rectangle,//Haacemos que la imagen sea rectangular
                boxShadow: <BoxShadow>[//Agregamos una sombra
                  BoxShadow(
                      color: Colors.black38,
                      blurRadius: 15,//Que tan degradado quiero que quede
                      offset: Offset(0,7)//la posicion de la sombra en X y en Y
                  )
                ]
            ),
          ),
        )
      ],
    );

    //Devolvemos la imagen
    return Stack(
      alignment: Alignment(0.6,1.1),
      children: [
        card,
        FloatingActionButtonGreenC(
          iconData: Icons.directions_car,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => Map()),
            );
          },),
      ],
    );
  }

}