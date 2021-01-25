import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:driver_assistant/User/model/user.dart';
import 'package:flutter/material.dart';

class ProfilePlacesList extends StatelessWidget {
  final UserBloc userBloc;
  final User user;

  ProfilePlacesList({
    Key key,
    @required this.userBloc,
    @required this.user,
  });

  @override
  Widget build(BuildContext context) {
    //userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      margin: EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
        bottom: 10.0,
      ),
      child: StreamBuilder(
        stream: userBloc.myPlacesListStream(user.uid),
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
                    top: 250,
                ),
                child: ListView(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  scrollDirection: Axis.vertical,
                  children: userBloc.buildMyPlaces(snapshot.data.documents),
                ),
              );
          }
        },
      ),
    );
  }
}