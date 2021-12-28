import 'package:flutter/material.dart';
import 'package:listicle/screens/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:listicle/screens/wrapper.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/splash.dart';
import 'package:listicle/screens/pages/homepage.dart';
import 'package:listicle/screens/pages/selected_list_page.dart';
import 'package:listicle/screens/pages/new_list_dialogue.dart';
import 'package:listicle/screens/pages/add_list_item.dart';
import 'package:listicle/screens/pages/edit_list_title.dart';
import 'package:listicle/screens/pages/edit_list_desc.dart';
import 'LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // Color? theme = Colors.indigo[800];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Listicle',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const Splash(),
        routes: {
          '/login_screen': (context) => LoginPage(),
          '/wrapper': (context) => Wrapper(),
          '/home': (context) => const Homepage(),
          '/selected_list': (context) => const SelectedList(),
        },
        //initialRoute: '/home',
        onGenerateRoute: (RouteSettings settings){
          switch (settings.name){
            case '/new_list': return MaterialPageRoute(
              builder: (context) => const AddNewList(),
              fullscreenDialog: true,
            );

            case '/add_list_item': return MaterialPageRoute(
              builder: (context) => const AddListItem(),
              fullscreenDialog: true,
            );

            case '/edit_list_title': return MaterialPageRoute(
              builder: (context) => const EditListTitle(),
              fullscreenDialog: true,
            );

            case '/edit_list_description': return MaterialPageRoute(
              builder: (context) => const EditListDesc(),
              fullscreenDialog: true,
            );

          }
        },
        
      ),
    );
  }
}