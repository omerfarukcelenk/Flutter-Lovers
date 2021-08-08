import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/common_widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_flutter_lovers/common_widgets/social_log_in_button.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;

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
                  child: CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(_userModel.user.profilUrl),
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

      if(updateResult == true){
        _userModel.user.userName = _controllerUserName.text;
        PlatformDuyarliAlertDialog(
          label: "Başarılı",
          icerik: "Username değiştirildi",
          anaButtonYazisi: "Tamam",
        ).goster(context);
      }else{
        _controllerUserName.text = _userModel.user.userName;
        PlatformDuyarliAlertDialog(
          label: "Başarılı",
          icerik: "Username zaten kullanımda, farklı bir username deneyiniz",
          anaButtonYazisi: "Tamam",
        ).goster(context);
      }
    } else {
      PlatformDuyarliAlertDialog(
        label: "Hata",
        icerik: "Username değişikliği yapmadınız",
        anaButtonYazisi: "Tamam",
      ).goster(context);
    }
  }
}
