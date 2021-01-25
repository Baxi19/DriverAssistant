import 'package:flutter/material.dart';

class Review extends StatelessWidget {
  String pathImage = "assets/img/car.jpg";
  String name = 'User 1';
  String details = '1 review, 5 photos';
  String comment = 'There is a best route';

  //Constructor
  Review(this.pathImage, this.name, this.details, this.comment);

  @override
  Widget build(BuildContext context) {

    // Media estrella
    final star_half = Container(
      margin: EdgeInsets.only(
          top: 3.0,
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
          top: 3.0,
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
          top: 3.0,
          right: 3.0
      ),
      child: Icon(
        Icons.star,
        color: Color(0xFFf2C611),
      ),
    );


    //User comments
    final userComment = Container(
        margin: EdgeInsets.only(
            left: 20.0
        ),
        child: Text(
          comment,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 13.0,
              fontWeight: FontWeight.w900
          ),
        )
    );

    // User Info
    final userInfo =  Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
            left: 20.0
          ),
            child: Text(
            details,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 13.0,
              color: Color(0xFFa3a5a7)
            ),
          )
        ),
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


    // User's name
    final userName = Container(
      margin: EdgeInsets.only(
        left: 20.0
      ),
      child: Text(
        name,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 17.0
        ),
      )
    );

    // User details
    final userDetails = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        userName,
        userInfo,
        userComment
      ],
    );

    // Photo
    final photo = Container(
      margin: EdgeInsets.only(
        top: 20.0,
        left: 20.0
      ),
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(pathImage)
        ),
      ),
    );


    return Row(
      children: <Widget>[
        photo,
        userDetails
      ],
    );
  }
}
