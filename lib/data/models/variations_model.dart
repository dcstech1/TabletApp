// To parse this JSON data, do
//
//     final variationsModel = variationsModelFromJson(jsonString);

import 'dart:convert';

List<VariationsModel> variationsModelFromJson(String str) => List<VariationsModel>.from(json.decode(str).map((x) => VariationsModel.fromJson(x)));

String variationsModelToJson(List<VariationsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VariationsModel {
  List<Datum>? data;
  dynamic? qtyLevel;
  dynamic? mandatoryLevel;
  String? nameLevel;

  VariationsModel({
    this.data,
    this.qtyLevel,
    this.mandatoryLevel,
    this.nameLevel,
  });

  factory VariationsModel.fromJson(Map<String, dynamic> json) => VariationsModel(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    qtyLevel: json["qtyLevel"],
    mandatoryLevel: json["mandatoryLevel"],
    nameLevel: json["nameLevel"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "qtyLevel": qtyLevel,
    "mandatoryLevel": mandatoryLevel,
    "nameLevel": nameLevel,
  };
}

class Datum {
  dynamic? id;
  String? name;
  double? price;
  dynamic? level;
  dynamic imageUrl;
  String? imageUrl2;
  dynamic? variantParentId;
  dynamic? maxQuantity;
  bool? forced;
  dynamic? productId;
  bool? isFinalVariant;
  bool? isSubLevel;
  dynamic? quantity;
  dynamic? discount;
  String? discFromTime;
  String? discToTime;
  String? discDay;
  bool? enabled;

  Datum({
    this.id,
    this.name,
    this.price,
    this.level,
    this.imageUrl,
    this.imageUrl2,
    this.variantParentId,
    this.maxQuantity,
    this.forced,
    this.productId,
    this.isFinalVariant,
    this.isSubLevel,
    this.quantity,
    this.discount,
    this.discFromTime,
    this.discToTime,
    this.discDay,
    this.enabled,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    price: json["price"]?.toDouble(),
    level: json["level"],
    imageUrl: json["imageUrl"],
    imageUrl2: json["imageUrl2"],
    variantParentId: json["variantParentId"],
    maxQuantity: json["maxQuantity"],
    forced: json["forced"],
    productId: json["productId"],
    isFinalVariant: json["isFinalVariant"],
    isSubLevel: json["isSubLevel"],
    quantity: json["quantity"],
    discount: json["discount"],
    discFromTime: json["discFromTime"],
    discToTime: json["discToTime"],
    discDay: json["discDay"],
    enabled: json["enabled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "level": level,
    "imageUrl": imageUrl,
    "imageUrl2": imageUrl2,
    "variantParentId": variantParentId,
    "maxQuantity": maxQuantity,
    "forced": forced,
    "productId": productId,
    "isFinalVariant": isFinalVariant,
    "isSubLevel": isSubLevel,
    "quantity": quantity,
    "discount": discount,
    "discFromTime": discFromTime,
    "discToTime": discToTime,
    "discDay": discDay,
    "enabled": enabled,
  };
}
