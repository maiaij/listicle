import 'package:flutter/material.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/screens/services/db_service.dart';

class AddItemLink extends StatefulWidget {
  const AddItemLink({ Key? key }) : super(key: key);

  @override
  _AddItemLinkState createState() => _AddItemLinkState();
}

class _AddItemLinkState extends State<AddItemLink> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _link = TextEditingController();
  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Link to Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  //globals.activeTabItems[globals.itemIndex].link = _link.text;
                  dbService.updateLink(_link.text, globals.listRef, globals.itemRef);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Link Added!")));
                });

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
                  controller: _link,
                  keyboardType: TextInputType.url,
                  decoration:  const InputDecoration(labelText: "Add Link"),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter a link';
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