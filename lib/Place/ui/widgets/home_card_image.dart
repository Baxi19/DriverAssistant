import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_assistant/AI/bloc/singleton.dart';
import 'package:driver_assistant/Place/model/place.dart';
import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import '../../../widgets/floating_action_button_green.dart';

class HomeCardImage extends StatelessWidget {
  UserBloc userBloc;
  final Place place;
  double height = 350.0;
  double width = 250.0;
  double left = 20.0;
  final VoidCallback onPressFabIcon;
  final VoidCallback onTapImage;
  final IconData iconData;

  HomeCardImage({
    Key key,
    @required this.place,
    @required this.onPressFabIcon,
    @required this.onTapImage,
    @required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    // card image
    final card = GestureDetector(
      onTap: (){
        //TODO: show info in other widget
        userBloc.placeName = place.name;
        userBloc.placeDescription = place.description;
        userBloc.place = place;
        //TODO: check if data is updated
        Singleton().place = place;
        Singleton().name = place.name;
        Singleton().description = place.description;
        print("===> 2) HELLO I'M ${Singleton().name}, my location is ${Singleton().place.lat} , ${Singleton().place.lon}");
        onTapImage();
      },
      child: Container(
        height: 220,
        width: MediaQuery.of(context).size.width - 40,
        margin: EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 20.0,
            bottom: 20.0
        ),
        //padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              //image: NetworkImage(pathImage),
              image: CachedNetworkImageProvider(place.urlImage),
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            shape: BoxShape.rectangle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 7.0)
              )
            ]
        ),
      ),
    );

    return Stack(
      alignment: Alignment(0.7, 1.0),
      children: [
        card,
        FloatingActionButtonGreenC(iconData: iconData, onPressed: onPressFabIcon,),
      ],
    );
  }
}
