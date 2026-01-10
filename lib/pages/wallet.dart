import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/services/shared_pref.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? wallet, id;

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
    transactionStream = null;
    getTransactions();
    super.initState();
  }

  Stream? transactionStream;

  getTransactions() async {
    await getthesharedpref();
    if (id != null) {
      transactionStream = await DatabaseMethods().getTransactions(id!);
      setState(() {});
    }
  }
Widget transactionList() {
  return StreamBuilder(
    stream: transactionStream,
    builder: (context, AsyncSnapshot snapshot) {
      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }
      if (snapshot.data.docs.isEmpty) {
        return Center(
          child: Text(
            "No Transactions Yet",
            style: AppWidget.headlineTextStyle(16),
          ),
        );
      }
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 20), 
        itemCount: snapshot.data.docs.length,
     
        itemBuilder: (context, index) {
          DocumentSnapshot ds = snapshot.data.docs[index];
          return Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  ds["type"] == "Credit"
                      ? "assets/images/cashback.png"
                      : "assets/images/credit-card-payment.png",
                  width: 45,
                  height: 45,
                ),
                Text(
                  "\$ " + ds["amount"],
                  style: AppWidget.headlineTextStyle(18),
                ),
                Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: ds["type"] == "Credit"
                        ? Colors.green.withOpacity(0.3)
                        : Colors.blue.withOpacity(0.3),
                  ),
                  child: Center(
                    child: Text(
                      ds["type"].toString().toUpperCase(),
                      style: AppWidget.headlineTextStyle(13),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

  TextEditingController amountcontroller = TextEditingController();

  Future openEdit() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Container(
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel),
                ),
                SizedBox(width: 60),
                Center(
                  child: Text(
                    "Add Money",
                    style: AppWidget.headlineTextStyle(18),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Amount"),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black38, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: amountcontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Amount",
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                if (amountcontroller.text.isNotEmpty) {
                  Navigator.pop(context);
                  await makePayment(amountcontroller.text);
                }
              },
              child: Container(
                width: 100,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Color(0xFF008080),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Pay", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  makePayment(String amount) async {
    // In a real app, you'd integrate Stripe or Razorpay here.
    // For this demonstration, we'll simulate a successful payment.
    String currentWallet = wallet ?? "0";
    double newAmount = double.parse(currentWallet) + double.parse(amount);
    await DatabaseMethods().updateUserWallet(id!, newAmount.toString());
    await DatabaseMethods().addTransaction({
      "amount": amount,
      "type": "Credit",
      "time": DateTime.now().toIso8601String(),
    }, id!);
    getontheload();
    amountcontroller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Money Added Successfully!",
          style: TextStyle(fontSize: 18),
        ),
      ),
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
            Text('Wallet Page', style: AppWidget.headlineTextStyle(25)),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(right: 20),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 225, 219, 248),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/wallet.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Wallet",
                        style: AppWidget.headlineTextStyle(18),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "\$" + (wallet ?? "0"),
                        style: AppWidget.headlineTextStyle(20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(height: 30),
            Container(
              margin: EdgeInsets.only(right: 10),
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  GestureDetector(
                    onTap: () {
                      makePayment("100");
                    },
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "\$ 100",
                          style: AppWidget.whiteTextStyle(19),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      makePayment("200");
                    },
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "\$ 200",
                          style: AppWidget.whiteTextStyle(19),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      makePayment("500");
                    },
                    child: Container(
                      width: 130,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "\$ 500",
                          style: AppWidget.whiteTextStyle(19),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                openEdit();
              },
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  height: 50,
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
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      "Add money",
                      style: AppWidget.headlineTextStyle(20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(right: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Color.fromARGB(255, 225, 219, 248),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Your Transactions",
                      style: AppWidget.headlineTextStyle(20),
                    ),
                    SizedBox(height: 20),
                    Expanded(child: transactionList()),
                  ],
                ),
              ),
            ),
         
         
         
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}


