import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/locator.dart';
import 'package:flutter_flutter_lovers/model/mesaj.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/repository/user_repository.dart';
import 'package:flutter_flutter_lovers/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  User _user;
  String emailHataMesaji;
  String sifreHataMesaji;

  User get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }


  @override
  Future<User> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      debugPrint("ViewModeldeki current user hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> singOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.singOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint("ViewModeldeki current user hata: " + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<List<User>> getAllUser() async {

    var tumKullaniciListesi = await _userRepository.getAllUser();
    return tumKullaniciListesi;

  }

  @override
  Future<User> singInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.singInAnonymously();
      return _user;
    } catch (e) {
      debugPrint("ViewModeldeki current user hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> singInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.singInWithGoogle();
      return _user;
    } catch (e) {
      debugPrint("ViewModeldeki current user hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> singInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.singInWithFacebook();
      return _user;
    } catch (e) {
      debugPrint("ViewModeldeki current user hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> createUserEmailandPassword(String email, String sifre) async {
    if (_emailSifreKontrol(email, sifre)) {
      try {
        state = ViewState.Busy;
        _user = await _userRepository.createUserEmailandPassword(email, sifre);
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  @override
  Future<User> singInWithEmailandPassword(String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository.singInWithEmailandPassword(email, sifre);
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmalı";
      sonuc = false;
    } else
      sifreHataMesaji = null;
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz email adresi";
      sonuc = false;
    } else
      emailHataMesaji = null;
    return sonuc;
  }

  Future<bool> updateUserName(String userId ,String yeniUserName) async{

    var sonuc = _userRepository.updateUserName(userId, yeniUserName);
    if (sonuc != null){
      _user.userName = yeniUserName;
    }
    return sonuc;


  }

  Future<String> uploadFile(String userId, String fileType, File profilFoto) async {
    var indirmeLinki = _userRepository.uploadFile(userId, fileType, profilFoto);
    return indirmeLinki;
  }

  Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetEdilenUserID) {
    return _userRepository.getMasseges(currentUserID,sohbetEdilenUserID);
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) {
    return _userRepository.saveMessage(kaydedilecekMesaj);
  }


}
