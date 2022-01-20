import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listicle/models/CustomUser.dart';

class DBService{

  final String uid;
  DBService({required this.uid});

  // collection reference
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference listsCollection = FirebaseFirestore.instance.collection('customUser');

  void addUser({required CustomUser user}) {
    print('DATA SAVED: ' + user.toJson().toString());
    listsCollection
        .doc(user.uid)
        .set(user.toJson())
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<dynamic> getUserData({required String uid}) async {
    DocumentSnapshot snapshot = await listsCollection.doc(uid).get();
    return snapshot.data();
  }

  Stream<QuerySnapshot> getUserTripSnapshot({required String uid}) {
    //DocumentSnapshot snapshot = await userData.doc(uid).get();
    //return snapshot.data();
    return listsCollection.where('uid', isEqualTo: uid).snapshots();
  }
  
}