import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
Widget build(BuildContext context) {

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemStatusBarContrastEnforced: false,
    ),
  );

  return Scaffold(
    extendBodyBehindAppBar: true,
  
    resizeToAvoidBottomInset: true, 
    body: SingleChildScrollView( 
      child: Container(
 
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          children: [
           
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(
                color: Color(0xfff7bc3c),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60.0),
                  bottomRight: Radius.circular(60.0),
                ),
              ),
              child: Column(
                children: const [
                  SizedBox(height: 60.0), 
                  Text(
                    'Hello',
                    style: TextStyle(
                      fontSize: 60.0,
                      color: Colors.black,
                      fontFamily: 'FredokaBold',
                    ),
                  ),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.black,
                      fontFamily: 'FredokaLight',
                    ),
                  ),
                ],
              ),
            ),
     
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3.5, 
                left: 20.0,
                right: 20.0,
                bottom: 20.0, 
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 247, 234),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, 
                children: [
                  const SizedBox(height: 30.0),
                  const Center(
                    child: Text(
                      'Login Account',
                      style: TextStyle(
                        fontSize: 35.0,
                        color: Colors.black,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      '''Lorem Ipsum is simply dummy text of the printing and typesetting industry.''',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Text(
                    'Email Address',
                    style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                  ),
                  const SizedBox(height: 5),
                  _buildTextField("Your Email Address"),
                  const SizedBox(height: 30.0),
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                  ),
                  const SizedBox(height: 5),
                  _buildTextField("Your Password"),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(fontSize: 18.0, fontFamily: 'FredokaLight'),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  
                  
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xfff7bc3c),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Center(
                      child: Text(
                        'Login Account',
                        style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  const Center(
                    child: Text(
                      'Create New Account',
                      style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaLight'),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTextField(String hint) {
  return Container(
    padding: const EdgeInsets.only(left: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(60.0),
      border: Border.all(color: const Color.fromARGB(85, 0, 0, 0), width: 1.5),
      color: Colors.white,
    ),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
      ),
    ),
  );
}

}
