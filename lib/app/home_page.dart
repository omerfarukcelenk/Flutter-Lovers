import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/app/kullanicilar.dart';
import 'package:flutter_flutter_lovers/app/my_custom_bottom_navi.dart';
import 'package:flutter_flutter_lovers/app/profil.dart';
import 'package:flutter_flutter_lovers/model/user_model.dart';
import 'package:flutter_flutter_lovers/tab_items.dart';
import 'package:flutter_flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTap = TabItem.Kullanicilar;

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: KullanicilarPage(),
      TabItem.Profil: ProfilPage()
    };
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        child: MyCustomBottomNavigation(
          currentTab: _currentTap,
          onSelectedTab: (secilenTab) {
            setState(() {
              _currentTap = secilenTab;
            });
          },
          sayfaOlusturucu: tumSayfalar(),
        ),
      );
  }
}

/*
Future<bool> _cikisYap(BuildContext context) async {
  final _userModel = Provider.of<UserModel>(context, listen: false);
  bool sonuc = await _userModel.singOut();
  return sonuc;
}
 */
