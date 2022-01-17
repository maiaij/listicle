library globals;
import 'package:listicle/models/ListItem.dart';
import 'package:listicle/models/Lists.dart';

// origin: the page an item was accessed from
// 0: homepage; 1: recommended page; 2: search result
int origin = 0;

int sortType = 0; // sort type 0: date updated; 1: date created

int selectedIndex = 0;
List<Lists> testLists = [];

int itemIndex = 0;
List<ListItem> activeTabItems = [];