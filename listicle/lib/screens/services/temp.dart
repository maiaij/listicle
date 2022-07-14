import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/screens/services/db_service.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

class SelectedItem extends StatefulWidget {
  const SelectedItem({ Key? key }) : super(key: key);

  @override
  _SelectedItemState createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem> {
  String? selectedDestination;
  String _destination = '';

  final Widget _drawerHeader = SizedBox(
    height: 60,
    child: DrawerHeader(
      child: const Text("Edit Options", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),
      decoration: BoxDecoration(
        color: Colors.indigo[400]
      ),
    )
  );

  List<DropdownMenuItem<String>>? makeSwapDropdown(){
    List<DropdownMenuItem<String>>? result = [];
    
    for(int i = 0; i < globals.testLists.length; i++){
      result.add(DropdownMenuItem(child: Text(globals.testLists[i].title),value: globals.testLists[i].title));
    }

    return result;
  }
/*
  Widget makeEndDrawer(){
    return SizedBox(
      width: 200,
      child: Drawer(
        elevation: 0,
        child: ListView(
          children: [
            _drawerHeader,
            ListTile(
              title: Text("Progress: ${globals.activeTabItems[globals.itemIndex].progress}", style: const TextStyle(fontSize: 12)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.horizontal_rule_rounded), 
                    iconSize: 20,
                    onPressed: (){
                      if(globals.activeTabItems[globals.itemIndex].progress > 0){
                        setState(() {
                          globals.activeTabItems[globals.itemIndex].progress --;
                          globals.activeTabItems[globals.itemIndex].updateDate();
                          globals.testLists[globals.selectedIndex].updateDate();
                        });
                      }
                    }
                  ),
                  
                  //Text('${globals.activeTabItems[globals.itemIndex].progress}'),

                  IconButton(
                    icon: const Icon(Icons.add_rounded), 
                    onPressed: (){
                      setState(() {
                        globals.activeTabItems[globals.itemIndex].progress ++;
                        globals.activeTabItems[globals.itemIndex].updateDate();
                        globals.testLists[globals.selectedIndex].updateDate();
                      });
                    }
                  ),

                ],
              ),
            ),

            const Divider(
              thickness: 2,
              indent: 15,
              endIndent: 15,
            ),

            ListTile(
              title: const Text('Edit Title', style: TextStyle(fontSize: 12)),
              onTap: () {
                Navigator.pushNamed(context, '/edit_item_title');
              },
            ),

            ///**
            ListTile(
              title: const Text('Edit Notes', style: TextStyle(fontSize: 12)),
              onTap: () {
                Navigator.pushNamed(context, '/edit_item_notes');
              },
            ),
            // */
            
            ListTile(
              title: const Text('Edit Progress', style: TextStyle(fontSize: 12)),
              onTap: () {
                Navigator.pushNamed(context, '/edit_item_progress');
              },
            ),

            // remove link
            ListTile(
              title: const Text('Remove Link', style: TextStyle(fontSize: 12)),
              onTap: () {
                showDialog<void>(
                    barrierDismissible: true, // false if user must tap button!
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Remove Link?'),
                        content: const Text('This action cannot be undone'),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                              ),
                              child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),

                            ElevatedButton(
                              child: const Text('Remove'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 202, 97, 95)),
                              ),
                              onPressed: () {
                                setState(() {
                                  globals.activeTabItems[globals.itemIndex].link = '';
                                  Navigator.pop(context);
                                });
                              },
                            ),
                            ],
                          ),
                            
                        ],
                      );
                    },
                  );
              }
            ),

            const Divider(
              thickness: 2,
              indent: 15,
              endIndent: 15,
            ),

            // move item
            ListTile(
              title: const Text('Move Item', style: TextStyle(fontSize: 12)),
              onTap: () {
                // provide a dropdown to select a new list
                // confirmation of move "Are You Sure?"
                // add item to new list
                // remove item from current list
                // redirect to new list
                showDialog<void>(
                  barrierDismissible: false, // false if user must tap button!
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Move "${globals.activeTabItems[globals.itemIndex].title}" to another list?'),
                      content:Container(
                        //height: 40,
                        //decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if(value == null){
                                return 'Please select a destination list';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(labelText: "List Options"),
                            value: selectedDestination,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedDestination = newValue!;
                                _destination = selectedDestination!;
                              });
                            },

                            items: makeSwapDropdown(),
                            
                          )
                        ),  
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                            ),
                            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),

                          ElevatedButton(
                            child: const Text('Move'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 148, 159, 226)),
                            ),
                            onPressed: () {
                              if(_destination.isNotEmpty){
                                setState(() {
                                  List<String> listTitles = [];
                                  for(int i = 0; i < globals.testLists.length;i++){
                                    listTitles.add(globals.testLists[i].title);
                                  }
                                  
                                  // add
                                  int destIndex = listTitles.indexOf(_destination);
                                  globals.activeTabItems[globals.itemIndex].listName = globals.testLists[destIndex].title;
                                  globals.testLists[destIndex].items.add(globals.activeTabItems[globals.itemIndex]);
                                  globals.testLists[destIndex].updateListLen();

                                  // remove
                                  int changed = globals.testLists[globals.selectedIndex].items.indexOf(globals.activeTabItems[globals.itemIndex]);
                                  globals.testLists[globals.selectedIndex].items.removeAt(changed);
                                  globals.testLists[globals.selectedIndex].updateListLen();

                                  Navigator.of(context).pop();
                                  Navigator.pop(context);
                                  Navigator.popAndPushNamed(context, '/selected_list');
                                });
                              }
                              
                            },
                          ),
                          ],
                        ),
                          
                      ],
                    );
                  },
                );
              },
            ),

            const Divider(
              thickness: 2,
              indent: 15,
              endIndent: 15,
            ),

            ListTile(
              title: const Text('Delete Item', style: TextStyle(fontSize: 12)),
              onTap: () {
                showDialog<void>(
                  barrierDismissible: true, // false if user must tap button!
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete ${globals.activeTabItems[globals.itemIndex].title}?'),
                      content: const Text('This action cannot be undone'),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                            ),
                            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),

                          ElevatedButton(
                            child: const Text('Delete'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 202, 97, 95)),
                            ),
                            onPressed: () {
                              setState(() {
                                int changed = globals.testLists[globals.selectedIndex].items.indexOf(globals.activeTabItems[globals.itemIndex]);
                                globals.testLists[globals.selectedIndex].items.removeAt(changed);
                                globals.testLists[globals.selectedIndex].updateListLen();
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.popAndPushNamed(context, '/selected_list');
                              });
                            },
                          ),
                          ],
                        ),
                          
                      ],
                    );
                  },
                );
              },
            ),


          ],
        ), 
      ),
    );
  }
*/

  void _launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch $url';
  }

  @override
  Widget build(BuildContext context) {
    final DBService dbService = DBService();
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    //String? selectedStatus = globals.activeTabItems[globals.itemIndex].status;
    TextEditingController _notesController = TextEditingController();
    _notesController.text = " ";

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      //endDrawer: makeEndDrawer(), 

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), 
        
        leading: BackButton(
          color: Colors.black,
          onPressed: (){
            
            if(globals.origin == 0){
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, '/selected_list');
            }

            if(globals.origin == 1){
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, '/recommended');
            }

            if(globals.origin == 2){
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.popAndPushNamed(context, '/selected_list');
            }
            
          },
        ),
        
        
        actions: [
          // recommend button
          ( globals.activeTabItems[globals.itemIndex].recommend == true)?
          (
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.indigo[100]),
              onPressed: (){
                setState(() {
                  globals.activeTabItems[globals.itemIndex].recommend = false;
                });
              },
            )
          ):
          (
            TextButton(
              child: Container(
                height: 25,
                //width: 60,
                decoration: BoxDecoration(color: Colors.indigo[50],borderRadius: BorderRadius.circular(10),),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: const Center(child: Text("Recommend", style: TextStyle(color: Colors.black, fontSize: 12))),
              ),

              onPressed: (){
                setState(() {
                  globals.activeTabItems[globals.itemIndex].recommend = true;
                });
              },

            )
          ),

          // rate button
          TextButton(
            child: Container(
              height: 25,
              width: 60,
              decoration: BoxDecoration(color: Colors.indigo[50],borderRadius: BorderRadius.circular(10),),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: const Center(child: Text("RATE", style: TextStyle(color: Colors.black, fontSize: 12))),
            ), 
            onPressed: (){
              showDialog<void>(
                barrierDismissible: true, // false if user must tap button!
                context: context,
                builder: (BuildContext context) {
                  double newRating = 5;
                  return AlertDialog(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.star_rounded, size: 20),
                        Text(
                          " RATE",
                          style: TextStyle(fontSize: 16)
                        )
                      ],
                    ),
                    content: HorizontalPicker(
                        minValue: 0.0,
                        maxValue: 5.0,
                        divisions: 50,
                        height: 75,
                        
                        initialPosition: InitialPosition.end,
                        backgroundColor: Colors.transparent,
                        activeItemTextColor: Colors.black,
                        passiveItemsTextColor: Colors.grey,
                        showCursor: false,
                        cursorColor: Colors.indigo,
                        onChanged: (value) {newRating = value;}
                      ),
                      
                    actions: <Widget>[
                      const Center(
                        child: Text(
                          'Swipe left or right\n', 
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                        
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
                          ),
                          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),

                        ElevatedButton(
                          child: const Text('Save'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 148, 159, 226)),
                          ),
                          onPressed: () {
                            setState(() {
                              globals.activeTabItems[globals.itemIndex].rating = newRating;
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ],
                      ),
                        
                    ],
                  );
                },
              );
            }, 
          ),

          /*IconButton(
            icon: const Icon(Icons.menu),
            onPressed: (){_scaffoldKey.currentState!.openEndDrawer();},
          ),*/
        ],
        
      ),

      //body: Text("testing")
      //body: dbService.displayItemInfo(context, globals.listRef, globals.itemRef),
        
    );
  }
}