import 'dart:io';

import 'package:flutter_flutter_lovers/locator.dart';
import 'package:flutter_flutter_lovers/model/konusma.dart';
import 'package:flutter_flutter_lovers/model/mesaj.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/services/auth_base.dart';
import 'package:flutter_flutter_lovers/services/fake_auth_service.dart';
import 'package:flutter_flutter_lovers/services/firebase_auth_service.dart';
import 'package:flutter_flutter_lovers/services/firebase_storage_service.dart';
import 'package:flutter_flutter_lovers/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();
  FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
  List<User> tumKullaniciListesi = [];

  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      User _user = await _firebaseAuthService.currentUser();
      return await _fireStoreDBService.readUser(_user.userId);
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
      User _user =
          await _firebaseAuthService.singInWithEmailandPassword(email, sifre);
      return await _fireStoreDBService.readUser(_user.userId);
    }
  }

  Future<bool> updateUserName(String userId, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _fireStoreDBService.updateUserName(userId, yeniUserName);
    }
  }

  Future<String> uploadFile(
      String userId, String fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirme linki";
    } else {
      var profilFotoUrl = await _firebaseStorageService.uploadFile(
          userId, fileType, profilFoto);

      await _fireStoreDBService.updateProfilFoto(userId, profilFotoUrl);

      return profilFotoUrl;
    }
  }

  Future<List<User>> getAllUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi = await _fireStoreDBService.getAllUser();
      return tumKullaniciListesi;
    }
  }

  Stream<List<Mesaj>> getMasseges(
      String currentUserID, String sohbetEdilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _fireStoreDBService.getMessages(currentUserID, sohbetEdilenUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _fireStoreDBService.saveMessage(kaydedilecekMesaj);
    }
  }

  Future<List<Konusma>> getAllConversations(String userId) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await _fireStoreDBService.saatiGoster(userId);

      var konusmaListesi =
          await _fireStoreDBService.getAllConversations(userId);

      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            listedeUserBul(oankiKonusma.kimle_konusuyor);
        if (userListesindekiKullanici != null) {
          print("Veriler local cacheden okundu");
          oankiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserProfileURL =
              userListesindekiKullanici.profilUrl;
        } else {
          print("Veriler veri tabanında okundu");
          print(
              "aranalılan user daha önceden veritabanından getirilmemiş, o yüzden veritabanından bu değeri okumalıyız");
          var _veritabanindanOkunanUser =
              await _fireStoreDBService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.konusulanUserName = _veritabanindanOkunanUser.userName;
          oankiKonusma.konusulanUserProfileURL =
              _veritabanindanOkunanUser.profilUrl;
        }
        timeagoHesapla(oankiKonusma, _zaman);
      }
      return konusmaListesi;
    }
  }

  User listedeUserBul(String userID) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i].userId == userID) {
        return tumKullaniciListesi[i];
      }
    }
    return null;
  }

  void timeagoHesapla(Konusma oankiKonusma, DateTime zaman) {
    oankiKonusma.sonOkunmaZamani = zaman;

    timeago.setLocaleMessages("tr", timeago.TrMessages());

    var _duration = zaman.difference(oankiKonusma.olusturulma_tarihi.toDate());
    oankiKonusma.aradakiFark =
        timeago.format(zaman.subtract(_duration), locale: "tr");
  }
}
