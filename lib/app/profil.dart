import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/common_widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_flutter_lovers/common_widgets/social_log_in_button.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;

  File _profilFoto;

  void _kameradanFotoCek() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _profilFoto = File(pickedFile.path);
        Navigator.of(context).pop();
      });
    }
  }

  void _galeridenResimSec() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _profilFoto = File(pickedFile.path);
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    _controllerUserName.text = _userModel.user.userName;
    print("Profil sayfasomdaki user değerleri :" + _userModel.user.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profil",
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
                onPressed: () => _cikisIcinOnayIste(context),
                child: Text(
                  "Çıkış",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: 160,
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.camera),
                                    title: Text("Kamerada Çek"),
                                    onTap: () {
                                      _kameradanFotoCek();
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.image),
                                    title: Text("Galeriden Seç"),
                                    onTap: () {
                                      _galeridenResimSec();
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.white,
                      backgroundImage: _profilFoto == null ? NetworkImage(_userModel.user.profilUrl) : FileImage(_profilFoto),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    initialValue: _userModel.user.email,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Emailiniz",
                      hintText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerUserName,
                    decoration: InputDecoration(
                      labelText: "Kullanıcı Adınız",
                      hintText: "Kullanıcı Adınız",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SocialLoginButton(
                    buttonText: "Değişikleri Kaydet",
                    onPressed: () {
                      _userNameGuncelle(context);
                      _profilFotoGuncelle(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.singOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
            label: "Emin misiniz",
            icerik: "Çıkmak istediğinizden emin misiniz ?",
            anaButtonYazisi: "Evet",
            iptalButtonYazisi: "Vazgeç")
        .goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user.userId, _controllerUserName.text);

      if (updateResult == true) {
        _userModel.user.userName = _controllerUserName.text;
        PlatformDuyarliAlertDialog(
          label: "Başarılı",
          icerik: "Username değiştirildi",
          anaButtonYazisi: "Tamam",
        ).goster(context);
      } else {
        _controllerUserName.text = _userModel.user.userName;
        PlatformDuyarliAlertDialog(
          label: "Başarılı",
          icerik: "Username zaten kullanımda, farklı bir username deneyiniz",
          anaButtonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }

  Future<void> _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if(_profilFoto != null){
      var url = await _userModel.uploadFile(_userModel.user.userId, "profil_foto", _profilFoto);
      print("gelen url : $url");
    }

  }


}
