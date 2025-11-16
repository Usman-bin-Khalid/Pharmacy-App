import 'package:flutter/material.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        
              Image.asset(
                'assets/images/medicine.png',
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
                          'Paracitamol',
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
                              Icon(Icons.remove, color: Colors.black),
                              SizedBox(width: 10),
                              Text('1', style: AppWidget.headlineTextStyle(18.0)),
                              SizedBox(width: 10),
                              Icon(Icons.add, color: Colors.black),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Description', style: AppWidget.lightTextStyle(16)),
                    SizedBox(height: 10),
                    Text(
                      '''simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.''',
                      style: AppWidget.lightTextStyle(16),
                    ),
        
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
                              Text('Price', style: AppWidget.lightTextStyle(18)),
                              Text(
                                '\$28.0',
                                style: AppWidget.headlineTextStyle(20),
                              ),
                            ],
                          ),
                          Container(
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
