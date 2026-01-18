import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';
import 'package:random_string/random_string.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  // Corrected Controller initialization
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    // Added null check to prevent errors if user cancels selection
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  final List<String> productCategories = [
    'Medicine',
    'Suppliments',
    'Herbal',
    'Vitamins',
  ];
  String? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Added scroll for the whole screen to prevent overflow
        child: Container(
          height: MediaQuery.of(context).size.height, // Ensure container fills screen
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
                  // Removed const here because children are dynamic
                  children: [
                    const SizedBox(height: 50.0),
                    const Text(
                      'Add Product',
                      style: TextStyle(
                        fontSize: 55.0,
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: getImage,
                          child: selectedImage != null
                              ? Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.5),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Product Name',
                        style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold')
                      ),
                      const SizedBox(height: 5),
                      _buildTextField("Product Name", productNameController),
                      const SizedBox(height: 15),
                      const Text(
                        'Product Price',
                        style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                      ),
                      const SizedBox(height: 5),
                      _buildTextField("Product Price", productPriceController),
                      const SizedBox(height: 15),
                      const Text(
                        'Product Category',
                        style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
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
                        child: DropdownButtonHideUnderline( // Added to clean UI
                          child: DropdownButton<String>(
                            items: productCategories
                                .map((item) => DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: AppWidget.headlineTextStyle(18.0),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (newValue) => setState(() => value = newValue),
                            dropdownColor: Colors.white,
                            hint: const Text('Select Category'),
                            iconSize: 34,
                            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                            value: value,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Company Name',
                        style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                      ),
                      const SizedBox(height: 5),
                      _buildTextField("Company Name", companyNameController),
                      const SizedBox(height: 15),
                      const Text(
                        'Product Description',
                        style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                      ),
                      const SizedBox(height: 5),
                      _buildTextFieldDescription(
                        "Write something about Product...",
                        descController,
                      ),
                      const SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () async {
                          if (productNameController.text.isNotEmpty &&
                              productPriceController.text.isNotEmpty &&
                              value != null &&
                              companyNameController.text.isNotEmpty &&
                              descController.text.isNotEmpty) {
                            
                            String addId = randomAlphaNumeric(10);
                            String? imageUrl;

                            if (selectedImage != null) {
                              Reference firebaseStorageRef = FirebaseStorage.instance
                                  .ref()
                                  .child("productImages")
                                  .child(addId);
                              final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
                              imageUrl = await (await task).ref.getDownloadURL();
                            }

                            Map<String, dynamic> addProduct = {
                              'Name': productNameController.text.trim(),
                              'Price': productPriceController.text.trim(),
                              'Category': value,
                              'CompanyName': companyNameController.text.trim(),
                              'Description': descController.text.trim(),
                              'Image': imageUrl ?? "https://firebasestorage.googleapis.com/v0/b/flutter-pharmacy-app.appspot.com/o/productImages%2Fplaceholder.png?alt=media&token=8b8e0b2e-9d1e-4b1e-8b1e-0b2e0b2e0b2e",
                            };

                            await DatabaseMethods().addProduct(addProduct);
                            
                            if (mounted) { // Best practice to check if context is still valid
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                    'Product Added Successfully!',
                                    style: AppWidget.whiteTextStyle(20),
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  'Please Fill all the Details...',
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
                          child: const Center(
                            child: Text(
                              'Add Product',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'FredokaBold',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20), // Padding at the bottom
                    ],
                  ),
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

  Widget _buildTextFieldDescription(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: const Color.fromARGB(85, 0, 0, 0),
          width: 1.5,
        ),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}