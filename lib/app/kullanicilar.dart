
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/app/konusma.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    _userModel.getAllUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.adb))],
      ),
      body: FutureBuilder<List<User>>(
          future: _userModel.getAllUser(),
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              var tumKullanicilar = sonuc.data;

              if (tumKullanicilar.length - 1 > 0) {
                return ListView.builder(
                    itemCount: tumKullanicilar.length,
                    itemBuilder: (context, index) {
                      var oankiUser = sonuc.data[index];
                      if (sonuc.data[index].userId != _userModel.user.userId) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Konusma(sohbetEdilenUser: _userModel.user, currentUser: oankiUser,)));
                          },
                          child: ListTile(
                            title: Text(oankiUser.userName),
                            subtitle: Text(oankiUser.email),
                            leading: CircleAvatar(backgroundImage: NetworkImage(oankiUser.profilUrl)),
                          ),
                        );
                      }else{
                        return Container();
                      }
                    });
              } else {
                return Center(
                  child: Text("Kayıtlı bir kullanıcı yok"),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
