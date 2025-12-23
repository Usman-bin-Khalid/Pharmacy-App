import 'package:flutter/material.dart';
import 'package:pharmacy_app/widgets/support_widget.dart';
class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffd1cfeb),
      body: Container(
           margin: EdgeInsets.only(top: 60, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
    Text('Wallet Page' , style: AppWidget.headlineTextStyle(25),),
    SizedBox(height: 20,),
    Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 225, 219, 248),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/wallet.png', height: 100, width: 100,
                  fit: BoxFit.fill,),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Text("Your Wallet" , style: AppWidget.headlineTextStyle(18),),
                     SizedBox(height: 5,),
                     Text("\$200", style: AppWidget.headlineTextStyle(20),),
                  ],)
                ],
              ),
    ),
    Container(height: 30,),
    Container(
      margin: EdgeInsets.only(right: 10),
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          Container(
            width: 130,
            height: 40,
            decoration: BoxDecoration(color: Colors.black,
            borderRadius: BorderRadius.circular(10)
            
            ),
            
            child: Center(child: Text("\$ 100", style: AppWidget.whiteTextStyle(19),)),
          ),
       SizedBox(width: 20,),
       
       Container(
            width: 130,
            height: 40,
            decoration: BoxDecoration(color: Colors.black,
            borderRadius: BorderRadius.circular(10)
            
            ),
            
            child: Center(child: Text("\$ 200", style: AppWidget.whiteTextStyle(19),)),
          ),
       SizedBox(width: 20,),
       Container(
            width: 130,
            height: 40,
            decoration: BoxDecoration(color: Colors.black,
            borderRadius: BorderRadius.circular(10)
            
            ),
            
            child: Center(child: Text("\$ 500", style: AppWidget.whiteTextStyle(19),)),
          ),
       
       
       
        ],
      ),
    ),
  SizedBox(height: 40,),
    Center(
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
                          border: Border.all(color: Colors.white, width: 1.5)
      
        ),
        child: Center(child: Text("Add money", style: AppWidget.headlineTextStyle(20),)),
      ),
    ),
    SizedBox(height: 50,),
    Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(right: 20),
        width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
        topRight: Radius.circular(30)),
        color: Color.fromARGB(255, 225, 219, 248),
      ),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Text("Your Transactions", style: AppWidget.headlineTextStyle(20),),
          SizedBox(height: 20,),
          Container(
             padding: EdgeInsets.all(10),
     
        width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/cashback.png", width: 50,height: 50,),
          Text("\$ 200" , style: AppWidget.headlineTextStyle(18),),
          Container(
            width: 100,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.green.withOpacity(0.3)),
            child: Text("CREDIT", style: AppWidget.headlineTextStyle(13),),
          ),
        ],
      ),
          )
       , SizedBox(height: 15,),
          Container(
             padding: EdgeInsets.all(10),
     
        width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/credit-card-payment.png",  width: 50,height: 50,),
          Text("\$ 200" , style: AppWidget.headlineTextStyle(18),),
          Container(
            width: 100,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blue.withOpacity(0.3)),
            child: Text("DEBIT", style: AppWidget.headlineTextStyle(13),),
          ),
        ],
      ),
          )
       
       
       
        ],
      ),
      
      ),
    )
        
        ,SizedBox(height: 25,),
          ],
        ),
      ),
    );
  }
}