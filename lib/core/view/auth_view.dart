import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendor/core/base/auth_base.dart';
import 'package:vendor/core/model/employee_model.dart';
import 'package:vendor/core/model/enum.dart';
import 'package:vendor/core/model/park_history_model.dart';
import 'package:vendor/core/model/vendor_model.dart';
import 'package:vendor/core/service/auth_service.dart';
import 'package:vendor/locator.dart';

enum AuthProcess {
  idle,
  busy,
}

enum AuthState {
  authorized,
  landing,
  unauthorized,
  phone,
}

class AuthView with ChangeNotifier implements AuthBase {
  AuthProcess _authProcess = AuthProcess.idle;
  AuthState _authState = AuthState.landing;
  AuthService authService = locator<AuthService>();
  EmployeeModel? _employee;
  String? messageCode; //TODO: burayı sil

  VendorModel? _selectedVendor;
  StreamSubscription? listener;

  List<ParkHistory> parkHistory = [];
  List<ParkHistory> activePark = [];
  List<ParkHistory> approvalPark = [];
  List<ParkHistory> todayDeniedPark = [];

  double todayEarnings = 0;
  int todayParkCount = 0;

  EmployeeModel? get employee => _employee;

  set employee(EmployeeModel? value) {
    _employee = value;
    notifyListeners();
  }

  VendorModel? get selectedVendor => _selectedVendor;

  set selectedVendor(VendorModel? value) {
    _selectedVendor = value;
    notifyListeners();
  }

  AuthProcess get authProcess => _authProcess;

  set authProcess(AuthProcess value) {
    _authProcess = value;
    notifyListeners();
  }

  AuthState get authState => _authState;

  set authState(AuthState value) {
    _authState = value;
    notifyListeners();
  }

  AuthView() {
    getCurrentEmployee();
  }

  @override
  Future<Object?> getCurrentEmployee() async {
    try {
      authProcess = AuthProcess.busy;
      var res = await authService.getCurrentEmployee();
      if(res is EmployeeModel) {
        employee = res;
        if(!employee!.verified) {
          await sendCode(employee!.employeePhoneNumber);
          authState = AuthState.phone;
        } else {
          authState = AuthState.authorized;
        }
        debugPrint(
          "AuthView - Current Customer : $employee",
        );
        return employee;
      } else{
        authState = AuthState.unauthorized;
        return res;
      }
    } catch (e) {
      debugPrint(
        "AuthView - Exception - Get Current Employee : ${e.toString()}",
      );
      return "Something went wrong";
    } finally {
      authProcess = AuthProcess.idle;
    }
  }

  @override
  Future<Object?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      authProcess = AuthProcess.busy;
      var res = await authService.signInWithEmailAndPassword(email, password);
      if (res is EmployeeModel) {
        employee = res;

        if(!employee!.verified) {
          await sendCode(employee!.employeePhoneNumber);
          authState = AuthState.phone;
        } else {
          authState = AuthState.authorized;
        }
        debugPrint(
          "AuthView - Sign In With Email And Password : $employee",
        );
        return employee;
      } else {
        authState = AuthState.unauthorized;
        return res;
      }
    } catch (e) {
      debugPrint(
        "AuthView - Exception - signInWithEmailAndPassword : ${e.toString()}",
      );
      return "Something went wrong";
    } finally {
      authProcess = AuthProcess.idle;
    }
  }

  @override
  Future signOut() async {
    try {
      await authService.signOut();
      employee = null;
      authState = AuthState.unauthorized;
    } catch (e) {
      debugPrint(
        "AuthView - Exception - signOut : ${e.toString()}",
      );
    }
  }

  @override
  Future<Object?> sendPasswordResetEmail(String email) async {
    try {
      authProcess = AuthProcess.busy;
      return await authService.sendPasswordResetEmail(email);
    } catch (e) {
      debugPrint(
        "AuthView - Exception - sendPasswordResetEmail : ${e.toString()}",
      );
      return null;
    } finally {
      authProcess = AuthProcess.idle;
    }
  }

  @override
  Future<bool> sendCode(String phone)async{
    try {
      authProcess = AuthProcess.busy;
      var result = await authService.sendCode(phone);
      Map data = jsonDecode(result.toString());
      messageCode = data["code"];
      debugPrint(data.toString());
      return result;
    } catch (e) {
      debugPrint(
        "AuthView - Exception - sendCode : ${e.toString()}",
      );
      return false;
    } finally {
      authProcess = AuthProcess.idle;
    }
  }

  @override
  Future<bool> verifyCode(String code)async{
    try {
      authProcess = AuthProcess.busy;
      var res= await authService.verifyCode(code);
      if(res){
        authState = AuthState.authorized;
        employee!.verified = true;
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(
        "AuthView - Exception - sendCode : ${e.toString()}",
      );
      return false;
    } finally {
      authProcess = AuthProcess.idle;
    }
  }

  void clear() {
    parkHistory.clear();
    activePark.clear();
    approvalPark.clear();
    todayDeniedPark.clear();
    todayEarnings = 0;
    todayParkCount = 0;
  }

  @override
  Future<Object> changeVendor(String vendorId, ) async {
    try {
      authProcess = AuthProcess.busy;
      if(listener != null){
        listener!.cancel();
      }
      clear();
      var result = await authService.changeVendor(vendorId);
      if (result is VendorModel) {
        selectedVendor = result;
        getParks(vendorId);
      }
      return result;
    } catch (e) {
      debugPrint(
        "VendorView - Exception - Change Vendor : ${e.toString()}",
      );
      return "Something went wrong";
    } finally {
      authProcess = AuthProcess.idle;
    }
  }

  @override
  Future<Object> getVendor(String vendorId) async {
    try {
      authProcess = AuthProcess.busy;
      return await authService.getVendor(vendorId);
    } catch (e) {
      debugPrint(
        "VendorView - Exception - Get Vendor : ${e.toString()}",
      );
      return "Something went wrong";
    } finally {
      authProcess = AuthProcess.idle;
    }
  }

  @override
  Future<Object> changeStatus(bool status, String vendorId) async {
    try {
      authProcess = AuthProcess.busy;
      var res = await authService.changeStatus(status, vendorId);
      if (res == "Status changed") {
        selectedVendor!.active = status;
      }
      return res;
    } catch (e) {
      debugPrint(
        "VendorView - Exception - Change Status : ${e.toString()}",
      );
      return "Something went wrong";
    } finally {
      authProcess = AuthProcess.idle;
    }
  }

  @override
  Future<Object> sendRequest(String vendorId, String customerCode) async {
    try{
      authProcess = AuthProcess.busy;
      return await authService.sendRequest(vendorId, customerCode);
    } catch (e) {
      debugPrint(
        "VendorView - Exception - Send Request : ${e.toString()}",
      );
      return "Something went wrong";
    } finally {
      authProcess = AuthProcess.idle;
    }
  }

  @override
  Stream<QuerySnapshot<Object?>>? getParks(String vendorId) {
    var snapshot = authService.getParks(vendorId);
    listener = snapshot!.listen((event) {
      clear();

      for (var doc in event.docs) {
        Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
        ParkHistory park = ParkHistory.fromJson(map);
        if (park.status == StatusEnum.process) {
          activePark.add(park);
        } else if (park.status == StatusEnum.denied) {
          todayDeniedPark.add(park);
        } else if(park.status == StatusEnum.approval){
          approvalPark.add(park);
        } else {
          parkHistory.add(park);
          todayEarnings += park.totalPrice!;
        }
        todayParkCount++;
      }
      notifyListeners();
    });
    return snapshot;
  }

  @override
  Future<bool> setOpenHour(String openTime, String vendorId) async {
    try{
      authProcess = AuthProcess.busy;
      return await authService.setOpenHour(openTime, vendorId);
    } catch (e) {
      debugPrint(
        "VendorView - Exception - setOpenHour : ${e.toString()}",
      );
      return false;
    } finally {
      authProcess = AuthProcess.idle;
    }
  }
}
