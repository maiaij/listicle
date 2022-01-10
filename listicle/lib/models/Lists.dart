import 'ListItem.dart';

class Lists{
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

}