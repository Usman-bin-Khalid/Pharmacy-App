import 'package:flutter/material.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productNameController = new TextEditingController();
  TextEditingController productPriceController = new TextEditingController();
  TextEditingController companyNameController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
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
      body: Container(
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
                  SizedBox(height: 50.0),
                  Text(
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
                children: [
                  SizedBox(height: 20),
                  const Text(
                    'Product Name',
                    style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                  ),
                  const SizedBox(height: 5),
                  _buildTextField("Product Name", productNameController),

                  SizedBox(height: 15),
                  const Text(
                    'Product Price',
                    style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                  ),
                  const SizedBox(height: 5),
                  _buildTextField("Product Price", productPriceController),
                  SizedBox(height: 15),
                  const Text(
                    'Product Category',
                    style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60.0),
                      border: Border.all(
                        color: const Color.fromARGB(85, 0, 0, 0),
                        width: 1.5,
                      ),
                    ),
                    child: DropdownButton<String>(
                      items: productCategories
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
                      onChanged: ((value) => setState(() {
                        this.value = value;
                      })),
                      dropdownColor: Colors.white,
                      hint: Text('Select Category'),
                      iconSize: 34,
                      icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                      value: value,
                    ),
                  ),
                  SizedBox(height: 15),
                  const Text(
                    'Company Name',
                    style: TextStyle(fontSize: 20.0, fontFamily: 'FredokaBold'),
                  ),
                  const SizedBox(height: 5),
                  _buildTextField("Company Name", companyNameController),
                  SizedBox(height: 15),
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
                      if (productNameController.text != "" &&
                          productPriceController.text != "" &&
                          value != "" &&
                          companyNameController.text != "" &&
                          descController.text != "") {
                        Map<String, dynamic> addProduct = {
                          'Name': productNameController.text.trim(),
                          'Price': productPriceController.text.trim(),
                          'Category': value,
                          'CompanyName': companyNameController.text.trim(),
                          'Description': descController.text.trim(),
                        };
                        await DatabaseMethods().addProduct(addProduct);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              'Product Added Successfully!',
                              style: AppWidget.whiteTextStyle(20),
                            ),
                          ),
                        );
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
                      child: Center(
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
                ],
              ),
            ),
          ],
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

  Widget _buildTextFieldDescription(
    String hint,
    TextEditingController controller,
  ) {
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
