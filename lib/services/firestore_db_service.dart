import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_flutter_lovers/model/mesaj.dart';
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

    DocumentSnapshot _okunanUser =
        await Firestore.instance.document("users/${user.userId}").get();

    Map _okunanUserBilgileriMap = _okunanUser.data;
    User _okunanUserBilgileriNesne = User.fromMap(_okunanUserBilgileriMap);
    print("Okunan User Nesnesi: " + _okunanUserBilgileriNesne.toString());

    return true;
  }

  @override
  Future<User> readUser(String userId) async {
    DocumentSnapshot _okunanUser =
        await _firestore.collection("users").document(userId).get();
    Map<String, dynamic> okunanUserBilgilerMap = _okunanUser.data;

    User _okunanUserNesnesi = User.fromMap(okunanUserBilgilerMap);
    print("Okunan User Nesnesi : " + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userId, String yeniUserName) async {
    var users = await _firestore
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .getDocuments();
    if (users.documents.length >= 1) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .document(userId)
          .updateData({'userName': yeniUserName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoUrl) async {
    await _firestore
        .collection("users")
        .document(userID)
        .updateData({'profileURL': profilFotoUrl});
    return true;
  }

  @override
  Future<List<User>> getAllUser() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("users").getDocuments();

    List<User> tumKullanicilar = [];
    for (DocumentSnapshot tekUser in querySnapshot.documents) {
      User _tekUser = User.fromMap(tekUser.data);
      tumKullanicilar.add(_tekUser);
    }

    // Map Metotu ile

    tumKullanicilar = querySnapshot.documents
        .map((tekSatir) => User.fromMap(tekSatir.data))
        .toList();

    return tumKullanicilar;
  }

  /*
  @override
  Stream<Mesaj> getMessage(
      String currentUserID, String konusulanUserID)  {
    var snapShot =  _firestore
        .collection("konusmalar")
        .document(currentUserID + "--" + konusulanUserID)
        .collection("mesajlar")
        .document(currentUserID)
        .snapshots();

    return snapShot.map((snapShot) => Mesaj.fromMap(snapShot.data));
  }
  */

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUser) {
    var snapShot = _firestore
        .collection("konusmalar")
        .document(currentUserID + "--" + sohbetEdilenUser)
        .collection("mesajlar")
        .orderBy("date",descending: true)
        .snapshots();

    return snapShot.map((mesajListesi) => mesajListesi.documents
        .map((mesaj) => Mesaj.fromMap(mesaj.data))
        .toList());
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firestore.collection("konusmalar").document().documentID;
    var _myDocumentID =
        kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentId =
        kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;
    var _kaydedilecekMesajYapisi = kaydedilecekMesaj.toMap();

    await _firestore
        .collection("konusmalar")
        .document(_myDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajYapisi);

    _kaydedilecekMesajYapisi.update("bendenMi", (deger) => false);

    await _firestore
        .collection("konusmalar")
        .document(_receiverDocumentId)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajYapisi);

    return true;
  }
}
