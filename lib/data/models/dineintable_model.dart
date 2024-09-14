// To parse this JSON data, do
//
//     final dineInTableModel = dineInTableModelFromJson(jsonString);

import 'dart:convert';

List<DineInTableModel> dineInTableModelFromJson(String str) => List<DineInTableModel>.from(json.decode(str).map((x) => DineInTableModel.fromJson(x)));

String dineInTableModelToJson(List<DineInTableModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DineInTableModel {
  dynamic? id;
  String? name;
  String? tableDescription;
  dynamic? seatsNumber;
  Status? status;
  dynamic? row;
  dynamic? column;
  String? fontColor;
  String? bgColor;
  List<TableOrdersInfo>? tableOrdersInfo;

  DineInTableModel({
    this.id,
    this.name,
    this.tableDescription,
    this.seatsNumber,
    this.status,
    this.row,
    this.column,
    this.fontColor,
    this.bgColor,
    this.tableOrdersInfo,
  });

  factory DineInTableModel.fromJson(Map<String, dynamic> json) => DineInTableModel(
    id: json["id"],
    name: json["name"],
    tableDescription: json["tableDescription"],
    seatsNumber: json["seatsNumber"],
    status: statusValues.map[json["status"]]!,
    row: json["row"],
    column: json["column"],
    fontColor: json["fontColor"],
    bgColor: json["bgColor"],
    tableOrdersInfo: json["tableOrdersInfo"] == null ? [] : List<TableOrdersInfo>.from(json["tableOrdersInfo"]!.map((x) => TableOrdersInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "tableDescription": tableDescription,
    "seatsNumber": seatsNumber,
    "status": statusValues.reverse[status],
    "row": row,
    "column": column,
    "fontColor": fontColor,
    "bgColor": bgColor,
    "tableOrdersInfo": tableOrdersInfo == null ? [] : List<dynamic>.from(tableOrdersInfo!.map((x) => x.toJson())),
  };
}

enum Status {
  AVAILABLE,
  BOOKED
}

final statusValues = EnumValues({
  "available": Status.AVAILABLE,
  "booked": Status.BOOKED
});

class TableOrdersInfo {
  String? orderNo;
  String? userId;
  String? userName;

  TableOrdersInfo({
    this.orderNo,
    this.userId,
    this.userName,
  });

  factory TableOrdersInfo.fromJson(Map<String, dynamic> json) => TableOrdersInfo(
    orderNo: json["orderNo"],
    userId: json["userId"],
    userName: json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "orderNo": orderNo,
    "userId": userId,
    "userName": userName,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
