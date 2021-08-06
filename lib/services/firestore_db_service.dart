import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/services/database_base.dart';

class FireStoreDBService implements DBBase {
  final Firestore _firestore = Firestore.instance;


  @override
  Future<bool> saveUser(User user) async {


    await _firestore
        .collection("users")
        .document(user.userId)
        .setData(user.toMap());

    DocumentSnapshot _okunanUser = await Firestore.instance.document("users/${user.userId}").get();

    Map _okunanUserBilgileriMap =  _okunanUser.data;
    User  _okunanUserBilgileriNesne =  User.fromMap(_okunanUserBilgileriMap);
    print("Okunan User Nesnesi: "+ _okunanUserBilgileriNesne.toString());


    return true;
  }

  @override
  Future<User> readUser(String userId) async{
      DocumentSnapshot _okunanUser = await _firestore.collection("users").document(userId).get();
      Map<String,dynamic> okunanUserBilgilerMap = _okunanUser.data;
      
      User _okunanUserNesnesi = User.fromMap(okunanUserBilgilerMap);
      print("Okunan User Nesnesi : "+ _okunanUserNesnesi.toString());
      return _okunanUserNesnesi;

  }


}
