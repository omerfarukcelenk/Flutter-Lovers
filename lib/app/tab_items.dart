import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Kullanicilar, Konusmalarim, Profil }

class TabItemData {
  final String label;
  final IconData icon;

  TabItemData(this.label, this.icon);

  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Kullanicilar:
        TabItemData("Kullanıcılar", Icons.supervised_user_circle),
    TabItem.Konusmalarim: TabItemData("Konusmalarım", Icons.chat),
    TabItem.Profil: TabItemData("Profil", Icons.person)
  };
}
