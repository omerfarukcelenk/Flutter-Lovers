import 'package:flutter_flutter_lovers/model/user.dart';

abstract class AuthBase{

  Future<User> currentUser();
  Future<User> singInAnonymously();
  Future<bool> singOut();
  Future<User> singInWithGoogle();
  Future<User> singInWithFacebook();
  Future<User> singInWithEmailandPassword(String email, String sifre);
  Future<User> createUserEmailandPassword(String email, String sifre);



}