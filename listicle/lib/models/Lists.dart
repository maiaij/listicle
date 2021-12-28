import 'ListItem.dart';

class Lists{
  List<ListItem> items = [];
  String title = "", description = "";
  int listLen = 0;

  Lists(List<ListItem> items, title, description){
    this.items = items;
    this.title = title;
    this.description = description;
    listLen = items.length;
  }

  void updateListLen(){
    listLen = items.length;
  }

}