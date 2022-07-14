import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:url_launcher/url_launcher.dart';

class DBService{
  

  // collection reference
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference _userLists(){
    var currentUser = FirebaseAuth.instance.currentUser;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference listsCollection = FirebaseFirestore.instance.collection('customUser').doc(uid).collection('lists');
    return listsCollection;
  }

  void addUserToDatabase(String uid){
    FirebaseFirestore.instance.collection('customUser').doc(uid).set({"totalLists": 0});
  }

  Stream<QuerySnapshot> getListsSnapshot(){
    final listsCollection = _userLists();
    return listsCollection.snapshots();
  }

  Stream<DocumentSnapshot<Object?>> getListData(String listRef) {
    final listsCollection = _userLists();
    return listsCollection.doc(listRef).snapshots();
  }

  Widget makeHeaderTop(String listRef){
    return StreamBuilder(
      stream: getListData(listRef),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        //add loading gif?
        if(snapshot.data == null) return const Text(" ");//return const Text("\n   Add a New List") ;
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: 1,
          itemBuilder: (BuildContext context, int index){
            final docData = snapshot.data;
            return Container(
              alignment: AlignmentDirectional.topStart,
              height: 150,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),//const EdgeInsets.all(20.0),
              child: Text.rich(
                TextSpan(
                  
                  children: <TextSpan>[
                    TextSpan(
                      text: docData['title'],
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                    ),

                    TextSpan(
                      text: '\n${docData['listLen']} Items\n\n',
                      style: const TextStyle(fontSize: 16)
                    ),

                    TextSpan(
                      text: docData['description'],
                      style: const TextStyle(fontSize: 12)
                    ),
                  ]
                ),
              ),
            );
          }
        );
      }
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getItemListSnapshot(String listRef){
    final listCollection = _userLists();
    final itemsCollection = listCollection.doc(listRef).collection('listItems');
    return itemsCollection.snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> itemSnapshot(String listRef, String itemRef){
    final listCollection = _userLists();
    final selectedItem = listCollection.doc(listRef).collection('listItems').doc(itemRef);
    return selectedItem.snapshots();
  }

  void resetTot(){
    print("reset");
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('customUser').doc(uid);
    userRef.update({"totalLists": 2});
  }

  void deleteList(String docID){
    final listCollection = _userLists();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('customUser').doc(uid);

    //userRef.get();

    // delete subcollection
    listCollection.doc(docID).delete();
    userRef.update({"totalLists": FieldValue.increment(-1)});

  }

  void _launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch $url';
  }

  //adding functions
  //db.collection("cities").doc("new-city-id").set({"name": "Chicago"});
  void addNewList(String title, String description){
    final listCollection = _userLists();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('customUser').doc(uid);
    
    
    userRef.get().then((total) => {
      listCollection.doc("list${total["totalLists"] + 1}").set({
        "title": title,
        "description": description,
        "listLen": 0,
        "dateModified": FieldValue.serverTimestamp(),
        "dateCreated": FieldValue.serverTimestamp(),
      }).then((value) => {userRef.update({"totalLists": FieldValue.increment(1)})})
    });
  }

  void addNewListItem(String listRef, String itemRef, String title, String status, int progress, double rating, bool recommend, String link, String notes){
    final listCollection = _userLists();
    //final listLen = listCollection.doc(listRef).update({"listLen": FieldValue.increment(1)});
    final itemsCollection = listCollection.doc(listRef).collection('listItems');

    listCollection.doc(listRef).get().then((list) => {
      itemsCollection.doc("item${list["listLen"] + 1}").set({
        "dateModified": FieldValue.serverTimestamp(),
        "link": link,
        "listName": list["title"],
        "notes": notes,
        "progress": progress,
        "rating": rating,
        "recommend": recommend,
        "status": status,
        "title": title,
      }).then((value) => {listCollection.doc(listRef).update({"listLen": FieldValue.increment(1)})})
    });
  }

  void updateListTitle(String updatedTitle, String listRef, String itemRef){
    _userLists().doc(listRef).update({"title": updatedTitle});
  }

  void updateListDescription(String updatedDescription, String listRef, String itemRef){
    _userLists().doc(listRef).update({"description": updatedDescription});
  }

  // item updates
  void updateRecStatus(bool rec, String listRef, String itemRef){
    _userLists().doc(listRef).collection('listItems').doc(itemRef).update({"recommend": rec});
  }

  void updateRating(double rating, String listRef, String itemRef){
    _userLists().doc(listRef).collection('listItems').doc(itemRef).update({"rating": rating});
  }

  void updateItemTitle(String title, String listRef, String itemRef){
    _userLists().doc(listRef).collection('listItems').doc(itemRef).update({"title": title});
  }

  void updateNotes(String notes, String listRef, String itemRef){
    _userLists().doc(listRef).collection('listItems').doc(itemRef).update({"notes": notes});
  }

  void updateProgress(int progress, String listRef, String itemRef){
    _userLists().doc(listRef).collection('listItems').doc(itemRef).update({"progress": progress});
  }

  void updateLink(String link, String listRef, String itemRef){
    _userLists().doc(listRef).collection('listItems').doc(itemRef).update({"link": link});
  }

  void updateStatus(String status, String listRef, String itemRef){
    _userLists().doc(listRef).collection('listItems').doc(itemRef).update({"status": status});
  }

  void deleteListItem(String listRef, String itemRef){
    final listCollection = _userLists();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final userRef = FirebaseFirestore.instance.collection('customUser').doc(uid);

    //userRef.get();

    // delete subcollection
    listCollection.doc(listRef).collection('listItems').doc(itemRef).delete();
    listCollection.doc(listRef).update({"listLen": FieldValue.increment(-1)});

  }

}