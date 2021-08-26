import 'package:flutter_flutter_lovers/model/konusma.dart';
import 'package:flutter_flutter_lovers/model/mesaj.dart';
import 'package:flutter_flutter_lovers/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(User user);
  Future<User> readUser(String userId);
  Future<bool> updateUserName(String userId, String yeniUserName);
  Future<bool> updateProfilFoto(String userID, String profilFotoUrl);
  Future<List<User>> getAllUser();
  Future<List<Konusma>> getAllConversations(String userID);
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
  Future<DateTime> saatiGoster(String userID);
}
