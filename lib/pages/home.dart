import 'package:flutter/material.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.only(left: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 40),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 225, 219, 248),
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(width: 1.5, color: Colors.white),
                      ),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search Medicine...',
                            hintStyle: AppWidget.lightTextStyle(18.0),
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
            SizedBox(height: 50.0),
            Container(
              height: 50,

              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Center(
                      child: Text(
                        'All Medicines',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 20.0,
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
}
