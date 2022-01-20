import 'package:flutter/cupertino.dart';

import 'ListItem.dart';

class Lists{
  Image? cover;
  DateTime dateCreated = DateTime.now();
  DateTime dateModified = DateTime.now();
  List<ListItem> items = [];
  String title = "", description = "";
  int listLen = 0;

  Lists(this.items, this.title, this.description){
    listLen = items.length;
  }

  void updateListLen(){
    listLen = items.length;
  }

  void updateDate(){
    dateModified = DateTime.now();
  }

  // Maps Lists Object to Json
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> convertedItems = [];
    for (var item in items) {
      convertedItems.add(item.toJson());
    }
    return {
      'items': convertedItems,
      'title': title,
      'description': description,
      'dateCreated': dateCreated.toString(),
      'dateModified': dateModified.toString(),
      'listLen': listLen,
    };
  }

  // Maps Json to Lists Object
  factory Lists.fromJson(Map<String, dynamic> json) {
    List<ListItem> itemList = json['items'].map<ListItem>((listItem) {
      return ListItem.fromJson(listItem);
    }).toList();

    Lists list = Lists(itemList, json['title'], json['description']);

    list.listLen = json['listLen'];
    list.dateCreated = DateTime.parse(json['dateCreated']);
    list.dateModified = DateTime.parse(json['dateModified']);

    return list;
  }

}