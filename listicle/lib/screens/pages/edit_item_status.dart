import 'package:flutter/material.dart';
import 'package:listicle/globals.dart' as globals;
import 'package:listicle/screens/services/db_service.dart';

class EditItemStatus extends StatefulWidget {
  const EditItemStatus({ Key? key }) : super(key: key);

  @override
  State<EditItemStatus> createState() => _EditItemStatusState();
}

class _EditItemStatusState extends State<EditItemStatus> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedStatus;
  String _status = '';
  DBService dbService = DBService();

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
                  dbService.updateStatus(_status, globals.listRef, globals.itemRef);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Status Updated!")));
                });
                
                Navigator.pop(context);
                Navigator.pop(context);
                //Navigator.pop(context);
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
              
            ],
          ),
        ),
      ),

    );
  }
}