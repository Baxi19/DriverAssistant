import 'package:driver_assistant/widgets/gradient_back.dart';
import 'package:driver_assistant/widgets/title_app.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import '../../bloc/bloc_user.dart';
import '../../model/user.dart';
import '../widgets/profile_place_list.dart';
import '../widgets/user_info.dart';



class ProfileHeader extends StatelessWidget {
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {

    userBloc = BlocProvider.of(context);
    return BlocProvider(
        child: Container(
          child: PrepareData(),
        ),
        bloc: UserBloc()
    );
  }
}

class PrepareData extends StatelessWidget {
  UserBloc userBloc;
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return streamFunction(userBloc);
  }
}

Widget streamFunction(UserBloc userBloc){
  return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }else{
          return showProfileData(snapshot, userBloc);
        }
      }
  );
}

Widget showProfileData(AsyncSnapshot snapshot, UserBloc userBloc){
  User user;
  if(!snapshot.hasData || snapshot.hasError){
    print("\n\n==>No logeado");
    return Container(
      margin: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 50.0
      ),
      child: Column(
        children: [
          CircularProgressIndicator(),
          Text("Can't load the information, please login again"),
        ],
      ),
    );
    /*user = User(name:"User's name", email:"user@gmail.com", photoURL:"https://universoestetico.com.pe/storage/image/wPvAjRZaB7rzfD9yEzkCszL47ZzX26Min0txtPAN.png");
    return Stack(//Stack me permite acomodar un Widget sobre otro Widget
      children:<Widget> [
        GradientBack(height: 400.0),
        TitleApp(title: "Profile"),
        ListView(//Enviamos nuestro contenido en forma de lista para que podamos utilizar el scroll
          children: [//Agrupamos los elementos
            UserInfo(user),
          ],
        ),
        ProfilePlacesList(userBloc),
      ],
    );*/
  }else{
    //print("\n\n===>Logeado: " + snapshot.data.toString());
    user = User(uid: snapshot.data.uid ,name: snapshot.data.displayName, email: snapshot.data.email, photoURL: snapshot.data.photoUrl);
    print("\n\n===>Logeado: " + user.uid);
    return Stack(//Stack me permite acomodar un Widget sobre otro Widget
      children: <Widget>[
        GradientBack(height: 400.0),
        TitleApp(title: "Profile"),
        ListView(//Enviamos nuestro contenido en forma de lista para que podamos utilizar el scroll
          children: [//Agrupamos los elementos
            UserInfo(user),
          ],
        ),
        ProfilePlacesList(userBloc: userBloc, user: user,),
      ],
    );
  }
}