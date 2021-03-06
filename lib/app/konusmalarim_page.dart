import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/app/sohbet_page.dart';
import 'package:flutter_flutter_lovers/model/konusma.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
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

            if (tumKonusmalar.length > 0) {
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var oAnkiKonusma = tumKonusmalar[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: (context) => SohbetPage(
                                      sohbetEdilenUser: _userModel.user,
                                      currentUser: User.idVeResim(
                                          userId: oAnkiKonusma.kimle_konusuyor,
                                          profilUrl: oAnkiKonusma
                                              .konusulanUserProfileURL),
                                    )));
                      },
                      child: ListTile(
                        title: Text(oAnkiKonusma.son_yollanan_mesaj),
                        subtitle: Text(oAnkiKonusma.konusulanUserName +
                            "                                               " +
                            oAnkiKonusma.aradakiFark),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              oAnkiKonusma.konusulanUserProfileURL),
                        ),
                      ),
                    );
                  },
                  itemCount: tumKonusmalar.length,
                ),
              );
            } else {
              return RefreshIndicator(
                onRefresh: _konusmalarimListesiniYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          Text(
                            "Henüz Konuşma Yok",
                            style: TextStyle(fontSize: 36),
                          ),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }
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

  Future<Null> _konusmalarimListesiniYenile() async {
    setState(() {});
    Future.delayed(Duration(seconds: 2));

    return null;
  }
}
