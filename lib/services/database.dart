import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserInfo(Map<String, dynamic> userInfoMap, String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  search(String name, String category) async {
    return FirebaseFirestore.instance
        .collection(category)
        .where('Name', isGreaterThanOrEqualTo: name)
        .where('Name', isLessThanOrEqualTo: name + '\uf8ff')
        .snapshots();
  }

  Future addProduct(Map<String, dynamic> productInfoMap) {
    return FirebaseFirestore.instance
        .collection("Products")
        .add(productInfoMap);
  }

  Future<Stream<QuerySnapshot>> getAllProducts(String category) async {
    return FirebaseFirestore.instance
        .collection('Products')
        .where('Category', isEqualTo: category)
        .snapshots();
  }

  Future addOrder(Map<String, dynamic> orderInfoMap, String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Orders")
        .add(orderInfoMap);
  }

  Future<Stream<QuerySnapshot>> getOrders(String id) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Orders')
        .snapshots();
  }

  Future updateUserWallet(String id, String amount) {
    return FirebaseFirestore.instance.collection("users").doc(id).update({
      "Wallet": amount,
    });
  }

  Future addTransaction(Map<String, dynamic> transactionMap, String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Transactions")
        .add(transactionMap);
  }

  Future<Stream<QuerySnapshot>> getTransactions(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Transactions")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserDetails(String id) async {
    return await FirebaseFirestore.instance.collection("users").doc(id).get();
  }
}
