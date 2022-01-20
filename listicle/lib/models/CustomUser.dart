// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:listicle/models/Lists.dart';

class CustomUser{

  final String uid;
  List<Lists> lists;

  CustomUser({required this.uid, required this.lists});

  // Maps Json to Lists list
  factory CustomUser.fromJson(Map<String, dynamic> json) {
    List<Lists> userData = json['lists'].map<Lists>((list) {
      return Lists.fromJson(list);
    }).toList();
    return CustomUser(uid: json['uid'], lists: userData);
  }

  // Maps Activity to Json
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> convertedLists = [];
    for (var list in lists) {
      //Lists thisList = list as Lists;
      convertedLists.add(list.toJson());
    }
    return {'uid': uid, 'lists': convertedLists};
  }

}