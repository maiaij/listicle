import 'package:flutter/material.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/globals.dart' as globals;
import 'dart:math' as math;

// all drawer navigation currently pops and pushes named
// add a delete confirmation dialogue

class SelectedList extends StatefulWidget {
  const SelectedList({ Key? key}) : super(key: key);

  @override
  _SelectedListState createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList> with SingleTickerProviderStateMixin{
  late TabController controller;
  List<List<ListItem>> tabs = [];
  bool edited = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 5,
      vsync: this
    );
  }

  @override
  Widget build(BuildContext context) {
    tabs = makeTabLists(globals.testLists[globals.selectedIndex].items);

    return Scaffold(
      endDrawer: SizedBox(
        width: 200,
        child: Drawer(
          elevation: 0,
          child: ListView(
            children: [
              _drawerHeader,
              ListTile(
                title: const Text('Add Item', style: TextStyle(fontSize: 12)),
                onTap: () async{
                  await Navigator.pushNamed(context, '/add_list_item');
                  //setState(() {
                  //   edited = !edited;
                  //});
                  //Navigator.pop(context);
                  //Navigator.pop(context);
                  //Navigator.pushNamed(context, '/selected_list');
                  
                  
                },
              ),

              const Divider(
                thickness: 2,
              ),

              ListTile(
                title: const Text('Edit List Title', style: TextStyle(fontSize: 12)),
                onTap: () async{
                  await Navigator.pushNamed(context, '/edit_list_title');
                },
              ),
              
              ListTile(
                title: const Text('Edit List Description', style: TextStyle(fontSize: 12)),
                onTap: () async{
                  await Navigator.pushNamed(context, '/edit_list_description');
                },
              ),

              ListTile(
                title: const Text('Delete List', style: TextStyle(fontSize: 12)),
                onTap: (){
                  globals.testLists.removeAt(globals.selectedIndex);
                  Navigator.pop(context);
                  Navigator.pop(context, false);
                },
              ),
            ]
          )
        )
      ),

      body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            leading: BackButton(),
            automaticallyImplyLeading: true,
            //pinned: true,
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            snap: true,
            floating: true,
            toolbarHeight: 50,
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


Widget _drawerHeader = SizedBox(
  height: 60,
  child: DrawerHeader(
    child: const Text("Edit Options", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),),
    decoration: BoxDecoration(
      color: Colors.indigo[400]
    ),
  )
);

Widget makeHeaderTop(){
  //int items = globals.testLists[globals.selectedIndex].listLen;
  //print(globals.testLists[globals.selectedIndex].listLen);
  //print("back bb $items");
  return Container(
    alignment: AlignmentDirectional.topStart,
    height: 150,
    padding: const EdgeInsets.all(20.0),
    child: Text.rich(
      TextSpan(
        
        children: <TextSpan>[
          TextSpan(
            text: globals.testLists[globals.selectedIndex].title,
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)
          ),

          TextSpan(
            text: '\n${globals.testLists[globals.selectedIndex].listLen} Items\n\n',
            style: const TextStyle(fontSize: 18)
          ),

          TextSpan(
            text: globals.testLists[globals.selectedIndex].description,
            style: const TextStyle(fontSize: 14)
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

//ADD DATE MODIFIED
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
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),

          //subtitle: Text(font 12), DATE MODIFIED

          onTap: (){
            globals.itemIndex = index;
            globals.activeTabItems = tabItems;
            //Navigator.pushNamed(context, '/selected_list');
          },
        ),
      );
    }, 
  );
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