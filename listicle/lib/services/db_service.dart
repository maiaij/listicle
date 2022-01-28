import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listicle/dump.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/globals.dart' as globals;


class DBService{
  
  var currentUser = FirebaseAuth.instance.currentUser;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // collection reference
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference listsCollection = FirebaseFirestore.instance.collection('customUser');

  Stream<List<Lists>> get lists{
    return listsCollection.snapshots().map(_listsListFromSnapshot);
  }

  List<Lists> _listsListFromSnapshot(QuerySnapshot snapshot) {
    final docData = (snapshot.docs[0])['lists'];

    List<Lists> userData = docData.map<Lists>((list) {
      return Lists.fromJson(list);
    }).toList();

    return userData;
  }

  void addUser({required CustomUser user}) {
    listsCollection
        .doc(user.uid)
        .set(user.toJson())
        .catchError((error) => null);
        //.then((value) => print("User Added"))
        //.catchError((error) => print("Failed to add user: $error"));
  }

  Future<dynamic> getUserData({required String uid}) async {
    DocumentSnapshot snapshot = await listsCollection.doc(uid).get();
    return snapshot.data();
  }

  Stream<QuerySnapshot> getUserListsSnapshot({required String uid}) {
    return listsCollection.snapshots();
  } 
  
  Future updateLists(Lists newList) async {

    dynamic listUpdate = newList.toJson();

    return await listsCollection.doc(uid).update(
      {
        'lists': FieldValue.arrayUnion(listUpdate)
      }
    );
  }

}