import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:driver_assistant/User/ui/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'AI/ui/widgets/live_camera.dart';
import 'widgets/button_bar.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'User/bloc/bloc_user.dart';

// to generate the
// keytool -exportcert -alias androiddebugkey -keystore "C:\Users\Baxi\.android\debug.keystore" -list -v

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the cameras when the app starts
  cameras = await availableCameras();
  runApp(LoadData());
}

class LoadData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SignInScreen(),
      ),
      bloc: UserBloc(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final picker = ImagePicker();
  UserBloc userBloc;

  @override
  Widget build(BuildContext context) {

    return PageView(
        scrollDirection: Axis.vertical,
        children: <Widget> [
          ButtonsBar(0),
          LiveFeed(cameras),
        ],
      //),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driving Assistant"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.developer_mode_rounded),
            onPressed: aboutDialog,
          ),
        ],
      ),
      body: PageView(
        children: <Widget> [
              page(),
              StaticImage(),
              LiveFeed(cameras),
            ],
          ),
      bottomNavigationBar: CurvedNavigationBar(
        color:  Colors.black26,
        backgroundColor: Colors.black26,
        buttonBackgroundColor: Colors.cyan,
        height: 50,
        items: <Widget> [
          Icon(Icons.image_outlined, size: 20, color: Colors.white),
          Icon(Icons.home_outlined, size: 20, color: Colors.white),
          Icon(Icons.camera_outlined, size: 20, color: Colors.white),
        ],
        animationDuration: Duration(
          milliseconds: 185,
        ),
        index: 1,
        animationCurve: Curves.bounceInOut,
        onTap: (index){
          if(index == 0){
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Maps()));
          }else if(index == 1){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
          } else if(index == 2){
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
          }
          debugPrint("Current index is $index ");
        },
      ),
    );
  }

   */
}