import 'package:flutter/material.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
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

  @override
  Widget build(BuildContext context) {
    String? selectedStatus = globals.testLists[globals.selectedIndex].items[globals.itemIndex].status;
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: SizedBox(
        width: 200,
        child: Drawer(
          elevation: 0,
          child: ListView(
            children: [
              _drawerHeader,
              ListTile(
                title: const Text('Edit Notes', style: TextStyle(fontSize: 12)),
                onTap: () {},
              ),

              const Divider(
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),

            ],
          ), 
        ),
      ),

      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), 
        leading: BackButton(
          color: Colors.black,
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushNamed(context, '/selected_list');
          },
        ),
      ),

      body: Column(
        children: [
          // HEADER
          SizedBox(
            height: 120,
            child: Container(
              color: Colors.white,
              alignment: AlignmentDirectional.topStart,
              height: 150,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),//const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: globals.testLists[globals.selectedIndex].items[globals.itemIndex].title,
                          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                          text: "\n${globals.testLists[globals.selectedIndex].items[globals.itemIndex].listName}\n",
                          style: const TextStyle(fontSize: 24)
                        ),

                        TextSpan(
                          text: "Progress: ${globals.testLists[globals.selectedIndex].items[globals.itemIndex].progress}",
                          style: const TextStyle(fontSize: 14)
                        ),
                      ]
                    )
                  ),

                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 20),
                      Text(
                        " ${globals.testLists[globals.selectedIndex].items[globals.itemIndex].rating}",
                        style: const TextStyle(fontSize: 14)
                      )
                    ],
                  ),
                
                ]
              )
            ),        
          ),

          // BUTTON ROW
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              // stuats dropdown
              Container(
                decoration: BoxDecoration(color: Colors.indigo[50],borderRadius: BorderRadius.circular(10),),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
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
                        globals.testLists[globals.selectedIndex].items[globals.itemIndex].status = selectedStatus!;
                      });
                    }
                  ),
                ),  
              ),

              // rate button

              // link button
            ],
          ),

          // NOTE SECTION
                
        ],
      ),
    );
  }
}