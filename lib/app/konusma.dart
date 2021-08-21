import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/model/mesaj.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Konusma extends StatefulWidget {
  final User currentUser;
  final User sohbetEdilenUser;

  Konusma({this.currentUser, this.sohbetEdilenUser});

  @override
  _KonusmaState createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    User _currentUser = widget.currentUser;
    User _sohbetEdilenUser = widget.sohbetEdilenUser;

    return Scaffold(
        appBar: AppBar(
          title: Text("Sohbet"),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Expanded(
                child: StreamBuilder<List<Mesaj>>(
              stream: _userModel.getMessages(
                  _currentUser.userId, _sohbetEdilenUser.userId),
              builder: (context, streamMesajlarListesi) {
                if (!streamMesajlarListesi.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<Mesaj> tumMesajlar = streamMesajlarListesi.data;
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemBuilder: (context, index) {
                    return _konusmaBalonuOlustur(tumMesajlar[index]);
                  },
                  itemCount: tumMesajlar.length,
                );
              },
            )),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                        controller: _mesajController,
                        cursorColor: Colors.blueGrey,
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Mesajınızı Yazın",
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ))),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.send_outlined,
                        size: 25,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_mesajController.text.trim().length > 0) {
                          Mesaj _kaydedilecekMesaj = Mesaj(
                              kimden: _currentUser.userId,
                              kime: _sohbetEdilenUser.userId,
                              bendenMi: true,
                              mesaj: _mesajController.text);

                          var sonuc =
                              await _userModel.saveMessage(_kaydedilecekMesaj);
                          if (sonuc) {
                            _mesajController.clear();
                            _scrollController.animateTo(
                              0.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeOut,
                            );
                          }
                        }
                        ;
                      },
                    ),
                  )
                ],
              ),
            ),
          ]),
        ));
  }

  Widget _konusmaBalonuOlustur(Mesaj oankiMesaj) {
    Color _gelenMesajRenk = Colors.blue;
    Color _gidenMesajRenk = Theme.of(context).primaryColor;

    var _saatDakikaDegeri = "";

    try {
      _saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.date ?? Timestamp(1, 1));
    } catch (e) {
      print("hata mesajı: ${e.toString()}");
    }

    var _benimMesajimMi = oankiMesaj.bendenMi;

    if (_benimMesajimMi) {
      return Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gidenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri)
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.sohbetEdilenUser.profilUrl),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      oankiMesaj.mesaj,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_saatDakikaDegeri)
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date.toDate());
    return _formatlanmisTarih;
  }
}
