// ignore_for_file: file_names, camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/screens/services/db_service.dart';

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
  
  @override
  Widget build(BuildContext context) {
    List<String> listRefs = [];
    return StreamBuilder(
      stream: dbService.getListsSnapshot(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        //add loading gif?
        if(snapshot.data == null) return const Text(" ");//return const Text("\n   Add a New List");
        return ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (BuildContext context, int index){
            final docData = snapshot.data.docs;
            listRefs.add(docData[index].id);
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
                              ("Updated: ${DateFormat.yMMMd().format(DateTime.parse(docData[index]['dateModified'].toDate().toString()))}"):
                              ("Created: ${DateFormat.yMMMd().format(DateTime.parse(docData[index]['dateCreated'].toDate().toString()))}"),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]
                  )
                ),

                onTap: () async{
                  setState(() {
                    globals.listRef = listRefs[index];
                    print(listRefs[index]);
                  });
                  
                  await Navigator.pushNamed(context, '/selected_list');
                  
                },
              ),
            );
          }
        );
      }
    );
  }
}