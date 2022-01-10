import 'package:flutter/material.dart';
import 'package:listicle/screens/pages/selected_list_page.dart';
import 'selected_list_page.dart';
import 'package:listicle/globals.dart' as globals;

class EditListTitle extends StatefulWidget {
  const EditListTitle({ Key? key }) : super(key: key);

  @override
  _EditListTitleState createState() => _EditListTitleState();
}

class _EditListTitleState extends State<EditListTitle> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController(); 
  
  @override
  Widget build(BuildContext context) {
    _title.text = globals.testLists[globals.selectedIndex].title;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit List Title'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  globals.testLists[globals.selectedIndex].title = _title.text;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title updated!")));
                });

                Navigator.pop(context);
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
                  //20
                  maxLength: 20,
                  controller: _title,
                  decoration:  const InputDecoration(labelText: "Update Title"),
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