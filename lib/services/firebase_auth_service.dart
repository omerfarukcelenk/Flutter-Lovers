import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> currentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    } catch (e) {
      print("Hata Current User" + e.toString());
      return null;
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(userId: user.uid, email: user.email);
  }

  @override
  Future<User> singInAnonymously() async {
    try {
      AuthResult sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("Hata singInAnonymously " + e.toString());
      return null;
    }
  }

  @override
  Future<bool> singOut() async {
    try {
      final _googleSingIn = GoogleSignIn();
      await _googleSingIn.signOut();
      final _facebookLogin = FacebookLogin();
      await _facebookLogin.logOut();

      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("Hata singOut " + e.toString());
      return false;
    }
  }

  @override
  Future<User> singInWithGoogle() async {
    GoogleSignIn _googleSingIn = GoogleSignIn();
    GoogleSignInAccount _googleUser = await _googleSingIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        AuthResult sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        FirebaseUser _user = sonuc.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<User> singInWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    FacebookLoginResult _faceResult = await _facebookLogin
        .logIn(['public_profile', 'email']);

    switch (_faceResult.status) {
      case FacebookLoginStatus.loggedIn:
        if (_faceResult.accessToken != null) {
          AuthResult _firebaseResult = await _firebaseAuth.signInWithCredential(FacebookAuthProvider.getCredential(
              accessToken: _faceResult.accessToken.token
          ));
          FirebaseUser _user = _firebaseResult.user;
          return _userFromFirebase(_user);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("kullanıcı facebook girişini iptal etti");

        break;
      case FacebookLoginStatus.error:
        print("Hata cıktı :" + _faceResult.errorMessage);
        break;
    }
    throw null;
  }

  @override
  Future<User> createUserEmailandPassword(String email, String sifre) async{
    try {
      AuthResult sonuc = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: sifre);
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("Hata singInAnonymously " + e.toString());
      return null;
    }
  }

  @override
  Future<User> singInWithEmailandPassword(String email, String sifre) async{
    try {
      AuthResult sonuc = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: sifre);
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("Hata singInAnonymously " + e.toString());
      return null;
    }
  }
}
