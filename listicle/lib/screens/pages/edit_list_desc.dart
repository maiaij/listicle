import 'package:flutter/material.dart';
import 'package:listicle/globals.dart' as globals;

class EditListDesc extends StatefulWidget {
  const EditListDesc({ Key? key }) : super(key: key);

  @override
  _EditListDescState createState() => _EditListDescState();
}

class _EditListDescState extends State<EditListDesc> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _description = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    _description.text = globals.testLists[globals.selectedIndex].description;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit List Title'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  globals.testLists[globals.selectedIndex].description = _description.text;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Description updated!")));
                });
                
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/selected_list');
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