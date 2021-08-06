import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil",style: TextStyle(fontSize: 20),),
        actions: [
          TextButton(onPressed:() => _cikisYap(context), child: Text("Çıkış",style: TextStyle(color: Colors.white,fontSize: 20),))
        ],
      ),
      body: Center(child: Text("Profil Sayfası"),),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.singOut();
    return sonuc;
  }
}
