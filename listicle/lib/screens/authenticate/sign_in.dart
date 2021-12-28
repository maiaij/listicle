import 'package:flutter/material.dart';
import 'package:listicle/screens/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ref lab 7, exercise 6

class SignIn extends StatelessWidget{
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

  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(40.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const Padding(padding: EdgeInsets.only(top: 60)),

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
              '\nNeed an account? Sign up',
              style: TextStyle(fontSize: 12, color: Colors.indigo),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              child: TextButton(
                
                child: Text('Continue without account', style: TextStyle(fontSize: 12, color: Colors.indigo)),
                onPressed: () async {
                  dynamic result = await _auth.signInAnon();
                  if(result == null){
                    print("Error Signing in");
                  } else{
                    print('signed in');
                    print(result.uid);
                    Navigator.pushNamed(context, '/home');
                  }

                },
              ),
            )
          ]
        ))
      )
    );
  }
}