import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/helpers/List_View.dart';
import 'package:listicle/helpers/Gallery_View.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/services/auth.dart';
import 'package:listicle/services/db_service.dart';
import 'package:listicle/shared/loading.dart';
import 'package:provider/provider.dart';

// homepage

class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  final AuthService _auth = AuthService();
  final DBService dbService = DBService();

  CustomUser user = CustomUser(uid: '', lists: []);
  var currentUser = FirebaseAuth.instance.currentUser;

  List<ListItem> test1 = [];
  List<ListItem> test2 = [];
  List<ListItem> test3 = [];

  bool listView = true, edited = false, loading = false;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      //setState(() => loading = true);
      dbService.getUserData(uid: currentUser!.uid).then((value) {
        setState(() {
          user = CustomUser.fromJson(value, currentUser!.uid);
          loading = false;
        });
        
      });
    }
    if(globals.testLists.isEmpty){
      ListItem one = ListItem("book one", "novels", "Ongoing", 10, 5.0, false, "", "so far so good");
      ListItem two = ListItem("book two", "novels", "Ongoing", 2, 0.0, false, "", "just started");
      ListItem three = ListItem("comic one", "comics", "Dropped", 53, 3.9, false, "", "so far so good");
      ListItem four = ListItem("comic two", "comics", "BackBurner", 27, 0.0, false, "", "very cute");
      ListItem five = ListItem("anime one", "anime", "Completed", 24, 4.0, false, "", "spoopy");

      one.dateModified = DateTime(2017,9,7);
      two.dateModified = DateTime(2019,12,17);

      test1.add(one);
      test1.add(two);
      test2.add(three);
      test2.add(four);
      test3.add(five);

      Lists listOne = Lists(test1, "novels", "novels i love");
      Lists listTwo = Lists(test2, "comics", "comics i love");
      Lists listThree = Lists(test3, "anime", "anime i love");

      listOne.dateCreated = one.dateModified = DateTime(2017,9,7);

      globals.testLists.add(listOne);
      globals.testLists.add(listTwo);
      globals.testLists.add(listThree);
    }
    
  }

  Widget editedListBody(){
    return const List_View();
  }

  Widget editedGalleryBody(){
    return const Gallery_View();
  }

  

  @override
  Widget build(BuildContext context) {
    String? selectedFilter = 'Title (Ascending)', selectedOption = 'Logout';
    globals.origin = 0;

    return StreamProvider<List<Lists>>.value(
      value: DBService().lists,
      initialData: const [],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const Text("My Lists", style: TextStyle(color: Colors.black)),
              PopupMenuButton(
                tooltip: "Sort Lists",
                icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.black,),
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(child: Text("Title (Ascending)"),value: "Title (Ascending)"),
                  const PopupMenuItem(child: Text("Title (Descending)"),value: "Title (Descending)"),
                  const PopupMenuItem(child: Text("Date Modified (Ascending)"),value: "Date Modified (Ascending)"),
                  const PopupMenuItem(child: Text("Date Modified (Descending)"),value: "Date Modified (Descending)"),
                  const PopupMenuItem(child: Text("Date Created (Ascending)"),value: "Date Created (Ascending)"),
                  const PopupMenuItem(child: Text("Date Created (Descending)"),value: "Date Created (Descending)"),
                ],
    
                onSelected: (String? newValue) {
                  setState(() {
                    selectedFilter = newValue!;
                    //filter the page
                    switch(selectedFilter){
                      case 'Title (Ascending)':
                        globals.sortType = 0;
                        user.lists.sort((a,b) => a.title.compareTo(b.title));
                        //globals.testLists.sort((a,b) => a.title.compareTo(b.title));
                        edited = !edited; 
                        break;
                      
                      case 'Title (Descending)':
                        globals.sortType = 0;
                        user.lists.sort((a,b) => a.title.compareTo(b.title));
                        user.lists = List.from(user.lists.reversed);
                        //globals.testLists.sort((a,b) => a.title.compareTo(b.title));
                        //globals.testLists = List.from(globals.testLists.reversed);
                        edited = !edited;
                        break;
    
                      case 'Date Modified (Ascending)':
                        globals.sortType = 0;
                        user.lists.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        //globals.testLists.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        edited = !edited;
                        break;
                        
                      case 'Date Modified (Descending)':
                        globals.sortType = 0;
                        user.lists.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        user.lists = List.from(user.lists.reversed);
                        //globals.testLists.sort((a,b) => a.dateModified.compareTo(b.dateModified));
                        //globals.testLists = List.from(globals.testLists.reversed);
                        edited = !edited;
                        break;
    
                      case 'Date Created (Ascending)':
                        globals.sortType = 1;
                        user.lists.sort((a,b) => a.dateCreated.compareTo(b.dateCreated));
                        //globals.testLists.sort((a,b) => a.dateCreated.compareTo(b.dateCreated));
                        edited = !edited;
                        break;
                        
                      case 'Date Created (Descending)':
                        globals.sortType = 1;
                        user.lists.sort((a,b) => a.dateCreated.compareTo(b.dateCreated));
                        user.lists = List.from(user.lists.reversed);
                        //globals.testLists.sort((a,b) => a.dateCreated.compareTo(b.dateCreated));
                        //globals.testLists = List.from(globals.testLists.reversed);
                        edited = !edited;
                        break;
    
                    }
                  });
                },
              ),
            ],
          ), 
          
          actions: [
            IconButton(
              icon: Icon(Icons.view_list_rounded, color: (listView == true)? (Colors.indigo[200]):(Colors.black)),
              tooltip: "List View",
              onPressed: (){
                setState(() {
                  listView = true;
                });
              }, 
            ),
    
            IconButton(
              icon: Icon(Icons.grid_view_rounded, color: (listView == false)? (Colors.indigo[200]):(Colors.black)),
              tooltip: "Gallery View",
              onPressed: (){
                setState(() {
                  listView = false;
                });
              }, 
            ),
    
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
              
          ],
        ),
     
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 5),
          child: (listView == true && edited == true)? (editedListBody()) : (listView == false && edited == true)? (editedGalleryBody()) : (listView == true)? (const List_View()):(const Gallery_View()),
        ),
    
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.indigo[200],
          unselectedItemColor: Colors.black,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
    
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.circle),
              tooltip: "Lists",
              label: "LISTS",
            ),
    
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              tooltip: "Recommended Items",
              label: "RECOMMENDED",
            ),
    
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              tooltip: "Add New List",
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
            if(value == 1){
              await Navigator.popAndPushNamed(context, '/recommended');
            }
    
            if(value == 2){
              await Navigator.pushNamed(context, '/new_list');
              setState(() {
                edited = !edited;
              });
            }
          },
        ),
      ),
    );
  }
}
