import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/app/ornek_page_1.dart';
import 'package:flutter_flutter_lovers/app/ornek_page_2.dart';

class KullanicilarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcılar"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => OrnekPage1()));
              },
              icon: Icon(Icons.adb))
        ],
      ),
      body: Center(
        child: Text("Kullanıcılar Sayfası"),
      ),
    );
  }
}
