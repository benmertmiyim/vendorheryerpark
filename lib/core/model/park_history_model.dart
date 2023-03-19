import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendor/core/model/enum.dart';

class ParkHistory {
  final DateTime requestTime;
  DateTime? closedTime;
  DateTime? replyTime;
  final String vendorId;
  final String requestId;
  final String customerName;
  final String customerImage;
  final String customerId;
  final String employeeId;
  final String employeeNameSurname;
  final String employeeImage;
  final String parkName;
  String? paymentId;
  String? closedReason;
  final List price;
  double? totalMins;
  double? totalPrice;
  StatusEnum status;

  ParkHistory({
    required this.requestTime,
    required this.vendorId,
    required this.requestId,
    required this.customerName,
    required this.customerImage,
    required this.customerId,
    required this.employeeId,
    required this.employeeNameSurname,
    required this.employeeImage,
    required this.parkName,
    required this.price,
    required this.status,
    this.closedTime,
    this.replyTime,
    this.paymentId,
    this.totalMins,
    this.totalPrice,
    this.closedReason,
  });

  factory ParkHistory.fromJson(Map<String, dynamic> json) {
    return ParkHistory(
      requestTime: (json["requestTime"] as Timestamp).toDate(),
      closedTime: json["closedTime"] != null
          ? (json["closedTime"] as Timestamp).toDate()
          : null,
      replyTime: json["replyTime"] != null
          ? (json["replyTime"] as Timestamp).toDate()
          : null,
      vendorId: json["vendorId"],
      requestId: json["requestId"],
      customerName: json["customerName"],
      customerImage: json["customerImage"] != null ? json["customerImage"] : "",
      customerId: json["customerId"],
      employeeId: json["employeeId"],
      employeeNameSurname: json["employeeNameSurname"],
      employeeImage: json["employeeImage"] != null ? json["employeeImage"] : "",
      parkName: json["parkName"],
      paymentId: json["paymentId"] != null ? json["paymentId"] : null,
      closedReason: json["closedReason"] != null ? json["closedReason"] : null,
      price: json["price"] as List,
      totalMins:
          json["totalMins"] != null ? json["totalMins"].toDouble() : null,
      totalPrice:
          json["totalPrice"] != null ? json["totalPrice"].toDouble() : null,
      status: statusFromString(json["status"]),
    );
  }
//

}
