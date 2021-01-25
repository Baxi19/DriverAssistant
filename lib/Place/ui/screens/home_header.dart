import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:driver_assistant/User/model/user.dart';
import 'package:driver_assistant/widgets/title_app.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import '../../../widgets/gradient_back.dart';
import '../widgets/card_image_list.dart';

class HomeHeader extends StatelessWidget {
  UserBloc userBloc;
  final VoidCallback onTapImage;

  HomeHeader({Key key, this.onTapImage});

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);

    Widget showPlacesData(AsyncSnapshot snapshot){
      if(!snapshot.hasData || snapshot.hasError){
        return Stack(
          children: [
            GradientBack(height: 250.0),
            Text("Usuario no logeado. Haz Login")
          ],
        );
      }else {
        User user = User(
            uid: snapshot.data.uid,
            name: snapshot.data.displayName,
            email: snapshot.data.email,
            photoURL: snapshot.data.photoUrl
        );

        return Stack(
          children: <Widget> [
            GradientBack(height: 250.0),
            TitleApp(title: "Popular"),
            CardImageList(user: user, onTapImage: onTapImage,),
          ],
        );
      }
    }


    return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            return showPlacesData(snapshot);
          }
        }
    );


    /*
    return Stack(
      children: <Widget>[
        GradientBack(height: 250), //'Popular'
        TitleApp(title: "Popular"),
        CardImageList(),
      ],
    );

     */
  }
}
