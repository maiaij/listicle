// ignore_for_file: file_names, camel_case_types

/**import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/services/db_service.dart';

// MAKE NOT STATEFUL
// the update can happen in add list page, no set state needed because the homepage reloads
// this object

class List_View extends StatefulWidget {
  const List_View({ Key? key }) : super(key: key);

  @override
  _List_ViewState createState() => _List_ViewState();
}

class _List_ViewState extends State<List_View> {
  final DBService dbService = DBService();
  
  CustomUser user = CustomUser(uid: '', lists: []);
  var currentUser = FirebaseAuth.instance.currentUser;
  bool loading = false;

  void setUser() async {
    if (currentUser != null) {
      setState(() => loading = true);
        dynamic result = await dbService.getUserData(uid: currentUser!.uid).then((value) {
        setState(() {
          user = CustomUser.fromJson(value);
          //loading = false
        });
        
      });
    }
  }

  Future getCurrentUser() async{
    if (currentUser != null) {
      setState(() => loading = true);
      await dbService.getUserData(uid: currentUser!.uid).then((value) {
        if(mounted){
          setState(() {
            user = CustomUser.fromJson(value);
            loading = false;
          });
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {

    getCurrentUser();

    return StreamBuilder(
      stream: dbService.getUserListsSnapshot(uid: currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(user.lists.isEmpty) return const Text("\n   Add a New List");
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: (snapshot.data.docs[0])['lists'].length,
          itemBuilder: (BuildContext context, int index){
            final docData = (snapshot.data.docs[0])['lists'];
            return Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: ListTile(
                title: Text(
                  docData[index]['title'],
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),

                subtitle: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "${docData[index]['listLen']} Items\n",
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),

                      TextSpan(
                        text: (globals.sortType == 0)? 
                              ("Updated: ${DateFormat.yMMMd().format(DateTime.parse(docData[index]['dateModified']))}"):
                              ("Created: ${DateFormat.yMMMd().format(DateTime.parse(docData[index]['dateCreated']))}"),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]
                  )
                ),

                onTap: () async{
                  globals.selectedIndex = index;
                  await Navigator.pushNamed(context, '/selected_list');
                  
                  setState(() {
                    if(globals.selectedIndex == user.lists.length){
                      globals.selectedIndex --;
                    }
                  });
                  
                },
              ),
            );
          }
        );
      }
    );
  }
}

return StreamBuilder(
      stream: dbService.getUserListsSnapshot(uid: currentUser!.uid),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(user.lists.isEmpty) return const Text("\n   Add a New List");
        return GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          children: makeItemContainers(context, (snapshot.data.docs[0])['lists']),
        );
      }
    );

*/