import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/services/shared_pref.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class DetailPage extends StatefulWidget {
  final String name, detail, price, company, image;

  const DetailPage({
    super.key,
    required this.name,
    required this.detail,
    required this.price,
    required this.company,
    required this.image,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  double totalPrice = 0.0;
  String? id, wallet;

  getthesharedpref() async {
    id = await SharedprefMethods().getUserId();
    setState(() {});
  }

  getontheload() async {
    await getthesharedpref();
    if (id != null) {
      DocumentSnapshot snapshot = await DatabaseMethods().getUserDetails(id!);
      wallet = snapshot["Wallet"];
    }
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    totalPrice = double.parse(widget.price);
    super.initState();
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
      backgroundColor: Color(0xffd1cfeb),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              widget.image.startsWith("assets/")
                  ? Image.asset(
                      widget.image,
                      height: MediaQuery.of(context).size.height / 2.5,
                      fit: BoxFit.fill,
                    )
                  : Image.network(
                      widget.image,
                      height: MediaQuery.of(context).size.height / 2.5,
                      fit: BoxFit.fill,
                    ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 30.0, right: 30.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(122, 255, 255, 255),
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.name,
                          style: AppWidget.headlineTextStyle(20),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color.fromARGB(159, 255, 255, 255),
                          ),

                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (quantity > 1) {
                                    quantity = quantity - 1;
                                    totalPrice =
                                        totalPrice - double.parse(widget.price);
                                    setState(() {});
                                  }
                                },
                                child: Icon(Icons.remove, color: Colors.black),
                              ),
                              SizedBox(width: 10),
                              Text(
                                quantity.toString(),
                                style: AppWidget.headlineTextStyle(18.0),
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  quantity = quantity + 1;
                                  totalPrice =
                                      totalPrice + double.parse(widget.price);
                                  setState(() {});
                                },
                                child: Icon(Icons.add, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Description', style: AppWidget.lightTextStyle(16)),
                    SizedBox(height: 10),
                    Text(widget.detail, style: AppWidget.lightTextStyle(16)),

                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(159, 255, 255, 255),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Price',
                                style: AppWidget.lightTextStyle(18),
                              ),
                              Text(
                                '\$' + totalPrice.toStringAsFixed(2),
                                style: AppWidget.headlineTextStyle(20),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (wallet != null) {
                                if (double.parse(wallet!) >= totalPrice) {
                                  double amount =
                                      double.parse(wallet!) - totalPrice;
                                  await DatabaseMethods().updateUserWallet(
                                    id!,
                                    amount.toString(),
                                  );
                                  await DatabaseMethods().addTransaction({
                                    "amount": totalPrice.toString(),
                                    "type": "Debit",
                                    "time": DateTime.now().toIso8601String(),
                                  }, id!);
                                  Map<String, dynamic> orderInfoMap = {
                                    "Product": widget.name,
                                    "Price": widget.price,
                                    "Quantity": quantity.toString(),
                                    "Total": totalPrice.toString(),
                                    "Image": widget.image,
                                    "Name": widget.company,
                                  };
                                  await DatabaseMethods().addOrder(
                                    orderInfoMap,
                                    id!,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        "Order Placed Successfully!",
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Insufficient Balance!"),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Center(
                                child: Text(
                                  'Order Now',
                                  style: AppWidget.whiteTextStyle(20.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
