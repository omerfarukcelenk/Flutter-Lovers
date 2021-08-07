import 'package:flutter/cupertino.dart';
import 'package:flutter_flutter_lovers/locator.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/services/auth_base.dart';
import 'package:flutter_flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_flutter_lovers/services/firebase_auth_service.dart';
import 'package:flutter_flutter_lovers/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<User> singInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singInAnonymously();
    } else {
      return await _firebaseAuthService.singInAnonymously();
    }
  }

  @override
  Future<bool> singOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singOut();
    } else {
      return await _firebaseAuthService.singOut();
    }
  }

  @override
  Future<User> singInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singInWithGoogle();
    } else {
      User _user = await _firebaseAuthService.singInWithGoogle();
      bool _sonuc = await _fireStoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _fireStoreDBService.readUser(_user.userId);
      } else
        return null;
    }
  }

  @override
  Future<User> singInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singInWithFacebook();
    } else {
      User _user = await _firebaseAuthService.singInWithFacebook();
      bool _sonuc = await _fireStoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _fireStoreDBService.readUser(_user.userId);
      } else
        return null;
    }
  }

  @override
  Future<User> createUserEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.createUserEmailandPassword(
          email, sifre);
    } else {
      User _user =
          await _firebaseAuthService.createUserEmailandPassword(email, sifre);
      bool _sonuc = await _fireStoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _fireStoreDBService.readUser(_user.userId);
      } else
        return null;
    }
  }

  @override
  Future<User> singInWithEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.singInWithEmailandPassword(
          email, sifre);
    } else {
      try {
        User _user =
            await _firebaseAuthService.singInWithEmailandPassword(email, sifre);
        return await _fireStoreDBService.readUser(_user.userId);
      } catch (e) {
        debugPrint(
            "Repoda singInWithEmailandPassword hata var : " + e.toString());
      }
    }
  }
}
