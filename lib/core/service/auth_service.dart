import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vendor/core/base/auth_base.dart';
import 'package:vendor/core/model/comment_model.dart';
import 'package:vendor/core/model/employee_model.dart';
import 'package:vendor/core/model/park_history_model.dart';
import 'package:vendor/core/model/vendor_model.dart';

class AuthService implements AuthBase {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<Object> changeVendor(String vendorId) {
    return getVendor(vendorId);
  }

  @override
  Future<Object> getVendor(String vendorId) async {
    try {
      CollectionReference customer = firebaseFirestore.collection("vendor");
      DocumentSnapshot documentSnapshot = await customer.doc(vendorId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> map =
        documentSnapshot.data() as Map<String, dynamic>;
        return VendorModel.fromJson(map);
      } else {
        return "Vendor does not exist";
      }
    } catch (e) {
      debugPrint(
        "VendorService - Exception - Get Vendor : ${e.toString()}",
      );
      return "Something went wrong";
    }
  }

  @override
  Future<Object> changeStatus(bool status, String vendorId) async {
    try {
      await firebaseFirestore
          .collection("vendor")
          .doc(vendorId)
          .update({"active": status});
      return "Status changed";
    } catch (e) {
      debugPrint(
        "VendorService - Exception - Change Status : ${e.toString()}",
      );
      return "Something went wrong";
    }
  }

  @override
  Future<Object> sendRequest(String vendorId, String customerCode) async {
    try {
      var url = Uri.https(
          'us-central1-heryerpark-ms.cloudfunctions.net', 'sendRequest');
      var response = await http.post(url,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode({
            'employeeId': firebaseAuth.currentUser!.uid,
            'customerCode': customerCode,
            'vendorId': vendorId,
          }));
      return jsonDecode(response.body)["message"];
    } catch (e) {
      debugPrint(
        "VendorService - Exception - Send Request : ${e.toString()}",
      );
      return "Something went wrong";
    }
  }

  @override
  Stream<QuerySnapshot<Object?>>? getParks(String vendorId) {
    DateTime date = DateTime.now();
    DateTime time = DateTime(date.year, date.month, date.day, 0);
    return firebaseFirestore
        .collection("vendor/$vendorId/history")
        .where("requestTime", isGreaterThan: time)
        .orderBy("requestTime", descending: true)
        .snapshots();
  }

  @override
  Future<Object?> getCurrentEmployee() async {
    try {
      User? user = firebaseAuth.currentUser;

      if (user != null) {
        var url = Uri.https(
            'us-central1-heryerpark-ms.cloudfunctions.net', 'getEmployee');
        var response = await http.post(url,
            headers: {
              'Content-type': 'application/json',
              'Accept': 'application/json'
            },
            body: jsonEncode({'employeeId': firebaseAuth.currentUser!.uid}));
        debugPrint(response.body);
        if (response.statusCode == 200) {
          return EmployeeModel.fromJson(jsonDecode(response.body));
        }
        return jsonDecode(response.body)["message"];
      }
      return "No employee found";
    } catch (e) {
      debugPrint(
        "AuthService - Exception - getCurrentEmployee : ${e.toString()}",
      );
      return "Something went wrong";
    }
  }

  @override
  Future<Object?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return getCurrentEmployee();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Future signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<Object?> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  @override
  Future<bool> sendCode(String phone) async {
    try {
      var url = Uri.https('us-central1-heryerpark-ms.cloudfunctions.net',
          'sendVerificationCode');
      var response = await http.post(url,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode({
            'phoneNumber': phone,
            'customerId': firebaseAuth.currentUser!.uid,
            'isEmployee': true,
          }));

      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint(
        "AuthService - Exception - Send Code : ${e.toString()}",
      );
      return false;
    }
  }

  @override
  Future<bool> verifyCode(String code) async {
    try {
      var url = Uri.https(
          'us-central1-heryerpark-ms.cloudfunctions.net', 'verifyCode');

      var response = await http.post(url,
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          },
          body: jsonEncode({
            'verificationCode': code,
            'customerId': firebaseAuth.currentUser!.uid,
            'isEmployee': true,
          }));

      if (response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      debugPrint(
        "AuthService - Exception - Verify Code : ${e.toString()}",
      );
      return false;
    }
  }

  Future<List<ParkHistory>> getParkHistory(String vendorId, String query) async {
    try {
      DateTime date = DateTime.now();
      DateTime time = DateTime(date.year, date.month, date.day, 0);
      QuerySnapshot querySnapshot;
      if(query == "denied"){
        querySnapshot = await firebaseFirestore
            .collection("vendor/$vendorId/history").where("requestTime", isGreaterThan: time).where("status", isEqualTo: "denied")
            .orderBy("requestTime", descending: true)
            .get();
      }else if(query == "process"){
        querySnapshot = await firebaseFirestore
            .collection("vendor/$vendorId/history").where("status", isEqualTo: "process")
            .orderBy("requestTime", descending: true)
            .get();
      }else if(query == "approval"){
        querySnapshot = await firebaseFirestore
            .collection("vendor/$vendorId/history").where("status", isEqualTo: "approval")
            .orderBy("requestTime", descending: true)
            .get();
      }else if(query == "earn"){
        querySnapshot = await firebaseFirestore
            .collection("vendor/$vendorId/history").where("status", isEqualTo: "completed").where("requestTime", isGreaterThan: time)
            .orderBy("requestTime", descending: true)
            .get();
      }else{
        querySnapshot = await firebaseFirestore
            .collection("vendor/$vendorId/history").where("requestTime", isGreaterThan: time)
            .orderBy("requestTime", descending: true)
            .get();
      }

      List<ParkHistory> list = [];
      for (int i = 0; i < querySnapshot.size; i++) {
        Map<String, dynamic> historyMap =
        querySnapshot.docs[i].data() as Map<String, dynamic>;
        list.add(
          ParkHistory.fromJson(historyMap),
        );
      }
      return list;
    } catch (e) {
      debugPrint(
        "AuthService - Exception - getParkHistory: ${e.toString()}",
      );
      return [];
    }

  }


  Future<List<RateModel>> getComments(String vendorId) async {
    try {
      QuerySnapshot querySnapshot =  await firebaseFirestore
          .collection("vendor/$vendorId/rating")
          .orderBy("commentDate", descending: true)
          .get();

      List<RateModel> list = [];
      for (int i = 0; i < querySnapshot.size; i++) {
        Map<String, dynamic> rateMap =
        querySnapshot.docs[i].data() as Map<String, dynamic>;
        list.add(
          RateModel.fromJson(rateMap),
        );
      }
      return list;
    } catch (e) {
      debugPrint(
        "AuthService - Exception - getComments: ${e.toString()}",
      );
      return [];
    }

  }

  @override
  Future<bool> setOpenHour(String hour, String vendorId) async {
    try {
      CollectionReference vendor = firebaseFirestore.collection("vendor");
      await vendor.doc(vendorId).update(
          {
            "openTime": hour
          });
      return true;
    } catch (e) {
      debugPrint(
        "AuthService - Exception - setOpenHour: ${e.toString()}",
      );
      return false;
    }

  }


  Future<bool> setCloseHour(String hour, String vendorId) async {
    try {
      CollectionReference vendor = firebaseFirestore.collection("vendor");
      await vendor.doc(vendorId).update(
          {
            "closeTime": hour
          });
      return true;
    } catch (e) {
      debugPrint(
        "AuthService - Exception - setCloseHour: ${e.toString()}",
      );
      return false;
    }

  }

}
