import 'package:flutter/material.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:listicle/globals.dart' as globals;
import 'dart:math' as math;

class SelectedItem extends StatefulWidget {
  const SelectedItem({ Key? key }) : super(key: key);

  @override
  _SelectedItemState createState() => _SelectedItemState();
}

class _SelectedItemState extends State<SelectedItem> {
  final Widget _drawerHeader = SizedBox(
    height: 60,
    child: DrawerHeader(
      child: const Text("Edit Options", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),
      decoration: BoxDecoration(
        color: Colors.indigo[400]
      ),
    )
  );

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

            ListTile(
              title: const Text('Edit Notes', style: TextStyle(fontSize: 12)),
              onTap: () {},
            ),

            ListTile(
              title: const Text('Edit Progress', style: TextStyle(fontSize: 12)),
              onTap: () {},
            ),

          ],
        ), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    String? selectedStatus = globals.activeTabItems[globals.itemIndex].status;
    TextEditingController _notesController = TextEditingController();
    _notesController.text = globals.activeTabItems[globals.itemIndex].notes;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: makeEndDrawer(), 

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), 
        leading: BackButton(
          color: Colors.black,
          onPressed: (){
            int changed = globals.testLists[globals.selectedIndex].items.indexOf(globals.activeTabItems[globals.itemIndex]);
            globals.testLists[globals.selectedIndex].items[changed] = globals.activeTabItems[globals.itemIndex];
            
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushNamed(context, '/selected_list');
          },
        ),
        actions: [
          (globals.activeTabItems[globals.itemIndex].recommend == true)?
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
                            backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 202, 97, 95)),
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

          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: (){_scaffoldKey.currentState!.openEndDrawer();},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              color: Colors.white,
              alignment: AlignmentDirectional.topStart,
              //height: 150,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),//const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: globals.activeTabItems[globals.itemIndex].title,
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                          text: "\n${globals.activeTabItems[globals.itemIndex].listName}\n",
                          style: const TextStyle(fontSize: 24)
                        ),

                        TextSpan(
                          text: "Progress: ${globals.activeTabItems[globals.itemIndex].progress}",
                          style: const TextStyle(fontSize: 14)
                        ),
                      ]
                    )
                  ),

                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 20),
                      Text(
                        " ${globals.activeTabItems[globals.itemIndex].rating}",
                        style: const TextStyle(fontSize: 14)
                      )
                    ],
                  ),
                
                ]
              )
            ), 

            // BUTTON ROW
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                // status dropdown
                Container(
                  //height: 40,
                  decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      value: selectedStatus,
                      items: const[
                        DropdownMenuItem(child: Text("Ongoing"),value: "Ongoing"),
                        DropdownMenuItem(child: Text("Not Started"),value: "Not Started"),
                        DropdownMenuItem(child: Text("BackBurner"),value: "BackBurner"),
                        DropdownMenuItem(child: Text("Completed"),value: "Completed"),
                        DropdownMenuItem(child: Text("Dropped"),value: "Dropped"),
                      ], 
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedStatus = newValue!;
                          globals.activeTabItems[globals.itemIndex].status = selectedStatus!;
                        });
                      }
                    ),
                  ),  
                ),
                
                // link button
                TextButton(
                  child: Container(
                    height: 47,
                    width: 200,
                    decoration: BoxDecoration(color: Colors.indigo[50],borderRadius: BorderRadius.circular(10),),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child:  Center(
                      child: Text(
                        (globals.activeTabItems[globals.itemIndex].link.isEmpty)?
                        ('No Link'):('CONTINUE'), 
                        style: const TextStyle(color: Colors.black, fontSize: 14)
                      )
                    ),
                  ),
                  onPressed: (){
                    // if link open link
                  }
                ),
              ],
            ),

            //const Padding(padding: EdgeInsets.only(left: 10)),

            // NOTE SECTION
            Container(
              color: Colors.white,
              alignment: AlignmentDirectional.topStart,
              //height: 150,
              padding: const EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),//const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notes:',
                    style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic),
                  ), 

                  // change to editable text
                  EditableText(
                    //keyboardType: TextInputType.visiblePassword,
                    //onEditingComplete: (){FocusScope.of(context).nextFocus();},
                    maxLines: 20,
                    controller: _notesController, 
                    focusNode: FocusNode(), 
                    style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black), 
                    cursorColor: Colors.indigo, 
                    backgroundCursorColor: const Color.fromARGB(255, 197, 202, 233),
                    onChanged: (value){
                      if(value.isEmpty){
                        globals.activeTabItems[globals.itemIndex].notes = 'No Notes Yet';
                      }
                      else{
                        globals.activeTabItems[globals.itemIndex].notes = _notesController.text;
                      }
                    },
                  ),
                  
                  /**Text(
                    globals.activeTabItems[globals.itemIndex].notes,
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ), */
                ],
              )
            )

                
          ],
        ),  
      ),
        
    );
  }
}