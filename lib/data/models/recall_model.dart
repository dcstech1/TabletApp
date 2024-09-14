// To parse this JSON data, do
//
//     final recallModel = recallModelFromJson(jsonString);

import 'dart:convert';

List<RecallModel> recallModelFromJson(String str) => List<RecallModel>.from(json.decode(str).map((x) => RecallModel.fromJson(x)));

String recallModelToJson(List<RecallModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RecallModel {
  dynamic? id;
  dynamic? orderNumber;
  dynamic? tokenNumber;
  String? orderType;
  String? paymentType;
  dynamic? clientId;
  dynamic? userId;
  dynamic driverId;
  dynamic? tableId;
  String? drivername;
  String? serverName;
  String? tableName;
  String? tableInfo;
  String? guestNo;
  String? clientName;
  String? phoneNumber;
  String? address;
  String? unit;
  String? buzzer;
  dynamic? deliveryCharge;
  String? orderDate;
  String? orderTime;
  String? onDate;
  String? onTime;
  dynamic serviceChargePercentage;
  dynamic serviceCharge;
  dynamic? subTotal;
  dynamic? taxId1;
  dynamic? taxId2;
  dynamic? taxId3;
  dynamic? taxId4;
  dynamic? taxId5;
  dynamic? taxId6;
  double? totalTax1;
  dynamic? totalTax2;
  dynamic? totalTax3;
  dynamic? totalTax4;
  dynamic? totalTax5;
  dynamic? totalTax6;
  double? orderTotal;
  String? status;
  dynamic shiftId;
  dynamic locId;
  dynamic? stationId;
  bool? isPaid;
  List<OrderDetail>? orderDetails;

  RecallModel({
    this.id,
    this.orderNumber,
    this.tokenNumber,
    this.orderType,
    this.paymentType,
    this.clientId,
    this.userId,
    this.driverId,
    this.tableId,
    this.drivername,
    this.serverName,
    this.tableName,
    this.tableInfo,
    this.guestNo,
    this.clientName,
    this.phoneNumber,
    this.address,
    this.unit,
    this.buzzer,
    this.deliveryCharge,
    this.orderDate,
    this.orderTime,
    this.onDate,
    this.onTime,
    this.serviceChargePercentage,
    this.serviceCharge,
    this.subTotal,
    this.taxId1,
    this.taxId2,
    this.taxId3,
    this.taxId4,
    this.taxId5,
    this.taxId6,
    this.totalTax1,
    this.totalTax2,
    this.totalTax3,
    this.totalTax4,
    this.totalTax5,
    this.totalTax6,
    this.orderTotal,
    this.status,
    this.shiftId,
    this.locId,
    this.stationId,
    this.isPaid,
    this.orderDetails,
  });

  factory RecallModel.fromJson(Map<String, dynamic> json) => RecallModel(
    id: json["id"],
    orderNumber: json["orderNumber"],
    tokenNumber: json["tokenNumber"],
    orderType: json["orderType"],
    paymentType: json["paymentType"],
    clientId: json["clientId"],
    userId: json["userId"],
    driverId: json["driverId"],
    tableId: json["tableId"],
    drivername: json["drivername"],
    serverName: json["serverName"],
    tableName: json["tableName"],
    tableInfo: json["tableInfo"],
    guestNo: json["guestNo"],
    clientName: json["clientName"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    unit: json["unit"],
    buzzer: json["buzzer"],
    deliveryCharge: json["deliveryCharge"],
    orderDate: json["orderDate"],
    orderTime: json["orderTime"],
    onDate: json["onDate"],
    onTime: json["onTime"],
    serviceChargePercentage: json["serviceChargePercentage"],
    serviceCharge: json["serviceCharge"],
    subTotal: json["subTotal"],
    taxId1: json["taxId1"],
    taxId2: json["taxId2"],
    taxId3: json["taxId3"],
    taxId4: json["taxId4"],
    taxId5: json["taxId5"],
    taxId6: json["taxId6"],
    totalTax1: json["totalTax1"]?.toDouble(),
    totalTax2: json["totalTax2"],
    totalTax3: json["totalTax3"],
    totalTax4: json["totalTax4"],
    totalTax5: json["totalTax5"],
    totalTax6: json["totalTax6"],
    orderTotal: json["orderTotal"]?.toDouble(),
    status: json["status"],
    shiftId: json["shiftId"],
    locId: json["locId"],
    stationId: json["stationId"],
    isPaid: json["isPaid"],
    orderDetails: json["orderDetails"] == null ? [] : List<OrderDetail>.from(json["orderDetails"]!.map((x) => OrderDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderNumber": orderNumber,
    "tokenNumber": tokenNumber,
    "orderType": orderType,
    "paymentType": paymentType,
    "clientId": clientId,
    "userId": userId,
    "driverId": driverId,
    "tableId": tableId,
    "drivername": drivername,
    "serverName": serverName,
    "tableName": tableName,
    "tableInfo": tableInfo,
    "guestNo": guestNo,
    "clientName": clientName,
    "phoneNumber": phoneNumber,
    "address": address,
    "unit": unit,
    "buzzer": buzzer,
    "deliveryCharge": deliveryCharge,
    "orderDate": orderDate,
    "orderTime": orderTime,
    "onDate": onDate,
    "onTime": onTime,
    "serviceChargePercentage": serviceChargePercentage,
    "serviceCharge": serviceCharge,
    "subTotal": subTotal,
    "taxId1": taxId1,
    "taxId2": taxId2,
    "taxId3": taxId3,
    "taxId4": taxId4,
    "taxId5": taxId5,
    "taxId6": taxId6,
    "totalTax1": totalTax1,
    "totalTax2": totalTax2,
    "totalTax3": totalTax3,
    "totalTax4": totalTax4,
    "totalTax5": totalTax5,
    "totalTax6": totalTax6,
    "orderTotal": orderTotal,
    "status": status,
    "shiftId": shiftId,
    "locId": locId,
    "stationId": stationId,
    "isPaid": isPaid,
    "orderDetails": orderDetails == null ? [] : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
  };
}

class OrderDetail {
  dynamic? id;
  dynamic? orderId;
  dynamic? lineNo;
  dynamic? productId;
  String? name;
  dynamic? quantity;
  double? price;
  double? actualprice;
  double? totalUnitPrice;
  double? variationsPrice;
  dynamic? subTotal;
  String? fullDescription;
  dynamic secondaryDescription;
  dynamic? printToKitchen1;
  dynamic? printToKitchen2;
  dynamic? printToKitchen3;
  dynamic? printToKitchen4;
  dynamic? printToKitchen5;
  dynamic? taxId1;
  dynamic? taxId2;
  dynamic? taxId3;
  dynamic? taxId4;
  dynamic? taxId5;
  dynamic? taxId6;
  dynamic? taxRate1;
  dynamic? taxRate2;
  dynamic? taxRate3;
  dynamic? taxRate4;
  dynamic? taxRate5;
  dynamic? taxRate6;
  double? taxPerUnit1;
  dynamic? taxPerUnit2;
  dynamic? taxPerUnit3;
  dynamic? taxPerUnit4;
  dynamic? taxPerUnit5;
  dynamic? taxPerUnit6;
  double? totalTax1;
  dynamic? totalTax2;
  dynamic? totalTax3;
  dynamic? totalTax4;
  dynamic? totalTax5;
  dynamic? totalTax6;
  double? itemTotal;
  String? status;
  List<SelectedItemsLevel>? selectedItemsLevel;

  OrderDetail({
    this.id,
    this.orderId,
    this.lineNo,
    this.productId,
    this.name,
    this.quantity,
    this.price,
    this.actualprice,
    this.totalUnitPrice,
    this.variationsPrice,
    this.subTotal,
    this.fullDescription,
    this.secondaryDescription,
    this.printToKitchen1,
    this.printToKitchen2,
    this.printToKitchen3,
    this.printToKitchen4,
    this.printToKitchen5,
    this.taxId1,
    this.taxId2,
    this.taxId3,
    this.taxId4,
    this.taxId5,
    this.taxId6,
    this.taxRate1,
    this.taxRate2,
    this.taxRate3,
    this.taxRate4,
    this.taxRate5,
    this.taxRate6,
    this.taxPerUnit1,
    this.taxPerUnit2,
    this.taxPerUnit3,
    this.taxPerUnit4,
    this.taxPerUnit5,
    this.taxPerUnit6,
    this.totalTax1,
    this.totalTax2,
    this.totalTax3,
    this.totalTax4,
    this.totalTax5,
    this.totalTax6,
    this.itemTotal,
    this.status,
    this.selectedItemsLevel,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    id: json["id"],
    orderId: json["orderId"],
    lineNo: json["lineNo"],
    productId: json["productId"],
    name: json["name"],
    quantity: json["quantity"],
    price: json["price"]?.toDouble(),
    actualprice: json["actualprice"]?.toDouble(),
    totalUnitPrice: json["totalUnitPrice"]?.toDouble(),
    variationsPrice: json["variationsPrice"]?.toDouble(),
    subTotal: json["subTotal"],
    fullDescription: json["fullDescription"],
    secondaryDescription: json["secondaryDescription"],
    printToKitchen1: json["printToKitchen1"],
    printToKitchen2: json["printToKitchen2"],
    printToKitchen3: json["printToKitchen3"],
    printToKitchen4: json["printToKitchen4"],
    printToKitchen5: json["printToKitchen5"],
    taxId1: json["taxId1"],
    taxId2: json["taxId2"],
    taxId3: json["taxId3"],
    taxId4: json["taxId4"],
    taxId5: json["taxId5"],
    taxId6: json["taxId6"],
    taxRate1: json["taxRate1"],
    taxRate2: json["taxRate2"],
    taxRate3: json["taxRate3"],
    taxRate4: json["taxRate4"],
    taxRate5: json["taxRate5"],
    taxRate6: json["taxRate6"],
    taxPerUnit1: json["taxPerUnit1"]?.toDouble(),
    taxPerUnit2: json["taxPerUnit2"],
    taxPerUnit3: json["taxPerUnit3"],
    taxPerUnit4: json["taxPerUnit4"],
    taxPerUnit5: json["taxPerUnit5"],
    taxPerUnit6: json["taxPerUnit6"],
    totalTax1: json["totalTax1"]?.toDouble(),
    totalTax2: json["totalTax2"],
    totalTax3: json["totalTax3"],
    totalTax4: json["totalTax4"],
    totalTax5: json["totalTax5"],
    totalTax6: json["totalTax6"],
    itemTotal: json["itemTotal"]?.toDouble(),
    status: json["status"],
    selectedItemsLevel: json["selectedItemsLevel"] == null ? [] : List<SelectedItemsLevel>.from(json["selectedItemsLevel"]!.map((x) => SelectedItemsLevel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "lineNo": lineNo,
    "productId": productId,
    "name": name,
    "quantity": quantity,
    "price": price,
    "actualprice": actualprice,
    "totalUnitPrice": totalUnitPrice,
    "variationsPrice": variationsPrice,
    "subTotal": subTotal,
    "fullDescription": fullDescription,
    "secondaryDescription": secondaryDescription,
    "printToKitchen1": printToKitchen1,
    "printToKitchen2": printToKitchen2,
    "printToKitchen3": printToKitchen3,
    "printToKitchen4": printToKitchen4,
    "printToKitchen5": printToKitchen5,
    "taxId1": taxId1,
    "taxId2": taxId2,
    "taxId3": taxId3,
    "taxId4": taxId4,
    "taxId5": taxId5,
    "taxId6": taxId6,
    "taxRate1": taxRate1,
    "taxRate2": taxRate2,
    "taxRate3": taxRate3,
    "taxRate4": taxRate4,
    "taxRate5": taxRate5,
    "taxRate6": taxRate6,
    "taxPerUnit1": taxPerUnit1,
    "taxPerUnit2": taxPerUnit2,
    "taxPerUnit3": taxPerUnit3,
    "taxPerUnit4": taxPerUnit4,
    "taxPerUnit5": taxPerUnit5,
    "taxPerUnit6": taxPerUnit6,
    "totalTax1": totalTax1,
    "totalTax2": totalTax2,
    "totalTax3": totalTax3,
    "totalTax4": totalTax4,
    "totalTax5": totalTax5,
    "totalTax6": totalTax6,
    "itemTotal": itemTotal,
    "status": status,
    "selectedItemsLevel": selectedItemsLevel == null ? [] : List<dynamic>.from(selectedItemsLevel!.map((x) => x.toJson())),
  };
}

class SelectedItemsLevel {
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

  SelectedItemsLevel({
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

  factory SelectedItemsLevel.fromJson(Map<String, dynamic> json) => SelectedItemsLevel(
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
