import 'package:driver_assistant/User/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Login
  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(idToken: gSA.idToken, accessToken: gSA.accessToken));

    return user;
  }

  // Logout
  signOut() async {
    await _auth.signOut().then((onValue) => print("Firebase, Sesión cerrada!"));
    googleSignIn.signOut();
    print("Todas las sesiones cerradas!");
  }

}