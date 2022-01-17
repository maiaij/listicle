import 'package:flutter/material.dart';
import 'package:listicle/screens/authenticate/sign_in.dart';
import 'package:listicle/screens/pages/homepage.dart';

class Authenticate extends StatefulWidget{
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>{
  @override
  Widget build(BuildContext context){
    return Container(
      //child: SignIn(),
      child: const Homepage(),
    );
  }
}