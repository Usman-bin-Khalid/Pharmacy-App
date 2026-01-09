import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pharmacy_app/pages/detail_page.dart';
import 'package:pharmacy_app/services/database.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool allMedicine = true, suppliment = false, herbal = false, vitamins = false;
  Stream? productStream;

  getOntheload() async {
    productStream = await DatabaseMethods().getAllProducts('Medicine');
    setState(() {});
  }

  Widget allProducts() {
    return StreamBuilder(
      stream: productStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            name: ds['Name'],
                            detail: ds['Description'],
                            price: ds['Price'],
                            company: ds['CompanyName'],
                            image:
                                "assets/images/medicine.png", // Using static image for now
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 30.0, bottom: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffbab3a6),
                            Color(0xffddd7cd),
                            Color(0xffa59c8f),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/medicine.png',
                              height: 300,
                            ),
                          ),
                          Container(
                            height: 300,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(20),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Color(0xffc8c1b5),
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ds['Name'],
                                            style: AppWidget.whiteTextStyle(18),
                                          ),
                                          Text(
                                            '\$' + ds['Price'],
                                            style: AppWidget.whiteTextStyle(18),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        ds['CompanyName'],
                                        style: AppWidget.whiteTextStyle(18),
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
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  void initState() {
    getOntheload();

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
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(60),
              child: Image.asset(
                'assets/images/doctor.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 30),
            Text('Your Trusted', style: AppWidget.headlineTextStyle(26.0)),
            Text('Online Pharmacy', style: AppWidget.lightTextStyle(28.0)),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 17),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 225, 219, 248),
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(width: 1.5, color: Colors.white),
                      ),
                      child: Center(
                        child: TextField(
                          textAlignVertical: TextAlignVertical
                              .center, // text ko center mai lany ky liy
                          decoration: InputDecoration(
                            hintText: '  Search Medicine...',
                            hintStyle: AppWidget.lightTextStyle(15.0),
                            border: InputBorder.none,
                            suffixIcon: Container(
                              margin: EdgeInsets.all(3),
                              width: 100,

                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(Icons.search, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.0),
            Container(
              height: 50,

              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  allMedicine
                      ? AppWidget.selectedCategory('All Medicines')
                      : GestureDetector(
                          onTap: () async {
                            allMedicine = true;
                            suppliment = false;
                            vitamins = false;
                            herbal = false;
                            productStream = await DatabaseMethods()
                                .getAllProducts('Medicine');
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                'All Medicines',
                                style: AppWidget.lightTextStyle(14),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(width: 12),
                  suppliment
                      ? AppWidget.selectedCategory('Suppliment')
                      : GestureDetector(
                          onTap: () async {
                            allMedicine = false;
                            suppliment = true;
                            vitamins = false;
                            herbal = false;
                            productStream = await DatabaseMethods()
                                .getAllProducts('Suppliments');
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Suppliment',
                                style: AppWidget.lightTextStyle(14),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(width: 12),
                  vitamins
                      ? AppWidget.selectedCategory('Vitamins')
                      : GestureDetector(
                          onTap: () async {
                            allMedicine = false;
                            vitamins = true;
                            suppliment = false;
                            herbal = false;
                            productStream = await DatabaseMethods()
                                .getAllProducts('Vitamins');
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Vitamins',
                                style: AppWidget.lightTextStyle(14),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(width: 12),
                  herbal
                      ? AppWidget.selectedCategory('Herbal')
                      : GestureDetector(
                          onTap: () async {
                            allMedicine = false;
                            vitamins = false;
                            suppliment = false;
                            herbal = true;
                            productStream = await DatabaseMethods()
                                .getAllProducts('Herbal');
                            setState(() {});
                          },
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Herbal',
                                style: AppWidget.lightTextStyle(14),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(child: allProducts()),
          ],
        ),
      ),
    );
  }
}
