import 'package:flutter/material.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';
class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: Color(0xffd1cfeb),
      body: Container(
        margin: EdgeInsets.only(top: 60, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Page' , style: AppWidget.headlineTextStyle(25),),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 20),
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
                    child: Image.asset('assets/images/medicine.png',
                    height: 120,
                    width: 120,
                  fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(width: 15,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Paracitamol' , style: AppWidget.headlineTextStyle(18),),
                      SizedBox(height: 2,),
                      Text("Quantity : " + "5", style: AppWidget.headlineTextStyle(16),),
                        SizedBox(height: 2,),
                      Text("Google" , style: AppWidget.headlineTextStyle(15),),
                        SizedBox(height: 2,),
                      Text("Total Price : " + "\$20.0", style: AppWidget.headlineTextStyle(15),)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}