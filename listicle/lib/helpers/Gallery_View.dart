// ignore_for_file: file_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/services/db_service.dart';
import 'package:provider/provider.dart';

class Gallery_View extends StatefulWidget {
  const Gallery_View({ Key? key }) : super(key: key);

  @override
  _Gallery_ViewState createState() => _Gallery_ViewState();
}

class _Gallery_ViewState extends State<Gallery_View> {
  final DBService dbService = DBService();
  
  CustomUser user = CustomUser(uid: '', lists: []);
  var currentUser = FirebaseAuth.instance.currentUser;
  bool loading = false;

  List<Container> makeItemContainers(BuildContext context, dynamic lists){
    List<Container> result = [];

    for(int i = 0; i < lists.length; i++){
      result.add(
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 10,
                fit: FlexFit.tight,
                child: GestureDetector( 
                  child: Container(
                    //width: 125,
                    //height: 150,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.indigo[100],
                      borderRadius: BorderRadius.circular(3),
                    )
                  ),
                  onTap: () async{
                    globals.selectedIndex = i;
                    await Navigator.pushNamed(context, '/selected_list');

                    //setState(() {
                    //  if(globals.selectedIndex == globals.testLists.length){
                    //    globals.selectedIndex --;
                    //  }
                    //});
                    
                  },
                )
              ),

              Flexible(
                flex: 0,
                child: Text(
                  lists[i].title,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),

              Flexible(
                flex: 0,
                child: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "${lists[i].listLen} Items\n",
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),

                      TextSpan(
                        text: (globals.sortType == 0)? 
                              ("Updated: ${DateFormat.yMMMd().format(lists[i].dateModified)}"):
                              ("Created: ${DateFormat.yMMMd().format(lists[i].dateCreated)}"),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]
                  )
                ),
              ),

            ],
          )
        )
      );
    }

    return result;

  }

  @override
  Widget build(BuildContext context) {
    final lists = Provider.of<List<Lists>>(context);

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      children: makeItemContainers(context, lists),
    );
  }
}

