import 'package:flutter_flutter_lovers/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(User user);
  Future<User> readUser(String userId);
  Future<bool> updateUserName(String userId, String yeniUserName);
}
