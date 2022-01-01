// ignore_for_file: file_names

class ListItem{
  String title, listName, status, link, notes;
  int progress;
  double rating;
  bool recommend;
  DateTime dateModified = DateTime.now();

  ListItem(this.title, this.listName, this.status, this.progress, this.rating, 
            this.recommend, this.link, this.notes);

  void updateDate(){
    dateModified = DateTime.now();
  }

}