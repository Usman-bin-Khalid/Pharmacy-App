import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_app/admin/add_product.dart';
import 'package:pharmacy_app/pages/home.dart';
import 'package:pharmacy_app/pages/signup.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool loading = false;
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
                      'Admin Login',
                      style: TextStyle(
                        fontSize: 55.0,
                        color: Colors.black,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    Text(
                      'Manage Complete App',
                      style: TextStyle(
                        fontSize: 32.0,
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
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30.0),
                    Center(
                      child: Text(
                        'Unique ID',
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
                      'Username',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField("Username", userNameController),
                    const SizedBox(height: 30.0),
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField("Your Password", passwordController),

                    const SizedBox(height: 40.0),

                    GestureDetector(
                      onTap: () {
                        if (userNameController.text.isEmpty ||
                            passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(
                                'Please fill all the fields',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );
                          return;
                        }
                        loginAdmin();
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
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                              : Text(
                                  'Login Account',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'FredokaBold',
                                  ),
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




  loginAdmin() {
    setState(() {
      loading = true;
    });
    FirebaseFirestore.instance
        .collection("Admin")
        .where("id", isEqualTo: userNameController.text.trim())
        .where("password", isEqualTo: passwordController.text)
        .get()
        .then((value) {
          if (value.docs.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Login Successful',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddProduct()),
            );
            print("Login Successful");
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Invalid Credentials',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              );
            }
            print("Invalid Credentials");
          }
        });
  }
}
