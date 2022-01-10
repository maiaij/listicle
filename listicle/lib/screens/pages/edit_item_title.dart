import 'package:flutter/material.dart';
import 'package:listicle/globals.dart' as globals;

class EditItemTitle extends StatefulWidget {
  const EditItemTitle({ Key? key }) : super(key: key);

  @override
  _EditItemTitleState createState() => _EditItemTitleState();
}

class _EditItemTitleState extends State<EditItemTitle> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _title.text = globals.activeTabItems[globals.itemIndex].title;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item Title'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  globals.activeTabItems[globals.itemIndex].title = _title.text;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Title updated!")));
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
              // title
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: TextFormField(
                  //20
                  //maxLength: 100,
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