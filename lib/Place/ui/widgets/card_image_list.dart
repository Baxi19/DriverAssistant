import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:driver_assistant/User/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';

class CardImageList extends StatefulWidget {

  User user;
  final VoidCallback onTapImage;
  CardImageList({@required this.user, @required this.onTapImage});

  @override
  _CardImageListState createState() => _CardImageListState();
}

class _CardImageListState extends State<CardImageList> {
  UserBloc userBloc;
  double width = 250.0;
  double height = 200.0;
  double left = 20.0;

  @override
  Widget build(BuildContext context) {
    userBloc =  BlocProvider.of(context);

    return Container(
      height: 350.0,
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
              return Container(
                margin: EdgeInsets.only(
                    bottom: 10.0
                ),

                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: userBloc.buildPlaces(snapshot.data.documents, context, widget.user, widget.onTapImage),
                ),
              );
          }
        },
      ),
    );
  }
}


/*
class CardImageList extends StatelessWidget {
  UserBloc userBloc;
  double width = 250.0;
  double height = 200.0;
  double left = 20.0;

  @override
  Widget build(BuildContext context) {
    userBloc =  BlocProvider.of(context);
    return Container(
        height: 350.0,
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
                return Container(
                  margin: EdgeInsets.only(
                    top: 0.0,
                    //left: 20.0,
                    //right: 20.0,
                    bottom: 20.0
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,//Axis para que el Scroll sea Horizontal
                    children: userBloc.buildPlaces(snapshot.data.documents, context),
                  ),
                );
            }
          },
        ),
    );
  }
}

 */

