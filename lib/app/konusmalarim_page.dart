import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/model/konusma.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Konuşmalarım"),
      ),
      body: FutureBuilder<List<Konusma>>(
        future: _userModel.getAllConversations(_userModel.user.userId),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = konusmaListesi.data;

            return ListView.builder(
              itemBuilder: (context, index) {
                var oAnkiKonusma = tumKonusmalar[index];
                return ListTile(
                  title: Text(oAnkiKonusma.son_yollanan_mesaj),
                  subtitle: Text(oAnkiKonusma.konusulanUserName),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(oAnkiKonusma.konusulanUserProfileURL),
                  ),
                );
              },
              itemCount: tumKonusmalar.length,
            );
          }
        },
      ),
    );
  }

  void _konusmalariGetir() async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    var konusmalarim = await Firestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _userModel.user.userId)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

    for (var konusma in konusmalarim.documents) {
      print("konusma: " + konusma.data.toString());
    }
  }
}
