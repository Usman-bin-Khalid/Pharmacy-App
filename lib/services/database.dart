import 'package:cloud_firestore/cloud_firestore.dart';

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
}