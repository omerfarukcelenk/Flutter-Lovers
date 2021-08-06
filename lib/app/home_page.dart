import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/model/user_model.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {


  final User user;
  HomePage({Key key,@required this.user}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AnaSayfa"),
      actions: [
        TextButton(onPressed: ()=> _cikisYap(context),child: Text("Çıkış yap",style: TextStyle(color: Colors.white),),)
      ],),
      body: Center(
        child: Text("Hoşgeldiniz ${user.userId}"),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async{
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.singOut();
    return sonuc;
  }
}
