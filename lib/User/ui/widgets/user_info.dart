import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_assistant/User/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  User user;

  UserInfo(@required this.user);

  @override
  Widget build(BuildContext context) {

    final userEmail = Row(
      children: [
        Container(
          margin: EdgeInsets.only(
            //top: 50.0,
              left: 20.0
          ),
          child: Text(
            user.email,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: "Lato",
                fontSize: 13.0,
                color: Color(0xFFa3a5a7)
            ),
          ),
        )
      ],
    );


    final userName = Container(
      margin: EdgeInsets.only(
          top: 100,
          left: 20.0
      ),
      child: Text(
        user.name,
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.white,
            fontFamily: "Lato",
            fontSize: 17.0
        ),
      ),
    );

    final userDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.start,//Alineamos al inicio que es como si se alineara a la izquierda
      children: [//Realizamos la apilacion de nuestros widgets
        userName,
        userEmail
      ],
    );

    //Creamos variable Photo
    final photo = Container (
      margin: EdgeInsets.only(//Manejamos unos margenes
          top: 80.0,
          left: 20.0,
      ),
      //Definimos el ancho y el alto que queremos que tenga esa foto
      width: 80.0,
      height: 80.0,

      decoration: BoxDecoration(
        //shape es que forma quiero que tenga ese contenedor

          shape: BoxShape.circle,
          image: DecorationImage(//Para funcionar el AssetImage necesita estar dentro de un DecorationImage
              fit: BoxFit.fill,//Con fit indicamos la posicion de la imagen dentro del contenedor
              //image: NetworkImage(user.photoURL),
              image: CachedNetworkImageProvider(user.photoURL),
          ),
          boxShadow: <BoxShadow>[//Agregamos un borde o sombra
            BoxShadow(
              color: Colors.white,
              spreadRadius: 3,//tamano del borde
            )
          ]
      ),
    );

    return Row(//Recordemos que le Row lleva hijos
        children: [
          photo,
          userDetails //userDetails contiene la apilacion de todos los elementos widgets que podemos mostrar
        ],
    );
  }

}
