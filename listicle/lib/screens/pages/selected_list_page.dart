import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/globals.dart' as globals;
import 'dart:math' as math;

import 'package:listicle/screens/services/db_service.dart';

// all drawer navigation currently pops and pushes named
// add date modified and progress

class SelectedList extends StatefulWidget {
  const SelectedList({ Key? key}) : super(key: key);
  

  @override
  _SelectedListState createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList> with SingleTickerProviderStateMixin{
  final DBService dbService = DBService();
  List<String> itemRefs = [];
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 5,
      vsync: this
    );
  }

  Widget itemsListView(List<dynamic> tabItems){
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(), 
      itemCount: tabItems.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(
              tabItems[index]['title'],
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),

            subtitle: Text(
              (tabItems[index]['dateModified'] == null)?
              ("Updated: ${DateFormat.yMMMd().format(DateTime.parse(DateTime.now().toString()))}"):
              ("Updated: ${DateFormat.yMMMd().format(DateTime.parse(tabItems[index]['dateModified'].toDate().toString()))}"),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.horizontal_rule_rounded), 
                  iconSize: 20,
                  onPressed: (){
                    if(tabItems[index]['progress'] > 0){
                      setState(() {
                        // decrement progress
                        dbService.updateProgress(tabItems[index]['progress'] - 1, globals.listRef, tabItems[index].id);
                      });
                    }
                  }
                ),
                
                Text(
                  '${tabItems[index]['progress']}'
                ),

                IconButton(
                  icon: const Icon(Icons.add_rounded), 
                  onPressed: (){
                    setState(() {
                      // increment progress
                      dbService.updateProgress(tabItems[index]['progress'] + 1, globals.listRef, tabItems[index].id);
                    });
                  }
                ),

              ],
            ),

            /**
             * to add a border to the counter
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 228, 228, 228)),
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
              ),
              child:   
            ),
            */

            onTap: (){
              // use something in the below line to edit progress
              globals.itemRef = tabItems[index].id;
              print(globals.itemRef);
              Navigator.pushNamed(context, '/selected_item');
              globals.origin = 0;
              //globals.itemIndex = index;
              //globals.activeTabItems = tabItems;
              //Navigator.pushNamed(context, '/selected_item');
            },
          ),
        );
      }, 
    );
  }

  Widget makeItemView(BuildContext context, TabController controller){
    List<dynamic> stat1 = [], stat2 = [], stat3 = [], stat4 = [], stat5 = [];
    List<dynamic> tabs = [stat1, stat2, stat3, stat4, stat5];

    return StreamBuilder(
      stream: dbService.getItemListSnapshot(globals.listRef),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        //add loading gif?
      if(snapshot.data == null){
        return SliverFillRemaining(
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            child: const Text(" ")
          )
        );
      }   
      
      globals.itemTitles.clear();
      globals.itemRefs.clear();

      final docData = snapshot.data.docs;
      for(int i = 0; i < snapshot.data.docs.length; i++){
        globals.itemTitles.add(docData[i]['title']);
        globals.itemRefs[docData[i]['title']] = docData[i].id;
        if(docData[i]['status'] == "Ongoing"){
          tabs[0].add(docData[i]);
        }
        else if(docData[i]['status'] == "Not Started"){
          tabs[1].add(docData[i]);
        }
        else if(docData[i]['status'] == "BackBurner"){
          tabs[2].add(docData[i]);
        }
        else if(docData[i]['status'] == "Completed"){
          tabs[3].add(docData[i]);
        }
        else if(docData[i]['status'] == "Dropped"){
          tabs[4].add(docData[i]);
        }
      }

      return SliverFillRemaining(
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: TabBarView(
            controller: controller,
            children: [
              //${globals.testLists[globals.selectedIndex].title}
              (tabs[0].isNotEmpty)? (itemsListView(tabs[0])) : (const Center(child: Text("No ongoing items"))),
              (tabs[1].isNotEmpty)? (itemsListView(tabs[1])) : (const Center(child: Text("No unstarted items"))),
              (tabs[2].isNotEmpty)? (itemsListView(tabs[2])) : (const Center(child: Text("No backburner items"))),
              (tabs[3].isNotEmpty)? (itemsListView(tabs[3])) : (const Center(child: Text("No completed items"))),
              (tabs[4].isNotEmpty)? (itemsListView(tabs[4])) : (const Center(child: Text("No dropped items"))),
            ]
          ),
        ),
      );
    }
  );
  }

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
                title: const Text('Add Item', style: TextStyle(fontSize: 12)),
                onTap: () {
                  Navigator.pushNamed(context, '/add_list_item');
                },
              ),

              const Divider(
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),

              ListTile(
                title: const Text('Edit List Title', style: TextStyle(fontSize: 12)),
                onTap: () {
                  Navigator.pushNamed(context, '/edit_list_title');
                },
              ),
              
              ListTile(
                title: const Text('Edit List Description', style: TextStyle(fontSize: 12)),
                onTap: () {
                  Navigator.pushNamed(context, '/edit_list_description');
                },
              ),

              ListTile(
                title: const Text('Delete List', style: TextStyle(fontSize: 12)),
                onTap: (){
                  showDialog<void>(
                    barrierDismissible: true, // false if user must tap button!
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Are you sure you want to delete?'),
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
                                dbService.deleteList(globals.listRef);
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                                Navigator.pop(context);
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
            ]
          )
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: makeEndDrawer(),
      
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: const BackButton(),
            automaticallyImplyLeading: true,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            snap: true,
            floating: true,
            toolbarHeight: 50,
            actions: [
              IconButton(
                icon: const Icon(Icons.search_outlined),
                tooltip: 'Search',
                onPressed: (){
                  showSearch(context: context, delegate: ItemSearch());
                }, 
              ),
              
              // sort items
              /*PopupMenuButton(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Sort',
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(child: Text("Title (Ascending)"),value: "Title (Ascending)"),
                  const PopupMenuItem(child: Text("Title (Descending)"),value: "Title (Descending)"),
                  const PopupMenuItem(child: Text("Date Modified (Ascending)"),value: "Date Modified (Ascending)"),
                  const PopupMenuItem(child: Text("Date Modified (Descending)"),value: "Date Modified (Descending)"),
                ],

                onSelected: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                    //filter the page
                    switch(selectedFilter){
                      case 'Title (Ascending)':
                        globals.testLists[globals.selectedIndex].items.sort((a,b) => a.title.compareTo(b.title));
                        break;
                      
                      case 'Title (Descending)':
                        globals.testLists[globals.selectedIndex].items.sort((a,b) => a.title.compareTo(b.title));
                        globals.testLists[globals.selectedIndex].items = List.from(globals.testLists[globals.selectedIndex].items.reversed);
                        break;

                      case 'Date Modified (Ascending)':
                        globals.testLists[globals.selectedIndex].items.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        break;
                        
                      case 'Date Modified (Descending)':
                        globals.testLists[globals.selectedIndex].items.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        globals.testLists[globals.selectedIndex].items = List.from(globals.testLists[globals.selectedIndex].items.reversed);
                        break;

                    }
                  });
                },
              ),
              */
              IconButton(
                icon: const Icon(Icons.menu),
                tooltip: 'Edit Options',
                onPressed: (){_scaffoldKey.currentState!.openEndDrawer();},
              ),
            ],
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: CustomHeader(
              top: dbService.makeHeaderTop(globals.listRef),
              bottom: TabBar(
                controller: controller,
                isScrollable: true,
                labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                labelColor: Colors.black,
                tabs: const <Tab>[
                  Tab(text: 'ONGOING'),
                  Tab(text: 'NOT STARTED'),
                  Tab(text: 'BACKBURNER'),
                  Tab(text: 'COMPLETED'),
                  Tab(text: 'DROPPED'),
                ]
              )
            ),
          ),

          makeItemView(context, controller),
        ],
      ),
    );
  }
  
}

class CustomHeader extends SliverPersistentHeaderDelegate {
  final TabBar bottom;
  final Widget top;

  CustomHeader({required this.bottom, required this.top});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      height: math.max(minExtent, maxExtent - shrinkOffset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 150, child: top),
          bottom,
       ]
      )
    );
  }

 @override
  double get maxExtent => kToolbarHeight + 150;

  @override
  double get minExtent => kToolbarHeight + 150;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class ItemSearch extends SearchDelegate<String>{

  final titles = globals.itemTitles;
  final recentTitles = [];
  //List<String> recentTitles = ['book one'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // actions for app bar
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: (){
          query = '';
        }, 
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // leading icon on the left of app bar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, '');
      }, 
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show a result based on selection
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show when someone searches for something
    final suggestionList = query.isEmpty ? recentTitles : titles.where((t) => t.startsWith(RegExp(query, caseSensitive: false))).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: (){
          //suggestionList[index]
          globals.itemRef = globals.itemRefs[suggestionList[index]];
          print(globals.itemRef);
          Navigator.pushNamed(context, '/selected_item');
        },
        
        title: RichText(
          text: TextSpan(
            text: suggestionList[index].substring(0, query.characters.length), //query.length
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),

            children: [
              TextSpan(
                text: suggestionList[index].substring(query.characters.length), //query.length
                style: const TextStyle(color: Colors.grey),  
              )
            ],
          ),
        ),
      ),

      itemCount: suggestionList.length,
    );
  }
}
