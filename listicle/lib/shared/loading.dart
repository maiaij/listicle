import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//https://pub.dev/packages/flutter_spinkit
class Loading extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      //decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      color: Colors.indigo[100],
      child: const Center(
        child: SpinKitFadingFour(
          color: Colors.indigo,
          size: 50,
        ),
      ),
    );
  }
}