import 'package:flutter/material.dart';
import 'package:listicle/screens/authenticate/sign_in.dart';
import 'package:listicle/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget{
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{

  bool showSignIn = true;
  void toggleForm(){
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context){
      if(showSignIn){
        return SignIn(toggleForm: toggleForm);
      } else {
        return Register(toggleForm: toggleForm);
      }
  }
}