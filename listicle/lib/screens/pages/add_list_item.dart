import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/models/Lists.dart';
import 'package:listicle/models/ListItem.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:listicle/screens/pages/selected_list_page.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/services/db_service.dart';

class AddListItem extends StatefulWidget {
  const AddListItem({ Key? key }) : super(key: key);

  @override
  _AddListItemState createState() => _AddListItemState();
}

class _AddListItemState extends State<AddListItem> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _progress = TextEditingController();
  final TextEditingController _link = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  String? selectedStatus, recommendValue;
  String _status = '', recommendString = '';

  double _rating = 0;

  bool _recommend = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('New List Item'),
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
                        
                        if(recommendString == 'Yes'){
                          _recommend = true;
                        }

                        ListItem newItem = ListItem(_title.text, user.lists[globals.selectedIndex].title, 
                                                    _status, int.parse(_progress.text), _rating,
                                                    _recommend, _link.text, _notes.text);
                        user.lists[globals.selectedIndex].items.add(newItem);
                        user.lists[globals.selectedIndex].updateListLen();

                      
                        CustomUser temp = CustomUser(uid: currentUser.uid, lists: user.lists);
                        dbService.addUser(user: temp);
                      });
                    });
                  }
                  
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${_title.text} added!")));
                });
                
                Navigator.pop(context);
                //Navigator.pop(context);
                //Navigator.pop(context);
                Navigator.popAndPushNamed(context, '/selected_list');
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
              // title
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: TextFormField(
                  //maxLength: 20,
                  controller: _title,
                  decoration:  const InputDecoration(labelText: "Title"),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),

              // status
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: "Status"),
                  value: selectedStatus,
                  onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
                  items: const [
                    DropdownMenuItem(child: Text("Ongoing"),value: "Ongoing"),
                    DropdownMenuItem(child: Text("Not Started"),value: "Not Started"),
                    DropdownMenuItem(child: Text("BackBurner"),value: "BackBurner"),
                    DropdownMenuItem(child: Text("Completed"),value: "Completed"),
                    DropdownMenuItem(child: Text("Dropped"),value: "Dropped"),
                  ],

                  validator: (String? value) {
                    if(value == null || value.isEmpty){
                      return 'Please select a status';
                    }

                    _status = selectedStatus!;
                    return null;
                  }
                  
                )
                
              ),

              // progress
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _progress,
                  decoration:  const InputDecoration(labelText: "Progress (Optional)"),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      _progress.text = '0';
                    }
                  },
                ),
              ),

              // rating
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: FormField(
                  builder: (FormFieldState<String> state){
                    return InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Rating (Optional)\n\n\n\n\n",
                        hintText: "Select a Rating",
                        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                      ),
                    
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: HorizontalPicker(
                        minValue: 0.0,
                        maxValue: 5.0,
                        divisions: 50,
                        height: 75,
                        
                        initialPosition: InitialPosition.start,
                        backgroundColor: Colors.transparent,
                        activeItemTextColor: Colors.black,
                        passiveItemsTextColor: Colors.grey,
                        showCursor: false,
                        cursorColor: Colors.indigo,
                        onChanged: (value) {_rating = value;}
                      ),
                    ),
                      
                    );
                  }
                ),
              ),

              // recommend
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: "Recommend (Optional)"),
                  value: recommendValue,
                  onChanged: (String? newValue) {
                  setState(() {
                    recommendValue = newValue!;
                  });
                },
                  items: const [
                    DropdownMenuItem(child: Text("Yes"),value: "Yes"),
                    DropdownMenuItem(child: Text("No"),value: "No"),
                  ],

                  validator: (String? value) {
                    if(value != null){
                      recommendString = recommendValue!;
                    }
                  }
                  
                )
              ),

              // link
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: TextFormField(
                  controller: _link,
                  decoration:  const InputDecoration(labelText: "Link (Optional)"),
                  validator: (value){
                    // add something to check if it is a valid link
                    if(value == null || value.isEmpty){
                      _link.text = '';
                    }
                  },
                ),
              ),

              // notes
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: TextFormField(
                  maxLines: 5,
                  controller: _notes,
                  decoration:  const InputDecoration(labelText: "Notes (Optional)"),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      _notes.text = 'No Notes Yet';
                    }
                  },
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}