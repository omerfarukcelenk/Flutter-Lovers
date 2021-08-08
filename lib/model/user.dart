import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User {
  final String userId;
  String email;
  String userName;
  String profilUrl;
  String createdAt;
  String updatedAt;
  int seviye;

  User({
    @required this.userId,
    @required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'userName': userName ??  email.substring(0, email.indexOf('@')) + randomSayiUret(),
      'profileURL': profilUrl ??
          'https://avatars.githubusercontent.com/u/71720425?s=400&u=81460497d3d3d27c22f1278c3a3e94c756bc6e32&v=4',
      'createdAT': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : userId = map["userId"],
        email = map["email"],
        userName = map["userName"],
        profilUrl = map["profileURL"],
        createdAt = (map["createdAT"] as Timestamp).toString(),
        updatedAt = (map["updatedAt"] as Timestamp).toString(),
        seviye = map["seviye"];

  @override
  String toString() {
    return 'User{userId: $userId, email: $email, userName: $userName, profilUrl: $profilUrl, createdAt: $createdAt, updatedAt: $updatedAt, seviye: $seviye}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}
