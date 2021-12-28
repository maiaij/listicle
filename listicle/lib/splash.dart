import 'package:flutter/material.dart';

class Splash extends StatefulWidget{
  const Splash ({ Key? key}): super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState(){
    super.initState();
    _navigatetohome();
  }

  void _navigatetohome() async {
    await Future.delayed(const Duration(seconds: 5), () {});
    Navigator.pushReplacementNamed(context, '/wrapper');
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: const Image(
          image: AssetImage('assets/temp_loading_screen.png'),
        ),
      ),
    );
  }
}