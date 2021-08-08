import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flutter_lovers/app/hata_exception.dart';
import 'package:flutter_flutter_lovers/app/home_page.dart';
import 'package:flutter_flutter_lovers/common_widgets/platform_duyarli_alert_dialog.dart';
import 'package:flutter_flutter_lovers/common_widgets/social_log_in_button.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class EmailVeSifreLoginPage extends StatefulWidget {
  @override
  _EmailVeSifreLoginPageState createState() => _EmailVeSifreLoginPageState();
}

class _EmailVeSifreLoginPageState extends State<EmailVeSifreLoginPage> {
  String _email, _sifre;
  String _buttonText, _linkText;

  var _formType = FormType.LogIn;
  final _formkey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formkey.currentState.save();
    debugPrint("Email :" + _email + " şifre: " + _sifre);
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_formType == FormType.LogIn) {
      try {
        User _girisYapanUser =
            await _userModel.singInWithEmailandPassword(_email, _sifre);
        if (_girisYapanUser != null) {
          print("Oturum açan user id: " + _girisYapanUser.userId.toString());
        }
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
          label: "Oturum Açmada hata ",
          icerik: Hatalar.goster(e.code),
          anaButtonYazisi: "Tamam",
        ).goster(context);
      }
    } else {
      try {
        User _olusturulanYapanUser =
            await _userModel.createUserEmailandPassword(_email, _sifre);
        if (_olusturulanYapanUser != null) {
          print("Oturum açan user id: " +
              _olusturulanYapanUser.userId.toString());
        }
      } on PlatformException catch (e) {
        PlatformDuyarliAlertDialog(
          label: "kullanıcı olusturma hata ",
          icerik: Hatalar.goster(e.code),
          anaButtonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);

    _buttonText = _formType == FormType.LogIn ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.LogIn
        ? "Hesabınız Yok Mu? Kayıt Olun"
        : "Hesabınız Var Mı? Giriş Yapın";

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 200), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
        appBar: AppBar(title: Text("Giriş / Kayıt")),
        body: _userModel.state == ViewState.Idle
            ? SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          errorText: _userModel.emailHataMesaji != null
                              ? _userModel.emailHataMesaji
                              : null,
                          prefixIcon: Icon(Icons.mail),
                          hintText: 'Email',
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String girilenEmail) {
                          _email = girilenEmail;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          errorText: _userModel.sifreHataMesaji != null
                              ? _userModel.sifreHataMesaji
                              : null,
                          prefixIcon: Icon(Icons.mail),
                          hintText: 'Password',
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (String girilenPassword) {
                          _sifre = girilenPassword;
                        },
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      SocialLoginButton(
                        buttonText: _buttonText,
                        buttonColor: Theme.of(context).primaryColor,
                        onPressed: () => _formSubmit(),
                        radius: 20,
                        buttonIcon: Icon(
                          Icons.input,
                          size: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () => _degistir(), child: Text(_linkText))
                    ],
                  ),
                ),
              ))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
