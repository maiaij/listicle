import 'package:listicle/models/CustomUser.dart';
import 'package:listicle/screens/authenticate/authenticate.dart';
import 'package:listicle/screens/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    
    if(user == null){
      return Authenticate();
    }

    else{
      return const Homepage();
    }
    
  }
}