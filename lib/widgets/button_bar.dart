import 'file:///C:/Users/Baxi/Desktop/driving_assistant/lib/AI/bloc/singleton.dart';
import 'package:driver_assistant/Place/model/place.dart';
import 'package:driver_assistant/Place/ui/screens/map.dart';
import 'package:driver_assistant/User/bloc/bloc_user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import '../Place/ui/screens/home.dart';
import '../User/ui/screens/profile.dart';

class ButtonsBar extends StatefulWidget {
  int idx = 0;
  ButtonsBar(this.idx);

  @override
  _ButtonsBarState createState() => _ButtonsBarState(idx);
}

class _ButtonsBarState extends State<ButtonsBar> {
  UserBloc userBloc;
  int index = 0;
  _ButtonsBarState(this.index);

  final List<Widget> widgetsChildren = [
    BlocProvider(child: Home(), bloc: UserBloc()),
    //SearchTrips(),
    //GoogleMaps(),
    BlocProvider(child: Map(), bloc: UserBloc()),
    Profile(),
  ];

  void onTapTapped(int index){
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    //TODO: get places in list to set at placesList

    return Scaffold(
      body: widgetsChildren[this.index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
          primaryColor: Colors.indigo
        ),
        child: BottomNavigationBar(
          onTap: onTapTapped,
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text("")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                title: Text("")
            ),
          ],
        ),
      ),
    );
  }
}
