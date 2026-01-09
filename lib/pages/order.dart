import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/services/shared_pref.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? id;
  Stream? orderStream;

  getthesharedpref() async {
    id = await SharedprefMethods().getUserId();
    setState(() {});
  }

  getontheload() async {
    await getthesharedpref();
    if (id != null) {
      orderStream = await DatabaseMethods().getOrders(id!);
      setState(() {});
    }
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.docs.isEmpty) {
          return Center(
            child: Text(
              "No Orders Found",
              style: AppWidget.headlineTextStyle(20),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 225, 219, 248),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffbab3a6),
                          Color(0xffddd7cd),
                          Color(0xffa59c8f),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ds["Image"].toString().startsWith("assets/")
                        ? Image.asset(
                            ds["Image"],
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            ds["Image"],
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ds["Product"],
                        style: AppWidget.headlineTextStyle(18),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Quantity : " + ds["Quantity"],
                        style: AppWidget.headlineTextStyle(16),
                      ),
                      SizedBox(height: 2),
                      Text(ds["Name"], style: AppWidget.headlineTextStyle(15)),
                      SizedBox(height: 2),
                      Text(
                        "Total Price : " + "\$" + ds["Total"],
                        style: AppWidget.headlineTextStyle(15),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd1cfeb),
      body: Container(
        margin: EdgeInsets.only(top: 60, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Page', style: AppWidget.headlineTextStyle(25)),
            SizedBox(height: 20),
            Expanded(child: allOrders()),
          ],
        ),
      ),
    );
  }
}
