import 'package:flutter_flutter_lovers/model/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(User user);
}
