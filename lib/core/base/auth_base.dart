import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendor/core/model/comment_model.dart';
import 'package:vendor/core/model/park_history_model.dart';

abstract class AuthBase {
  Future<Object?> getCurrentEmployee();
  Future<Object?> signInWithEmailAndPassword(String email,String password);
  Future<Object?> sendPasswordResetEmail(String email);
  Future signOut();
  Future<bool> sendCode(String phone);
  Future<bool> verifyCode(String code);
  Future<Object> getVendor(String vendorId);
  Future<Object> changeVendor(String vendorId);
  Future<Object> changeStatus(bool status, String vendorId);
  Future<Object> sendRequest(String vendorId, String customerCode);
  Future<bool> setOpenHour(String openTime, String vendorId);
  Stream<QuerySnapshot>? getParks(String vendorId);
}
