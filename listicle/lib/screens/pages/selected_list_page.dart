import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/globals.dart' as globals;
import 'dart:math' as math;

// all drawer navigation currently pops and pushes named
// add date modified and progress

class SelectedList extends StatefulWidget {
  const SelectedList({ Key? key}) : super(key: key);

  @override
  _SelectedListState createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList> with SingleTickerProviderStateMixin{
  late TabController controller;
  List<List<ListItem>> tabs = [];

  @override
  void initState() {
    super.initState();
    globals.testLists[globals.selectedIndex].items.sort((a,b) => a.title.compareTo(b.title));
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
              text: globals.testLists[globals.selectedIndex].title,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
            ),

            TextSpan(
              text: '\n${globals.testLists[globals.selectedIndex].listLen} Items\n\n',
              style: const TextStyle(fontSize: 16)
            ),

            TextSpan(
              text: globals.testLists[globals.selectedIndex].description,
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
    String? selectedFilter = 'A to Z';
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    tabs = makeTabLists(globals.testLists[globals.selectedIndex].items);

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: makeEndDrawer(),

      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: const BackButton(),
            automaticallyImplyLeading: true,
            //pinned: true,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            snap: true,
            floating: true,
            toolbarHeight: 50,
            actions: [

              PopupMenuButton(
                icon: const Icon(Icons.filter_list),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(child: Text("A to Z"),value: "A to Z"),
                  const PopupMenuItem(child: Text("Z to A"),value: "Z to A"),
                  const PopupMenuItem(child: Text("Newest"),value: "Newest"),
                  const PopupMenuItem(child: Text("Oldest"),value: "Oldest"),
                ],

                onSelected: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                    //filter the page
                    switch(selectedFilter){
                      case 'A to Z':
                        globals.testLists[globals.selectedIndex].items.sort((a,b) => a.title.compareTo(b.title));
                        break;
                      
                      case 'Z to A':
                        globals.testLists[globals.selectedIndex].items.sort((a,b) => a.title.compareTo(b.title));
                        globals.testLists[globals.selectedIndex].items = List.from(globals.testLists[globals.selectedIndex].items.reversed);
                        break;

                      case 'Newest':
                        globals.testLists[globals.selectedIndex].items.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        globals.testLists[globals.selectedIndex].items = List.from(globals.testLists[globals.selectedIndex].items.reversed);
                        break;

                      case 'Oldest':
                        globals.testLists[globals.selectedIndex].items.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        break;

                    }
                  });
                },
              ),

              IconButton(
                icon: const Icon(Icons.menu),
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