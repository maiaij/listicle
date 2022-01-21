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

  // Maps ListItem to Json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'listName': listName,
      'status': status,
      'progress': '$progress',
      'rating': '$rating',
      'recommend': (recommend) ? '1':'0',
      'link': link,
      'notes': notes,
      'dateModified': dateModified.toString(),
    };
  }

  // Maps Json to ListItem
  factory ListItem.fromJson(Map<String, dynamic> json) {
    ListItem item = ListItem(json['title'], json['listName'], json['status'], int.parse(json['progress']), double.parse(json['rating']), 
                    (json['recommend'] == '1')? true : false, json['link'], json['notes']);

    item.dateModified = DateTime.parse(json['dateModified']);
    return item;
  }

}