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
  String selectedCategory = "Medicine";

  TextEditingController searchController = TextEditingController();

  getOntheload() async {
    productStream = await DatabaseMethods().getAllProducts(selectedCategory);
    setState(() {});
  }
  
   

  
  // Search function
  searchProducts(String name) async {
    productStream = await DatabaseMethods().search(name, selectedCategory);
    setState(() {});
  }

  @override
  void initState() {
    getOntheload();
    super.initState();
  }

  Widget categoryTab(String title, bool isActive, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(30),

          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black54,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1cfeb),
      body: Container(
        padding: const EdgeInsets.only(top: 40, left: 20),
        // 3. CustomScrollView enables the entire screen to scroll
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      'assets/images/doctor.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.fill,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Your Trusted',
                    style: AppWidget.headlineTextStyle(26.0),
                  ),
                  Text(
                    'Online Pharmacy',
                    style: AppWidget.lightTextStyle(28.0),
                  ),
                  const SizedBox(height: 15.0),

                  // Search Bar
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 225, 219, 248),
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(width: 1.5, color: Colors.white),
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        searchProducts(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Medicine...',
                        hintStyle: AppWidget.lightTextStyle(15.0),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          left: 20,
                          top: 15,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(4),
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        0.3,
                      ), // Soft frosted glass look
                      borderRadius: BorderRadius.circular(35),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: SizedBox(
                      height: 45, // Slightly slimmer for a modern look
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          categoryTab('All Medicines', allMedicine, () async {
                            setState(() {
                              allMedicine = true;
                              suppliment = false;
                              vitamins = false;
                              herbal = false;
                              selectedCategory = "Medicine";
                            });
                            getOntheload();
                          }),
                          categoryTab('Supplements', suppliment, () async {
                            setState(() {
                              allMedicine = false;
                              suppliment = true;
                              vitamins = false;
                              herbal = false;
                              selectedCategory = "Supplements";
                            });
                            getOntheload();
                          }),
                          categoryTab('Vitamins', vitamins, () async {
                            setState(() {
                              allMedicine = false;
                              suppliment = false;
                              vitamins = true;
                              herbal = false;
                              selectedCategory = "Vitamins";
                            });
                            getOntheload();
                          }),
                          categoryTab('Herbal', herbal, () async {
                            setState(() {
                              allMedicine = false;
                              suppliment = false;
                              vitamins = false;
                              herbal = true;
                              selectedCategory = "Herbal";
                            });
                            getOntheload();
                          }),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),
                ],
              ),
            ),

            // The Medicine List (SliverList allows it to scroll with the header)
            StreamBuilder(
              stream: productStream,
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return productCard(
                      ds,
                    ); // UI Logic moved to helper for clarity
                  }, childCount: snapshot.data.docs.length),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget productCard(DocumentSnapshot ds) {
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
              image: "assets/images/medicine.png",
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20.0, bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xffbab3a6), Color(0xffddd7cd), Color(0xffa59c8f)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.asset('assets/images/medicine.png', height: 250),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xffc8c1b5).withOpacity(0.9),
                  border: Border.all(width: 1.5, color: Colors.white),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ds['Name'], style: AppWidget.whiteTextStyle(18)),
                        Text(
                          '\$' + ds['Price'],
                          style: AppWidget.whiteTextStyle(18),
                        ),
                      ],
                    ),
                    Text(
                      ds['CompanyName'],
                      style: AppWidget.whiteTextStyle(14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
