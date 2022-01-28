import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/services/db_service.dart';

class AddNewList extends StatefulWidget {
  const AddNewList({ Key? key }) : super(key: key);

  @override
  _AddNewListState createState() => _AddNewListState();
}

class _AddNewListState extends State<AddNewList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController(), _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  final DBService dbService = DBService();
                  CustomUser user = CustomUser(uid: '', lists: []);
                  var currentUser = FirebaseAuth.instance.currentUser;

                  if (currentUser != null) {
                    dbService.getUserData(uid: currentUser.uid).then((value) {
                      setState(() {
                        user = CustomUser.fromJson(value, currentUser.uid);
                        Lists newList = Lists([], _title.text, _description.text);
                        user.lists.add(newList);
                        CustomUser temp = CustomUser(uid: currentUser.uid, lists: user.lists);
                        dbService.addUser(user: temp);
                      });

                    });
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${_title.text} added!")));
                });
                Navigator.pop(context);
              }
            }
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: TextFormField(
                  controller: _title,
                  maxLength: 20,
                  decoration: const InputDecoration(labelText: "List Name"),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'This field cannot be empty';
                    }
                    return null;
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: "Description"),
                  maxLength: 150,
                  maxLines: 3,
                  controller: _description,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      _description.text = "Add Description...";
                    }
                  },
                ),
              ),
            ]
          )
        ),
      ), 
    );
  }
}