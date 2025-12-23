import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class DatabaseMethods {
  Future addUserInfo(Map<String, dynamic> userInfoMap, String id) {
    return FirebaseFirestore.instance
        .collection("pharmacy_users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addProduct(Map<String, dynamic> productInfoMap) {
    return FirebaseFirestore.instance
        .collection("Products")
        .add(productInfoMap);
  }

  Future<Stream<QuerySnapshot>> getAllProducts(String category) async {
    return await FirebaseFirestore.instance
        .collection('Products')
        .where('Category', isEqualTo: category)
        .snapshots();
  }
}
