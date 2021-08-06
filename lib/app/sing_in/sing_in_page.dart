import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/app/sing_in/email_sifre_giris_ve_kayit.dart';
import 'package:flutter_flutter_lovers/common_widgets/social_log_in_button.dart';
import 'package:flutter_flutter_lovers/model/user_model.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  void _misafirGirisi(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    User _user = await _userModel.singInAnonymously();
    print("Oturum açan user id: " + _user.userId.toString());
  }

  void _googleIleGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    User _user = await _userModel.singInWithGoogle();
    if (_user != null) {
      print("Oturum açan user id: " + _user.userId.toString());
    }
  }

  void _facebookIleGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    User _user = await _userModel.singInWithFacebook();
    if (_user != null) {
      print("Oturum açan user id: " + _user.userId.toString());
    }
  }

  void _emailVeSifteGiris(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EmailVeSifreLoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Lovers"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(
              height: 8,
            ),
            Column(children: [
              SocialLoginButton(
                  buttonText: "Gmail ile Giriş Yap",
                  buttonColor: Colors.black87,
                  textColor: Colors.white,
                  buttonIcon: SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset("images/google.png")),
                  onPressed: () => _googleIleGiris(context)),
              SocialLoginButton(
                  buttonText: "Facebook İle Giriş Yap",
                  buttonColor: Color(0xFF334D92),
                  textColor: Colors.white,
                  radius: 16,
                  buttonIcon: SizedBox(
                      width: 30,
                      height: 30,
                      child: Image.asset("images/facebook.png")),
                  onPressed: () => _facebookIleGiris(context)),
              SocialLoginButton(
                  buttonText: "Email ve Şifre ile Giriş Yap",
                  buttonColor: Colors.pinkAccent,
                  buttonIcon: Icon(
                    Icons.email,
                    size: 32,
                  ),
                  onPressed: () => _emailVeSifteGiris(context)
              ),
              SocialLoginButton(
                  buttonText: "Misafit Girişi",
                  buttonColor: Colors.green,
                  buttonIcon: Icon(
                    Icons.person,
                    size: 32,
                  ),
                  onPressed: () => _misafirGirisi(context)),
            ]),
          ],
        ),
      ),
    );
  }
}
