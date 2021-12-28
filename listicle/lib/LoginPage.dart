import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ref lab 7, exercise 6

class LoginPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: FormWidget());
  }
}

class FormWidget extends StatefulWidget{
  const FormWidget({Key? key}) : super(key: key);


  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email = '';
  String? _password = '';
  
  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(40.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // app logo
            const Image(
              image: AssetImage('assets/listicle_logo.png'),
              width : 150,
              height: 150
            ),

            TextFormField(
              // write the validator and onSaved
              decoration: const InputDecoration(labelText: "email"),
              validator: (value){},
              onSaved: (value){}
            ),

            TextFormField(
              // write the validator and onSaved
              obscureText: true,
              decoration: const InputDecoration(labelText: "password"),
              validator: (value) {},
              onSaved: (value) {},
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 10)),

            ElevatedButton(
              onPressed: () {
                // can validate and save be rewritten?
                if(_formKey.currentState!.validate()){
                  _formKey.currentState!.save();

                  //might need to give login successful the email in order to load the correct information 
                  Navigator.pushNamed(context, '/login_successful');
                }
              }, 
              child: const Text("Login")
            ),

            Text(
              'Need an account? Sign up',
              style: TextStyle(fontSize: 12, color: Colors.indigo),
            )
          ]
        )
      )
    );
  }
}