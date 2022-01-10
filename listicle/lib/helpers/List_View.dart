// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/globals.dart' as globals;

// MAKE NOT STATEFUL
// the update can happen in add list page, no set state needed because the homepage reloads
// this object

class List_View extends StatefulWidget {
  const List_View({ Key? key }) : super(key: key);

  @override
  _List_ViewState createState() => _List_ViewState();
}

class _List_ViewState extends State<List_View> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
    separatorBuilder: (BuildContext context, int index) => const Divider(), 
    itemCount: globals.testLists.length,
    itemBuilder: (BuildContext context, int index){
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
        child: ListTile(
          /**leading: Container(
            width: 60,
            height: 60,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.indigo[100],
              borderRadius: BorderRadius.circular(3),
            )
          ),
          */
          title: Text(
            globals.testLists[index].title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),

          subtitle: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "${globals.testLists[index].listLen} Items\n",
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),

                TextSpan(
                  text: (globals.sortType == 0)? 
                        ("Updated: ${DateFormat.yMMMd().format(globals.testLists[index].dateModified)}"):
                        ("Created: ${DateFormat.yMMMd().format(globals.testLists[index].dateCreated)}"),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ]
            )
          ),
          

          onTap: () async{
            globals.selectedIndex = index;
            await Navigator.pushNamed(context, '/selected_list');
            
            setState(() {
              if(globals.selectedIndex == globals.testLists.length){
                globals.selectedIndex --;
              }
            });
            
          },
        ),
      );
    }, 
  );
  }
}