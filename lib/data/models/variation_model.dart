// To parse this JSON data, do
//
//     final variationModel = variationModelFromJson(jsonString);

import 'dart:convert';

List<VariationModel> variationModelFromJson(String str) => List<VariationModel>.from(json.decode(str).map((x) => VariationModel.fromJson(x)));

String variationModelToJson(List<VariationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VariationModel {
  dynamic? id;
  String? name;
  double? price;
  dynamic? level;
  String? imageUrl;
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

  VariationModel({
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

  factory VariationModel.fromJson(Map<String, dynamic> json) => VariationModel(
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
