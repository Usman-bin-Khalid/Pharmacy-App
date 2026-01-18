import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pharmacy_app/pages/bottom_nav.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/services/shared_pref.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class CompleteProfile extends StatefulWidget {
  final String userId;
  const CompleteProfile({super.key, required this.userId});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController allergiesController = TextEditingController();
  String? gender;
  bool loading = false;

  final List<String> genders = ['Male', 'Female', 'Other'];

  Future getImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  uploadItem() async {
    if (dobController.text.isNotEmpty &&
        gender != null &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      setState(() {
        loading = true;
      });

      String? imageUrl;
      if (selectedImage != null) {
        Reference firebaseStorageRef = FirebaseStorage.instance
            .ref()
            .child("profileImages")
            .child("${widget.userId}.jpg");
        final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
        var downloadUrl = await (await task).ref.getDownloadURL();
        imageUrl = downloadUrl;
      }

      Map<String, dynamic> updateUserInfo = {
        'DOB': dobController.text,
        'Gender': gender,
        'Phone': phoneController.text,
        'Address': addressController.text,
        'Allergies': allergiesController.text,
        'Image': imageUrl ?? "",
      };

      await DatabaseMethods().updateUserDetails(updateUserInfo, widget.userId);

      setState(() {
        loading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Profile Completed Successfully!",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Please fill all the details",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                  color: Color(0xfff7bc3c),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60.0),
                    bottomRight: Radius.circular(60.0),
                  ),
                ),
                child: Column(
                  children: const [
                    SizedBox(height: 50.0),
                    Text(
                      'Complete Profile',
                      style: TextStyle(
                        fontSize: 45.0,
                        color: Colors.black,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 6.5,
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 247, 234),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => ImageSourceBottomSheet(
                              onImageSelected: getImage,
                            ),
                          );
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : const AssetImage("assets/images/profile.png")
                                    as ImageProvider,
                          child: selectedImage == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.grey,
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: selectDate,
                      child: AbsorbPointer(
                        child: _buildTextField(
                          "YYYY-MM-DD",
                          dobController,
                          prefixIcon: Icons.calendar_today,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(60.0),
                        border: Border.all(
                          color: const Color.fromARGB(85, 0, 0, 0),
                          width: 1.5,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          items: genders
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: AppWidget.headlineTextStyle(18.0),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => this.gender = value),
                          dropdownColor: Colors.white,
                          hint: const Text('Select Gender'),
                          value: gender,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    IntlPhoneField(
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(85, 0, 0, 0),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60.0),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(85, 0, 0, 0),
                            width: 1.5,
                          ),
                        ),
                      ),
                      initialCountryCode: 'US',
                      onChanged: (phone) {
                        phoneController.text = phone.completeNumber;
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField(
                      "Your Address",
                      addressController,
                      prefixIcon: Icons.location_on,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Medical Allergies (if any)',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'FredokaBold',
                      ),
                    ),
                    const SizedBox(height: 5),
                    _buildTextField(
                      "e.g. Penicillin",
                      allergiesController,
                      prefixIcon: Icons.medical_services,
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: uploadItem,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xfff7bc3c),
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Center(
                          child: loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Complete Profile',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'FredokaBold',
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    IconData? prefixIcon,
  }) {
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
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        ),
      ),
    );
  }
}

class ImageSourceBottomSheet extends StatelessWidget {
  final Function(ImageSource) onImageSelected;
  const ImageSourceBottomSheet({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onImageSelected(ImageSource.camera);
                },
                child: Column(
                  children: const [
                    Icon(Icons.camera_alt, size: 40),
                    Text("Camera"),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onImageSelected(ImageSource.gallery);
                },
                child: Column(
                  children: const [
                    Icon(Icons.photo_library, size: 40),
                    Text("Gallery"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
