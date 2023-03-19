import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendor/core/model/enum.dart';

class VendorModel {
  final String vendorId;
  final String parkName;
  final String address;
  final String iban;
  final String vkn;
  final DateTime createdAt;
  final double accessibility;
  final double rating;
  final double security;
  final double serviceQuality;
  final double latitude;
  final double longitude;
  PermissionEnum? permission;
  bool active;
  String openTime;
  String closeTime;
  List imgList;
  List price;

  VendorModel({
    required this.vendorId,
    required this.accessibility,
    required this.active,
    required this.address,
    required this.closeTime,
    required this.createdAt,
    required this.iban,
    required this.imgList,
    required this.latitude,
    required this.longitude,
    required this.openTime,
    required this.parkName,
    required this.rating,
    required this.security,
    required this.serviceQuality,
    required this.price,
    required this.vkn,
     this.permission,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      vendorId: json["vendorId"],
      parkName: json["parkName"],
      address: json["address"],
      iban: json["iban"],
      vkn: json["vkn"],
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      accessibility: json["accessibility"].toDouble(),
      rating: json["rating"].toDouble(),
      security: json["security"].toDouble(),
      serviceQuality: json["serviceQuality"].toDouble(),
      latitude: json["latitude"].toDouble(),
      longitude: json["longitude"].toDouble(),
      active: json["active"]as bool,
      openTime: json["openTime"],
      closeTime: json["closeTime"],
      imgList: json["imgList"] as List,
      price: json["price"] as List,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "vendorId": this.vendorId,
      "parkName": this.parkName,
      "address": this.address,
      "iban": this.iban,
      "vkn": this.vkn,
      "createdAt": this.createdAt,
      "accessibility": this.accessibility,
      "rating": this.rating,
      "security": this.security,
      "serviceQuality": this.serviceQuality,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "active": this.active,
      "openTime": this.openTime,
      "closeTime": this.closeTime,
      "imgList": this.imgList,
      "price": this.price,
    };
  }
}
