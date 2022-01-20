import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/services/auth.dart';
import 'package:listicle/models/CustomUser.dart';

class RecommendedList extends StatefulWidget {
  const RecommendedList({ Key? key }) : super(key: key);

  @override
  _RecommendedListState createState() => _RecommendedListState();
}

class _RecommendedListState extends State<RecommendedList> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    String? selectedOption = 'Logout';
    Map<int, String> listIndexes = {};
    List<ListItem> recs = [];
  
    for(int i = 0; i < globals.testLists.length; i++){
      for(int j = 0; j < globals.testLists[i].items.length; j++){
        if(j == 0){
          listIndexes.addEntries([MapEntry(i, globals.testLists[i].items[j].listName)]);
        }

        if(globals.testLists[i].items[j].recommend == true){
          recs.add(globals.testLists[i].items[j]);
        }
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text("My Recommendations", style: TextStyle(color: Colors.black)),
        actions: [
          PopupMenuButton(
            tooltip: "More Options",
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black,),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(child: Text("Logout"),value: "Logout"),
            ],

            onSelected: (String? newValue) async {
              selectedOption = newValue!;
              
              switch(selectedOption){
                case 'Logout':
                  await _auth.signOut();
                  Navigator.popAndPushNamed(context, '/wrapper');
                  break;
              }
            },
          ),
        ]
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.indigo[200],
        unselectedItemColor: Colors.black,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: "LISTS",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "RECOMMENDED",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "NEW",
          ),
 
          /** 
          BottomNavigationBarItem(
            icon: Icon(Icons.keyboard_control_rounded),
            tooltip: "Settings",
            label: "SETTINGS",
          ),
          */
          
        ],

        onTap:(value) async {
          if(value == 0){
            await Navigator.popAndPushNamed(context, '/home');
          }

          if(value == 2){
            await Navigator.pushNamed(context, '/new_list');
          }
        },
      ),

      body: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: recs.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(), 
          itemBuilder: (BuildContext context, int index){
            return Container(
              padding: const EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  recs[index].title,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),

                subtitle: Text.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: "${recs[index].listName} \n",
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),

                      TextSpan(
                        text: "Updated: ${DateFormat.yMMMd().format(recs[index].dateModified)}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]
                  )
                ),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,

                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.horizontal_rule_rounded), 
                      iconSize: 20,
                      onPressed: (){
                        if(recs[index].progress > 0){
                          setState(() {
                            recs[index].progress --;
                            recs[index].updateDate();
                          });
                        }
                      }
                    ),
                    
                    Text(
                      '${recs[index].progress}'
                    ),

                    IconButton(
                      icon: const Icon(Icons.add_rounded), 
                      onPressed: (){
                        setState(() {
                          recs[index].progress ++;
                          recs[index].updateDate();
                        });
                      }
                    ),

                  ],
                ),

                onTap: () {
                  globals.origin = 1;
                  globals.selectedIndex = listIndexes.keys.toList()[listIndexes.values.toList().indexOf(recs[index].listName)];
                  
                  globals.activeTabItems = recs;
                  globals.itemIndex = index;
                  Navigator.pushNamed(context, '/selected_item');
                },
              ),
            );
          }, 
        ),
      ),

    );
  }
}