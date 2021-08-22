import 'package:flutter/material.dart';
import 'package:flutter_flutter_lovers/app/konusmalarim_page.dart';
import 'package:flutter_flutter_lovers/app/kullanicilar.dart';
import 'package:flutter_flutter_lovers/app/my_custom_bottom_navi.dart';
import 'package:flutter_flutter_lovers/app/profil.dart';
import 'package:flutter_flutter_lovers/model/user.dart';
import 'package:flutter_flutter_lovers/app/tab_items.dart';
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

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>()
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: KullanicilarPage(),
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Profil: ProfilPage()
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTap].currentState.maybePop(),
      child: MyCustomBottomNavigation(
        currentTab: _currentTap,
        onSelectedTab: (secilenTab) {
          // ilk rotaya geri dönme
          if (secilenTab == _currentTap) {
            navigatorKeys[secilenTab]
                .currentState
                .popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTap = secilenTab;
            });
          }
        },
        sayfaOlusturucu: tumSayfalar(),
        navigatorKeys: navigatorKeys,
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
