// To parse this JSON data, do
//
//     final submitOrderModel = submitOrderModelFromJson(jsonString);

import 'dart:convert';

SubmitOrderModel submitOrderModelFromJson(String str) => SubmitOrderModel.fromJson(json.decode(str));

String submitOrderModelToJson(SubmitOrderModel data) => json.encode(data.toJson());

class SubmitOrderModel {
  String? tokenCode;
  dynamic? orderNumber;
  String? statusCode;
  String? statusMessage;

  SubmitOrderModel({
    this.tokenCode,
    this.orderNumber,
    this.statusCode,
    this.statusMessage,
  });

  factory SubmitOrderModel.fromJson(Map<String, dynamic> json) => SubmitOrderModel(
    tokenCode: json["tokenCode"],
    orderNumber: json["orderNumber"],
    statusCode: json["statusCode"],
    statusMessage: json["statusMessage"],
  );

  Map<String, dynamic> toJson() => {
    "tokenCode": tokenCode,
    "orderNumber": orderNumber,
    "statusCode": statusCode,
    "statusMessage": statusMessage,
  };
}
