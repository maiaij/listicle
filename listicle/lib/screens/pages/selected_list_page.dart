import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/globals.dart' as globals;
import 'dart:math' as math;

import 'package:listicle/shared/loading.dart';
import 'package:listicle/services/auth.dart';
import 'package:listicle/services/db_service.dart';

// all drawer navigation currently pops and pushes named
// add date modified and progress

class SelectedList extends StatefulWidget {
  const SelectedList({ Key? key}) : super(key: key);

  @override
  _SelectedListState createState() => _SelectedListState();
}

final AuthService _auth = AuthService();
final DBService dbService = DBService();

class _SelectedListState extends State<SelectedList> with SingleTickerProviderStateMixin{
  

  CustomUser user = CustomUser(uid: '', lists: []);
  var currentUser = FirebaseAuth.instance.currentUser;
  
  late TabController controller;
  List<List<ListItem>> tabs = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      setState(() => loading = true);
      dynamic result = dbService.getUserData(uid: currentUser!.uid).then((value) {
        setState(() {
          user = CustomUser.fromJson(value, currentUser!.uid);
          user.lists[globals.selectedIndex].items.sort((a,b) => a.title.compareTo(b.title));
          tabs = makeTabLists(user.lists[globals.selectedIndex].items);
          loading = false;
        });
        
      });
    }
    
    controller = TabController(
      length: 5,
      vsync: this
    );
  }

  Widget itemsListView(List<ListItem> tabItems){
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(), 
      itemCount: tabItems.length,
      itemBuilder: (BuildContext context, int index){
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(
              tabItems[index].title,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),

            subtitle: Text(
              "Updated: ${DateFormat.yMMMd().format(tabItems[index].dateModified)}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.horizontal_rule_rounded), 
                  iconSize: 20,
                  onPressed: (){
                    if(tabItems[index].progress > 0){
                      setState(() {
                        tabItems[index].progress --;
                        tabItems[index].updateDate();
                        globals.testLists[globals.selectedIndex].updateDate();
                      });
                    }
                  }
                ),
                
                Text(
                  '${tabItems[index].progress}'
                ),

                IconButton(
                  icon: const Icon(Icons.add_rounded), 
                  onPressed: (){
                    setState(() {
                      tabItems[index].progress ++;
                      tabItems[index].updateDate();
                      globals.testLists[globals.selectedIndex].updateDate();
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
              globals.origin = 0;
              globals.itemIndex = index;
              globals.activeTabItems = tabItems;
              Navigator.pushNamed(context, '/selected_item');
            },
          ),
        );
      }, 
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

  Widget makeHeaderTop(){
    return Container(
      alignment: AlignmentDirectional.topStart,
      height: 150,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),//const EdgeInsets.all(20.0),
      child: Text.rich(
        TextSpan(
          
          children: <TextSpan>[
            TextSpan(
              text: user.lists[globals.selectedIndex].title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
            ),

            TextSpan(
              text: '\n${user.lists[globals.selectedIndex].listLen} Items\n\n',
              style: const TextStyle(fontSize: 16)
            ),

            TextSpan(
              text: user.lists[globals.selectedIndex].description,
              style: const TextStyle(fontSize: 12)
            ),
          ]
        ),
      ),
    );
  }

  Widget makeCustomHeader(TabController controller){
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomHeader(
        top: makeHeaderTop(),
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
    );
  }

  List<List<ListItem>> makeTabLists(List<ListItem> items){
    List<ListItem> bitems1 = [], bitems2 = [], bitems3 = [], bitems4 = [], bitems5 = [];
    List<List<ListItem>> result = [bitems1, bitems2, bitems3, bitems4, bitems5];
    for(int i = 0; i < items.length; i++){
      if(items[i].status == "Ongoing"){
        result[0].add(items[i]);
      }
      else if(items[i].status == "Not Started"){
        result[1].add(items[i]);
      }
      else if(items[i].status == "BackBurner"){
        result[2].add(items[i]);
      }
      else if(items[i].status == "Completed"){
        result[3].add(items[i]);
      }
      else if(items[i].status == "Dropped"){
        result[4].add(items[i]);
      }
    }
    return result;
  }

  Widget makeItemView(BuildContext context, TabController controller, List<List<ListItem>> tabs){
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
            
            //itemsListView(tabs[1]), 
            //itemsListView(tabs[2]),
            //itemsListView(tabs[3]),
            //itemsListView(tabs[4]),
          ]
        ),
      ),
    );
  }

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
                        title: Text('Delete "${globals.testLists[globals.selectedIndex].title}"?'),
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
                                globals.testLists.removeAt(globals.selectedIndex);
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
    String? selectedFilter = 'Title (Ascending)';
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    //tabs = makeTabLists(user.lists[globals.selectedIndex].items);

    return loading ? Loading() : Scaffold(
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

              PopupMenuButton(
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
                        user.lists[globals.selectedIndex].items.sort((a,b) => a.title.compareTo(b.title));
                        break;
                      
                      case 'Title (Descending)':
                        user.lists[globals.selectedIndex].items.sort((a,b) => a.title.compareTo(b.title));
                        user.lists[globals.selectedIndex].items = List.from(globals.testLists[globals.selectedIndex].items.reversed);
                        break;

                      case 'Date Modified (Ascending)':
                        user.lists[globals.selectedIndex].items.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        break;
                        
                      case 'Date Modified (Descending)':
                        user.lists[globals.selectedIndex].items.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        user.lists[globals.selectedIndex].items = List.from(globals.testLists[globals.selectedIndex].items.reversed);
                        break;

                    }
                  });
                },
              ),

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
              top: makeHeaderTop(),
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

          makeItemView(context, controller, tabs),
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

  final titles = globals.testLists[globals.selectedIndex].items.map((e) => e.title).toList();
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
          globals.origin = 2;
            globals.itemIndex = index;
            globals.activeTabItems = globals.testLists[globals.selectedIndex].items;
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
