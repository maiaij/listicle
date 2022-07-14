import 'package:flutter/material.dart';
import 'package:listicle/screens/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ref lab 7, exercise 6

class SignIn extends StatelessWidget{
  final Function toggleForm;
  const SignIn({required this.toggleForm, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FormWidget(toggleForm));
  }
}

class FormWidget extends StatefulWidget{
  final Function toggleForm;
  const FormWidget(this.toggleForm, {Key? key}) : super(key: key);


  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _email = '';
  String? _password = '';
  String error = '';

  final AuthService _auth = AuthService();
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      body: Container(
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
                validator: (value) => (value == null || value.isEmpty) ? 'Enter an email' : null,
                //onSaved: (value){},
                onChanged:(value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
      
              TextFormField(
                // write the validator and onSaved
                obscureText: true,
                decoration: const InputDecoration(labelText: "password"),
                validator: (value) => (value!.length < 6) ? 'Passwords must be 6+ characters long' : null,
                //onSaved: (value) {},
                onChanged:(value) {
                  setState(() {
                    _password = value;
                  });
                }
              ),
      
              const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
      
              ElevatedButton(
                child: const Text("Login"),
                onPressed: () async{
                  if(_formKey.currentState!.validate()){
                    dynamic result = await _auth.signInWithEmailAndPassword(_email!, _password!);
                    if(result == null){
                      setState(() {
                        error = 'Invalid email and/or password';
                      });
                    }
                  }
                }, 
              ),

              const SizedBox(height: 12,),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
      
              TextButton(
                child: const Text(
                  '\nNeed an account? Sign up',
                  style: TextStyle(fontSize: 12, color: Colors.indigo),
                ),
      
                onPressed: (){
                  widget.toggleForm();
                },
      
              ),
      
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                child: TextButton(
                  
                  child: Text('Sign in anonymously', style: TextStyle(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.normal)),
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
        ),
      )
    );
  }
}