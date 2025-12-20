import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
             Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                color: Color(0xfff7bc3c)
              ),
              child: Column(
                children: [
                  SizedBox(height: 50.0,),
                  Text('Hello', style: TextStyle(fontSize: 60.0, color: Colors.black,
                  fontFamily: 'FredokaBold'
                  
                  ),)
                ],
              ),
             )
          ],
        ),
      ),
    );
    
  }
}
