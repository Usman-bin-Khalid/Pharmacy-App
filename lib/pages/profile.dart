import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/pages/login.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/services/shared_pref.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name, email, image, id, dob, gender, phone, address, allergies;

  getthesharedpref() async {
    id = await SharedprefMethods().getUserId();
    if (id != null) {
      DocumentSnapshot snapshot = await DatabaseMethods().getUserDetails(id!);
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        name = data["Name"] ?? "N/A";
        email = data["Email"] ?? "N/A";
        image = data["Image"];
        dob = data["DOB"] ?? "N/A";
        gender = data["Gender"] ?? "N/A";
        phone = data["Phone"] ?? "N/A";
        address = data["Address"] ?? "N/A";
        allergies = data["Allergies"] ?? "N/A";
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getthesharedpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd1cfeb),
      body: name == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          top: 45.0,
                          left: 20.0,
                          right: 20.0,
                        ),
                        height: MediaQuery.of(context).size.height / 4.3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.elliptical(
                              MediaQuery.of(context).size.width,
                              105.0,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 6.5,
                          ),
                          child: Material(
                            elevation: 10.0,
                            borderRadius: BorderRadius.circular(60),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: image == null || image == ""
                                  ? Image.asset(
                                      "assets/images/profile.png",
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      image!,
                                      height: 120,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 70.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 2.0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.black),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildProfileField(Icons.email, "Email", email!),
                  SizedBox(height: 20.0),
                  _buildProfileField(Icons.calendar_today, "DOB", dob!),
                  SizedBox(height: 20.0),
                  _buildProfileField(Icons.person_outline, "Gender", gender!),
                  SizedBox(height: 20.0),
                  _buildProfileField(Icons.phone, "Phone", phone!),
                  SizedBox(height: 20.0),
                  _buildProfileField(Icons.location_on, "Address", address!),
                  SizedBox(height: 20.0),
                  _buildProfileField(
                    Icons.medical_services,
                    "Allergies",
                    allergies!,
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () async {
                      // Add logout logic here if needed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 2.0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Colors.black),
                              SizedBox(width: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Log Out",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileField(IconData icon, String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
