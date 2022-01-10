import 'package:flutter/material.dart';
import 'package:listicle/globals.dart' as globals;

class EditProgress extends StatefulWidget {
  const EditProgress({ Key? key }) : super(key: key);

  @override
  _EditProgressState createState() => _EditProgressState();
}

class _EditProgressState extends State<EditProgress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _progress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _progress.text = "${globals.activeTabItems[globals.itemIndex].progress}";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item Progress'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  globals.activeTabItems[globals.itemIndex].progress = int.parse(_progress.text);
                  globals.activeTabItems[globals.itemIndex].updateDate();
                  globals.testLists[globals.selectedIndex].updateDate();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Progress updated!")));
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
                  keyboardType: TextInputType.number,
                  controller: _progress,
                  decoration:  const InputDecoration(labelText: "Update Progress"),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter a number';
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