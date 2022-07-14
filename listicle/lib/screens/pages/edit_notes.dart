import 'package:flutter/material.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/screens/services/db_service.dart';

//might not need this

class EditNotes extends StatefulWidget {
  const EditNotes({ Key? key }) : super(key: key);
  
  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _notes = TextEditingController();
  DBService dbService = DBService();
  
  @override
  Widget build(BuildContext context) {
    // set to the sent value
    _notes.text = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  //globals.activeTabItems[globals.itemIndex].notes = _notes.text;
                  dbService.updateNotes(_notes.text, globals.listRef, globals.itemRef);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Notes updated!")));
                });

                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, '/selected_item');
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
                  //20
                  maxLines: 20,
                  controller: _notes,
                  decoration:  const InputDecoration(labelText: "Update Notes"),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter a title';
                    }
                    return null;
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