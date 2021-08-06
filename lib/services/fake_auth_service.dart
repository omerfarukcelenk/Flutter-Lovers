import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "1011011110100101110101011";

  @override
  Future<User> currentUser() async {
    return await Future.value(User(userId: userID,email: "fakeuser@fake.com"));
  }

  @override
  Future<User> singInAnonymously() async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userId: userID,email: "fakeuser@fake.com"));
  }

  @override
  Future<bool> singOut() {
    return Future.value(true);
  }

  @override
  Future<User> singInWithGoogle() async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userId: "google_user_id_156446",email: "fakeuser@fake.com"));
  }

  @override
  Future<User> singInWithFacebook() async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userId: "facebook_user_id_154654",email: "fakeuser@fake.com"));
  }

  @override
  Future<User> createUserEmailandPassword(String email, String sifre) async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userId: "creted_user_id_154654",email: "fakeuser@fake.com"));
  }

  @override
  Future<User> singInWithEmailandPassword(String email, String sifre) async {
    return await Future.delayed(
        Duration(seconds: 2), () => User(userId: "singIn_user_id_154654",email: "fakeuser@fake.com"));
  }
}
