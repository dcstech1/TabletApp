// To parse this JSON data, do
//
//     final walkInModel = walkInModelFromJson(jsonString);

import 'dart:convert';

List<WalkInModel> walkInModelFromJson(String str) => List<WalkInModel>.from(json.decode(str).map((x) => WalkInModel.fromJson(x)));

String walkInModelToJson(List<WalkInModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WalkInModel{
  dynamic? productId;
  dynamic? categoryId;
  String? productName;
  String? productDescription;
  dynamic? imageUrl;
  String? imageUrl2;
  double? price;
  dynamic? prdynamicToKitchen1;
  dynamic? prdynamicToKitchen2;
  dynamic? prdynamicToKitchen3;
  dynamic? prdynamicToKitchen4;
  dynamic? prdynamicToKitchen5;
  dynamic? minQtySell;
  dynamic? validateMinQtySell;
  dynamic? maxQtySell;
  dynamic? validateMaxQtySell;
  dynamic? isPizza;
  dynamic? isDeal;
  dynamic? pizzasInDeal;
  dynamic? isCreateYourOwn;
  dynamic? taxId1;
  dynamic? taxId2;
  dynamic? taxId3;
  bool? kioskItem;
  String? status;
  List<dynamic>? productSpecialPricings;

  WalkInModel({
    this.productId,
    this.categoryId,
    this.productName,
    this.productDescription,
    this.imageUrl,
    this.imageUrl2,
    this.price,
    this.prdynamicToKitchen1,
    this.prdynamicToKitchen2,
    this.prdynamicToKitchen3,
    this.prdynamicToKitchen4,
    this.prdynamicToKitchen5,
    this.minQtySell,
    this.validateMinQtySell,
    this.maxQtySell,
    this.validateMaxQtySell,
    this.isPizza,
    this.isDeal,
    this.pizzasInDeal,
    this.isCreateYourOwn,
    this.taxId1,
    this.taxId2,
    this.taxId3,
    this.kioskItem,
    this.status,
    this.productSpecialPricings,
  });

  factory WalkInModel.fromJson(Map<String, dynamic> json) => WalkInModel(
    productId: json["productId"],
    categoryId: json["categoryId"],
    productName: json["productName"],
    productDescription: json["productDescription"],
    imageUrl: json["imageUrl"],
    imageUrl2: json["imageUrl2"],
    price: json["price"]?.toDouble(),
    prdynamicToKitchen1: json["prdynamicToKitchen1"],
    prdynamicToKitchen2: json["prdynamicToKitchen2"],
    prdynamicToKitchen3: json["prdynamicToKitchen3"],
    prdynamicToKitchen4: json["prdynamicToKitchen4"],
    prdynamicToKitchen5: json["prdynamicToKitchen5"],
    minQtySell: json["minQtySell"],
    validateMinQtySell: json["validateMinQtySell"],
    maxQtySell: json["maxQtySell"],
    validateMaxQtySell: json["validateMaxQtySell"],
    isPizza: json["isPizza"],
    isDeal: json["isDeal"],
    pizzasInDeal: json["pizzasInDeal"],
    isCreateYourOwn: json["isCreateYourOwn"],
    taxId1: json["taxId1"],
    taxId2: json["taxId2"],
    taxId3: json["taxId3"],
    kioskItem: json["kioskItem"],
    status: json["status"],
    productSpecialPricings: json["productSpecialPricings"] == null ? [] : List<dynamic>.from(json["productSpecialPricings"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "categoryId": categoryId,
    "productName": productName,
    "productDescription": productDescription,
    "imageUrl": imageUrl,
    "imageUrl2": imageUrl2,
    "price": price,
    "prdynamicToKitchen1": prdynamicToKitchen1,
    "prdynamicToKitchen2": prdynamicToKitchen2,
    "prdynamicToKitchen3": prdynamicToKitchen3,
    "prdynamicToKitchen4": prdynamicToKitchen4,
    "prdynamicToKitchen5": prdynamicToKitchen5,
    "minQtySell": minQtySell,
    "validateMinQtySell": validateMinQtySell,
    "maxQtySell": maxQtySell,
    "validateMaxQtySell": validateMaxQtySell,
    "isPizza": isPizza,
    "isDeal": isDeal,
    "pizzasInDeal": pizzasInDeal,
    "isCreateYourOwn": isCreateYourOwn,
    "taxId1": taxId1,
    "taxId2": taxId2,
    "taxId3": taxId3,
    "kioskItem": kioskItem,
    "status": status,
    "productSpecialPricings": productSpecialPricings == null ? [] : List<dynamic>.from(productSpecialPricings!.map((x) => x)),
  };
}
