import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendor/core/model/enum.dart';

class EmployeeModel {
  EmployeeModel({
    required this.employeeEmail,
    required this.employeePhoneNumber,
    required this.employeeImage,
    required this.employeeId,
    required this.createdAt,
    required this.verified,
    required this.employeeNameSurname,
    this.vendors,
  });

  @override
  String toString() {
    return 'EmployeeModel{employeeEmail: $employeeEmail, employeePhoneNumber: $employeePhoneNumber, employeeId: $employeeId, verified: $verified, createdAt: $createdAt, employeeNameSurname: $employeeNameSurname, vendors: $vendors}';
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    List<Vendors> vendorGen(var data) {
      List<Vendors> vendors = [];
      for (var vendor in data) {
        vendors.add(Vendors.fromJson(vendor));
      }
      return vendors;
    }
    return EmployeeModel(
      employeeEmail: json["employeeEmail"],
      employeePhoneNumber: json["employeePhoneNumber"],
      employeeImage: json["employeeImage"],
      employeeId: json["employeeId"],
      verified: json["verified"] as bool,
      createdAt: Timestamp(json["createdAt"]["_seconds"],json["createdAt"]["_nanoseconds"].toInt()).toDate(),
      employeeNameSurname: json["employeeNameSurname"],
      vendors: vendorGen(json['vendors']),
    );
  }

  String employeeEmail;
  String employeePhoneNumber;
  String employeeId;
  String employeeImage;
  bool verified;
  DateTime createdAt;
  String employeeNameSurname;
  List<Vendors>? vendors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['employeeEmail'] = employeeEmail;
    map['employeePhoneNumber'] = employeePhoneNumber;
    map['employeeId'] = employeeId;
    map['createdAt'] = createdAt;
    map['verified'] = verified;
    map['employeeImage'] = employeeImage;
    map['employeeNameSurname'] = employeeNameSurname;
    if (vendors != null) {
      map['vendors'] = vendors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Vendors {
  Vendors({
    required this.permission,
    required this.vendorId,
    required this.parkName,
    required this.active,
    required this.address,
  });

  factory Vendors.fromJson(Map<String, dynamic> json) {
    return Vendors(
      permission: permissionFromString(json["permission"]),
      vendorId: json["vendorId"],
      parkName: json["parkName"],
      active: json["active"] as bool,
      address: json["address"],
    );
  }

  PermissionEnum permission;
  String vendorId;
  String parkName;
  bool active;
  String address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['permission'] = permissionToString(permission);
    map['vendorId'] = vendorId;
    map['parkName'] = parkName;
    map['active'] = active;
    map['address'] = address;
    return map;
  }

  @override
  String toString() {
    return 'Vendors{permission: $permission, vendorId: $vendorId, parkName: $parkName, active: $active, address: $address}';
  }
}
