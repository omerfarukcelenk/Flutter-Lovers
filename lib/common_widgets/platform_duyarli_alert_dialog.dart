import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_flutter_lovers/common_widgets/platform_duyarli_widget.dart';

class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget {
  final String label;
  final String icerik;
  final String anaButtonYazisi;
  final String iptalButtonYazisi;

  PlatformDuyarliAlertDialog(
      {@required this.label,
      @required this.icerik,
      @required this.anaButtonYazisi,
      this.iptalButtonYazisi});

  Future<bool> goster(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : await showDialog<bool>(
            context: context,
            builder: (context) => this,
            barrierDismissible: false);
  }

  // concrete
  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(label),
      content: Text(icerik),
      actions: _dialogButtonlariniAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(label),
      content: Text(icerik),
      actions: _dialogButtonlariniAyarla(context),
    );

  }

  List<Widget> _dialogButtonlariniAyarla(BuildContext context) {
    final tumButtonlar = <Widget>[];
    if (Platform.isIOS) {
      if (iptalButtonYazisi != null) {
        tumButtonlar.add(CupertinoDialogAction(
          child: Text(iptalButtonYazisi),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ));
      }

      tumButtonlar.add(CupertinoDialogAction(
        child: Text(anaButtonYazisi),
        onPressed: () {
          Navigator.of(context).pop(true);
        },
      ));
    } else {
      if (iptalButtonYazisi != null) {
        tumButtonlar.add(TextButton(
          child: Text(iptalButtonYazisi),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ));
      }

      tumButtonlar.add(TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(anaButtonYazisi)));
    }

    return tumButtonlar;
  }
}
