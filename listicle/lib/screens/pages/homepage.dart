import 'package:flutter/material.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/helpers/List_View.dart';
import 'package:listicle/helpers/Gallery_View.dart';
import 'package:listicle/models/CustomUser.dart';

// homepage

class Homepage extends StatefulWidget {
  const Homepage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Homepage> {
  List<ListItem> test1 = [];
  List<ListItem> test2 = [];
  List<ListItem> test3 = [];

  bool listView = true, edited = false;

  @override
  void initState(){
    super.initState();
    ListItem one = ListItem("book one", "novels", "Ongoing", 10, 5.0, false, "", "so far so good");
    ListItem two = ListItem("book two", "novels", "Not Started", 2, 0.0, false, "", "just started");
    ListItem three = ListItem("comic one", "comics", "Dropped", 53, 3.9, false, "", "so far so good");
    ListItem four = ListItem("comic two", "comics", "BackBurner", 27, 0.0, false, "", "very cute");
    ListItem five = ListItem("anime one", "anime", "Completed", 24, 4.0, false, "", "spoopy");

    test1.add(one);
    test1.add(two);
    test2.add(three);
    test2.add(four);
    test3.add(five);

    Lists listOne = Lists(test1, "novels", "novels i love");
    Lists listTwo = Lists(test2, "comics", "comics i love");
    Lists listThree = Lists(test3, "anime", "anime i love");

    globals.testLists.add(listOne);
    globals.testLists.add(listTwo);
    globals.testLists.add(listThree);
  }

  Widget editedListBody(){
    return const List_View();
  }

  Widget editedGalleryBody(){
    return const Gallery_View();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 1,
        backgroundColor: Colors.white,
        title: const Text("My Lists", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.view_list_rounded, color: (listView == true)? (Colors.indigo[200]):(Colors.black)),
            onPressed: (){
              setState(() {
                listView = true;
              });
            }, 
          ),

          IconButton(
              icon: Icon(Icons.grid_view_rounded, color: (listView == false)? (Colors.indigo[200]):(Colors.black)),
              onPressed: (){
                setState(() {
                  listView = false;
                });
              }, 
            ),
        ],
      ),
 
      body: Container(
        color: Colors.white,
        child: (listView == true && edited == true)? (editedListBody()) : (listView == false && edited == true)? (editedGalleryBody()) : (listView == true)? (const List_View()):(const Gallery_View()),
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigo[200],
        unselectedItemColor: Colors.black,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: "LISTS",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "NEW",
          ),
 
          /** 
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "FAVOURITES",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: "SETTINGS",
          ),
          */
          
        ],

        onTap:(value) async {
          if(value == 1){
            await Navigator.pushNamed(context, '/new_list');
            setState(() {
              edited = !edited;
            });
          }
        },
      ),
    );
  }
}

/**Widget List_View(List<Lists> lists){
  return ListView.separated(
    separatorBuilder: (BuildContext context, int index) => const Divider(), 
    itemCount: lists.length,
    itemBuilder: (BuildContext context, int index){
      return Container(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Text(
            lists[index].title,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),

          subtitle: Text(
            "${lists[index].listLen} Items",
            style: const TextStyle(fontSize: 12, color: Colors.black),
          ),

          onTap: () async{
            globals.selectedIndex = index;
            globals.testLists = lists;
            await Navigator.pushNamed(context, '/selected_list');
            globals.testLists[globals.selectedIndex].updateListLen();
            List_View(globals.testLists);
          },
        ),
      );
    }, 
  );
}

Widget Gallery_View(List<Lists> lists, BuildContext context){
  return GridView.count(
    crossAxisCount: 2,
    crossAxisSpacing: 15,
    mainAxisSpacing: 15,
    padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
    children: makeItemContainers(lists, context),
  );
}

List<Container> makeItemContainers(List<Lists> lists, BuildContext context){
  List<Container> result = [];

  for(int i = 0; i < lists.length; i++){
    result.add(
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 10,
              fit: FlexFit.tight,
              child: GestureDetector( 
                child: Container(
                  //width: 125,
                  //height: 150,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.indigo[100],
                    borderRadius: BorderRadius.circular(3),
                  )
                ),
                onTap: (){
                  globals.selectedIndex = i;
                  globals.testLists = lists;
                  Navigator.pushNamed(context, '/selected_list');
                },
              )
            ),

            Flexible(
              flex: 0,
              child: Text(
                lists[i].title,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),

            Flexible(
              flex: 0,
              child: Text(
                "${lists[i].listLen} Items",
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),

          ],
        )
      )
    );
  }

  return result;
}
*/