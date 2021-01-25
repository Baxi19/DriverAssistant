import 'package:driver_assistant/AI/bloc/singleton.dart';
import 'package:driver_assistant/User/model/user.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../bloc/bloc_user.dart';
import '../../../main.dart';
import '../../../widgets/button_green.dart';
import '../../../widgets/gradient_back.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  UserBloc userBloc;
  double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    userBloc = BlocProvider.of(context);
    return _handleCurrentSession();
  }

  // checks if session is active
  Widget _handleCurrentSession(){
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //snapshot- data - Object User
        if(!snapshot.hasData || snapshot.hasError) {
          return signInGoogleUI();
        } else {
          FirebaseAuth.instance.currentUser().then((value) =>{
              Singleton().user = User(
                uid: value.uid,
                name: value.displayName,
                email: value.email,
                photoURL: value.photoUrl
              )
          });
          return MyApp();
        }
      },
    );
  }

  Widget signInGoogleUI(){
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget> [
          GradientBack(height: null),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child:Container(
                  padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
                  //width: screenWidth,
                  child: Text("Driving \nAssistant App!",
                    style: TextStyle(
                        fontSize: 37.0,
                        fontFamily: "Lato",
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              ButtonGreen(
                  text: "Login with Gmail",
                  onPresset:() async {
                    await userBloc.signIn().then((FirebaseUser user) => {
                      userBloc.user = User(uid: user.uid, name: user.displayName, email: user.email, photoURL: user.photoUrl),
                      userBloc.updateUserData(userBloc.user),
                      //save user
                      Singleton().user = userBloc.user,
                      Singleton().userList.add(userBloc.user),
                    });
                  },
                  width: 300.0,
                  height: 50.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
