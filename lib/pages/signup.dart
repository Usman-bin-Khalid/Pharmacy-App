import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_app/pages/login.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/services/shared_pref.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool loading = false;
  String? name, email, password;
  registraion() async {
    setState(() {
      loading = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      String id = userCredential.user!.uid;
      Map<String, dynamic> userInfoMap = {
        'Name': nameController.text,
        'Email': emailController.text,
        'id': id,
        'Wallet': '0',
      };

      await SharedprefMethods().saveUserId(id);
      await SharedprefMethods().saveUserName(name!);
      await SharedprefMethods().saveUserEmail(email!);
      await DatabaseMethods().addUserInfo(userInfoMap, id);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Account created successfully!',
            style: AppWidget.whiteTextStyle(20),
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'The password provided is too weak.',
              style: AppWidget.whiteTextStyle(20),
            ),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'The account already exists for that email.',
              style: AppWidget.whiteTextStyle(20),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

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
                height: MediaQuery.of(context).size.height / 2.2,
                decoration: const BoxDecoration(
                  color: Color(0xfff7bc3c),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60.0),
                    bottomRight: Radius.circular(60.0),
                  ),
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 35.0),
                    Text(
                      'Join Us',
                      style: TextStyle(
                        fontSize: 60.0,
                        color: Colors.black,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    Text(
                      'Create Free Account',
                      style: TextStyle(
                        fontSize: 30.0,
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
                  top: MediaQuery.of(context).size.height / 3.7,
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
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20.0),
                    const Center(
                      child: Text(
                        'Personal Info',
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
                    const SizedBox(height: 20.0),
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField("Your Name", nameController),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField("Your Email Address", emailController),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),

                    const SizedBox(height: 5),
                    _buildTextField("Your Password", passwordController),

                    const SizedBox(height: 20.0),

                    GestureDetector(
                      onTap: () {
                        if (nameController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            passwordController.text.isNotEmpty) {
                          setState(() {
                            name = nameController.text;
                            email = emailController.text;
                            password = passwordController.text;
                          });
                          registraion();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Please fill all the fields',
                                style: AppWidget.whiteTextStyle(20),
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xfff7bc3c),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Center(
                          child: loading
                              ? Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'FredokaBold',
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: Text(
                          'Back to login',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'FredokaLight',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.0),
        border: Border.all(
          color: const Color.fromARGB(85, 0, 0, 0),
          width: 1.5,
        ),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
