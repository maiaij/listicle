import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';

import 'package:listicle/globals.dart' as globals;

class List_Tile extends StatelessWidget {
  final Lists mainList;
  final int index;
  const List_Tile({ Key? key, required this.mainList, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: ListTile(
                title: Text(
                  mainList.title,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),

                subtitle: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "${mainList.listLen} Items\n",
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),

                      TextSpan(
                        text: (globals.sortType == 0)? 
                              ("Updated: ${DateFormat.yMMMd().format(mainList.dateModified)}"):
                              ("Created: ${DateFormat.yMMMd().format(mainList.dateCreated)}"),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]
                  )
                ),

                onTap: () async{
                  globals.selectedIndex = index;
                  await Navigator.pushNamed(context, '/selected_list');
                  
                  //setState(() {
                  //  if(globals.selectedIndex == user.lists.length){
                  //    globals.selectedIndex --;
                  //  }
                  //});
                  
                },
              ),
            );
  }
}