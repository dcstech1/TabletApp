// To parse this JSON data, do
//
//     final pickupClientDetailModel = pickupClientDetailModelFromJson(jsonString);

import 'dart:convert';

ClientDetailModel pickupClientDetailModelFromJson(String str) => ClientDetailModel.fromJson(json.decode(str));

String pickupClientDetailModelToJson(ClientDetailModel data) => json.encode(data.toJson());

class ClientDetailModel {
  dynamic? clientId;
  dynamic suitNo;
  dynamic buzzerNo;
  dynamic roomNo;
  String? firstName;
  String? lastName;
  dynamic address;
  String? phoneNo;
  String? enabled;
  String? deleted;

  ClientDetailModel({
    this.clientId,
    this.suitNo,
    this.buzzerNo,
    this.roomNo,
    this.firstName,
    this.lastName,
    this.address,
    this.phoneNo,
    this.enabled,
    this.deleted,
  });

  factory ClientDetailModel.fromJson(Map<String, dynamic> json) => ClientDetailModel(
    clientId: json["clientId"],
    suitNo: json["suitNo"],
    buzzerNo: json["buzzerNo"],
    roomNo: json["roomNo"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    address: json["address"],
    phoneNo: json["phoneNo"],
    enabled: json["enabled"],
    deleted: json["deleted"],
  );

  Map<String, dynamic> toJson() => {
    "clientId": clientId,
    "suitNo": suitNo,
    "buzzerNo": buzzerNo,
    "roomNo": roomNo,
    "firstName": firstName,
    "lastName": lastName,
    "address": address,
    "phoneNo": phoneNo,
    "enabled": enabled,
    "deleted": deleted,
  };
}
