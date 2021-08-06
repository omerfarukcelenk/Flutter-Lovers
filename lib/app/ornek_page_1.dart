import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/app/ornek_page_2.dart';

class OrnekPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OrnekPage1"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => OrnekPage2()));
              },
              icon: Icon(Icons.adb))
        ],
      ),
      body: Center(
        child: Text("OrnekPage1 Sayfası"),
      ),
    );
  }
}
