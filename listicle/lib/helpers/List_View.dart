// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(
            globals.testLists[index].title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),

          subtitle: Text(
            "${globals.testLists[index].listLen} Items",
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),

          onTap: () async{
            globals.selectedIndex = index;
            final result = await Navigator.pushNamed(context, '/selected_list');
            
            if(result == true){
              setState(() {
                globals.testLists[globals.selectedIndex].updateListLen();
              });
            }

            else{
              setState(() {});
            }
            
          },
        ),
      );
    }, 
  );
  }
}