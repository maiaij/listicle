import 'package:listicle/screens/authenticate/authenticate.dart';
import 'package:listicle/screens/pages/homepage.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  //const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return the home or authenticate widget
    return Authenticate();
  }
}