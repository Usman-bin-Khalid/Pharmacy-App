import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/services/shared_pref.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class EditProfile extends StatefulWidget {
  final String name, phone, address, allergies, image, id;
  const EditProfile({
    super.key,
    required this.name,
    required this.phone,
    required this.address,
    required this.allergies,
    required this.image,
    required this.id,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    nameController.text = widget.name;
    phoneController.text = widget.phone;
    addressController.text = widget.address;
    allergiesController.text = widget.allergies;
    super.initState();
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
      setState(() {});
    }
  }

  updateProfile() async {
    setState(() {
      loading = true;
    });

    String? imageUrl = widget.image;

    if (selectedImage != null) {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("profileImages")
          .child("${widget.id}.jpg");
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      imageUrl = downloadUrl;
    }

    Map<String, dynamic> updateUserInfo = {
      'Name': nameController.text.trim(),
      'Phone': phoneController.text.trim(),
      'Address': addressController.text.trim(),
      'Allergies': allergiesController.text.trim(),
      'Image': imageUrl,
    };

    await DatabaseMethods().updateUserDetails(updateUserInfo, widget.id);
    await SharedprefMethods().saveUserName(nameController.text.trim());

    setState(() {
      loading = false;
    });

    Navigator.pop(context, true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Profile Updated Successfully!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1cfeb),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        title: Text("Edit Profile", style: AppWidget.headlineTextStyle(20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                          )
                        : (widget.image != ""
                              ? Image.network(
                                  widget.image,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/profile.png",
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                )),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: getImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildEditField("Name", nameController, Icons.person),
            const SizedBox(height: 20),
            _buildEditField("Phone", phoneController, Icons.phone),
            const SizedBox(height: 20),
            _buildEditField("Address", addressController, Icons.location_on),
            const SizedBox(height: 20),
            _buildEditField(
              "Medical Allergies",
              allergiesController,
              Icons.medical_services,
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: updateProfile,
              child: Container(
                height: 55,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff6a5ae0), Color(0xff9087e5)],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff6a5ae0).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(icon, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
