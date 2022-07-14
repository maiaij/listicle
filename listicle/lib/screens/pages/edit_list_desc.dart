import 'package:flutter/material.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/screens/services/db_service.dart';

class EditListDesc extends StatefulWidget {
  const EditListDesc({ Key? key }) : super(key: key);

  @override
  _EditListDescState createState() => _EditListDescState();
}

class _EditListDescState extends State<EditListDesc> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _description = TextEditingController();
  DBService dbService = DBService();
  
  @override
  Widget build(BuildContext context) {
    _description.text = "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit List Description'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  //globals.testLists[globals.selectedIndex].description = _description.text;
                  print(_description.text);
                  print(globals.itemRef);
                  print(globals.listRef);
                  dbService.updateListDescription(_description.text, globals.listRef, globals.itemRef);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Description updated!")));
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
                  controller: _description,
                  maxLength: 150,
                  maxLines: 3,
                  decoration:  const InputDecoration(labelText: "Update Description"),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter a description';
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