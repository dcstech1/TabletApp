// To parse this JSON data, do
//
//     final homeModel = homeModelFromJson(jsonString);

import 'dart:convert';

HomeModel homeModelFromJson(String str) => HomeModel.fromJson(json.decode(str));

String homeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  List<Tax>? taxes;
  List<Category>? categories;
  Settings? settings;
  List<dynamic>? paymodes;
  String? companyName;
  String? compdaystart;
  dynamic? deliveryTime;
  dynamic? pickUpTime;
  dynamic? maxServerAllowed;
  dynamic? maxUserAllowed;
  dynamic? deliveryCharge;
  String? imgFolder;
  dynamic? applyServiceCharge;
  dynamic? serviceChargeAmount;
  dynamic? chargeNumberOfGuests;
  dynamic? stationId;
  dynamic? shiftId;
  dynamic? locId;
  dynamic? walkInCustId;
  dynamic? extraAmtAsTip;
  dynamic? dontAllowOverExtraTip;
  dynamic? promptExtraCashAsTip;
  dynamic? overExtraTip;
  dynamic? cashTipOption;
  dynamic? displayAllUserOrder;
  dynamic? displayAllOrder;
  dynamic? applydeliverychargesaskm;
  dynamic? applytakeoutdeliveryprice;
  dynamic? applydeliveryonorderkm;
  dynamic? minimumdeliveryorder;
  dynamic? trackByID;

  HomeModel({
    this.taxes,
    this.categories,
    this.settings,
    this.paymodes,
    this.companyName,
    this.compdaystart,
    this.deliveryTime,
    this.pickUpTime,
    this.maxServerAllowed,
    this.maxUserAllowed,
    this.deliveryCharge,
    this.imgFolder,
    this.applyServiceCharge,
    this.serviceChargeAmount,
    this.chargeNumberOfGuests,
    this.stationId,
    this.shiftId,
    this.locId,
    this.walkInCustId,
    this.extraAmtAsTip,
    this.dontAllowOverExtraTip,
    this.promptExtraCashAsTip,
    this.overExtraTip,
    this.cashTipOption,
    this.displayAllUserOrder,
    this.displayAllOrder,
    this.applydeliverychargesaskm,
    this.applytakeoutdeliveryprice,
    this.applydeliveryonorderkm,
    this.minimumdeliveryorder,
    this.trackByID,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    taxes: json["taxes"] == null ? [] : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
    categories: json["categories"] == null ? [] : List<Category>.from(json["categories"]!.map((x) => Category.fromJson(x))),
    settings: json["settings"] == null ? null : Settings.fromJson(json["settings"]),
    paymodes: json["paymodes"] == null ? [] : List<dynamic>.from(json["paymodes"]!.map((x) => x)),
    companyName: json["companyName"],
    compdaystart: json["compdaystart"],
    deliveryTime: json["deliveryTime"],
    pickUpTime: json["pickUpTime"],
    maxServerAllowed: json["maxServerAllowed"],
    maxUserAllowed: json["maxUserAllowed"],
    deliveryCharge: json["deliveryCharge"],
    imgFolder: json["imgFolder"],
    applyServiceCharge: json["applyServiceCharge"],
    serviceChargeAmount: json["serviceChargeAmount"],
    chargeNumberOfGuests: json["chargeNumberOfGuests"],
    stationId: json["stationId"],
    shiftId: json["shiftId"],
    locId: json["locId"],
    walkInCustId: json["walkInCustId"],
    extraAmtAsTip: json["extraAmtAsTip"],
    dontAllowOverExtraTip: json["dontAllowOverExtraTip"],
    promptExtraCashAsTip: json["promptExtraCashAsTip"],
    overExtraTip: json["overExtraTip"],
    cashTipOption: json["cashTipOption"],
    displayAllUserOrder: json["displayAllUserOrder"],
    displayAllOrder: json["displayAllOrder"],
    applydeliverychargesaskm: json["applydeliverychargesaskm"],
    applytakeoutdeliveryprice: json["applytakeoutdeliveryprice"],
    applydeliveryonorderkm: json["applydeliveryonorderkm"],
    minimumdeliveryorder: json["minimumdeliveryorder"],
    trackByID: json["trackByID"],
  );

  Map<String, dynamic> toJson() => {
    "taxes": taxes == null ? [] : List<dynamic>.from(taxes!.map((x) => x.toJson())),
    "categories": categories == null ? [] : List<dynamic>.from(categories!.map((x) => x.toJson())),
    "settings": settings?.toJson(),
    "paymodes": paymodes == null ? [] : List<dynamic>.from(paymodes!.map((x) => x)),
    "companyName": companyName,
    "compdaystart": compdaystart,
    "deliveryTime": deliveryTime,
    "pickUpTime": pickUpTime,
    "maxServerAllowed": maxServerAllowed,
    "maxUserAllowed": maxUserAllowed,
    "deliveryCharge": deliveryCharge,
    "imgFolder": imgFolder,
    "applyServiceCharge": applyServiceCharge,
    "serviceChargeAmount": serviceChargeAmount,
    "chargeNumberOfGuests": chargeNumberOfGuests,
    "stationId": stationId,
    "shiftId": shiftId,
    "locId": locId,
    "walkInCustId": walkInCustId,
    "extraAmtAsTip": extraAmtAsTip,
    "dontAllowOverExtraTip": dontAllowOverExtraTip,
    "promptExtraCashAsTip": promptExtraCashAsTip,
    "overExtraTip": overExtraTip,
    "cashTipOption": cashTipOption,
    "displayAllUserOrder": displayAllUserOrder,
    "displayAllOrder": displayAllOrder,
    "applydeliverychargesaskm": applydeliverychargesaskm,
    "applytakeoutdeliveryprice": applytakeoutdeliveryprice,
    "applydeliveryonorderkm": applydeliveryonorderkm,
    "minimumdeliveryorder": minimumdeliveryorder,
    "trackByID": trackByID,
  };
}

class Category {
  dynamic? id;
  String? categoryDescription;
  String? imageUrl;
  String? categoryGroup;
  Enabled? enabled;
  dynamic tsindex;
  dynamic? isIngredient;
  String? secondarylang;
  dynamic? isdisableontime;
  String? disableFromTime;
  String? disableToTime;
  String? disableDay;
  dynamic? isEnabledOnTime;
  dynamic? allowDisc;
  dynamic? discount;
  dynamic? dealforpizza;
  dynamic? dealBuyItem;
  dynamic? dealondisc;
  bool? kioskEnabled;

  Category({
    this.id,
    this.categoryDescription,
    this.imageUrl,
    this.categoryGroup,
    this.enabled,
    this.tsindex,
    this.isIngredient,
    this.secondarylang,
    this.isdisableontime,
    this.disableFromTime,
    this.disableToTime,
    this.disableDay,
    this.isEnabledOnTime,
    this.allowDisc,
    this.discount,
    this.dealforpizza,
    this.dealBuyItem,
    this.dealondisc,
    this.kioskEnabled,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    categoryDescription: json["categoryDescription"],
    imageUrl: json["imageUrl"],
    categoryGroup: json["categoryGroup"],
    enabled: enabledValues.map[json["enabled"]]!,
    tsindex: json["tsindex"],
    isIngredient: json["isIngredient"],
    secondarylang: json["secondarylang"],
    isdisableontime: json["isdisableontime"],
    disableFromTime: json["disableFromTime"],
    disableToTime: json["disableToTime"],
    disableDay: json["disableDay"],
    isEnabledOnTime: json["isEnabledOnTime"],
    allowDisc: json["allowDisc"],
    discount: json["discount"],
    dealforpizza: json["dealforpizza"],
    dealBuyItem: json["dealBuyItem"],
    dealondisc: json["dealondisc"],
    kioskEnabled: json["kioskEnabled"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryDescription": categoryDescription,
    "imageUrl": imageUrl,
    "categoryGroup": categoryGroup,
    "enabled": enabledValues.reverse[enabled],
    "tsindex": tsindex,
    "isIngredient": isIngredient,
    "secondarylang": secondarylang,
    "isdisableontime": isdisableontime,
    "disableFromTime": disableFromTime,
    "disableToTime": disableToTime,
    "disableDay": disableDay,
    "isEnabledOnTime": isEnabledOnTime,
    "allowDisc": allowDisc,
    "discount": discount,
    "dealforpizza": dealforpizza,
    "dealBuyItem": dealBuyItem,
    "dealondisc": dealondisc,
    "kioskEnabled": kioskEnabled,
  };
}

enum Enabled {
  Y
}

final enabledValues = EnumValues({
  "Y": Enabled.Y
});

class Settings {
  String? olTableDelivery;
  String? olTableTakeOut;
  String? olTableDineIn;
  String? olTableDriveThru;
  String? olTableTOGO;
  String? olTableToStay;
  String? oLTableBarTab;

  Settings({
    this.olTableDelivery,
    this.olTableDineIn,
    this.olTableTakeOut,
    this.olTableDriveThru,
    this.olTableTOGO,
    this.olTableToStay,
    this.oLTableBarTab,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    olTableDelivery: json["OLTableDelivery"],
    olTableDineIn: json["OLTableDineIn"],
    olTableTakeOut: json["OLTableTakeOut"],
    olTableDriveThru: json["OLTableDriveThru"],
    olTableTOGO: json["OLTableTOGO"],
    olTableToStay: json["OLTableToStay"],
    oLTableBarTab: json["OLTableBarTab"],
  );

  Map<String, dynamic> toJson() => {


    "OLTableDelivery": olTableDelivery,
    "OLTableDineIn": olTableDineIn,
    "OLTableTakeOut": olTableTakeOut,

    "OLTableDriveThru": olTableDriveThru,
    "OLTableTOGO": olTableTOGO,
    "OLTableToStay": olTableToStay,
    "OLTableBarTab": oLTableBarTab
  };
}
class Paymode {
  String? name;
  String? changeName;
  int? disable;
  int? dontpay;

  Paymode({
    this.name,
    this.changeName,
    this.disable,
    this.dontpay,
  });

  factory Paymode.fromJson(Map<String, dynamic> json) => Paymode(
    name: json["name"],
    changeName: json["changeName"],
    disable: json["disable"],
    dontpay: json["dontpay"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "changeName": changeName,
    "disable": disable,
    "dontpay": dontpay,
  };
}
class Tax {
  dynamic? id;
  String? name;
  dynamic? rate;
  dynamic? total;
  Enabled? enabled;

  Tax({
    this.id,
    this.name,
    this.rate,
    this.total,
    this.enabled,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
    id: json["id"],
    name: json["name"],
    rate: json["rate"],
    total: json["total"],
    enabled: enabledValues.map[json["enabled"]]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "rate": rate,
    "total": total,
    "enabled": enabledValues.reverse[enabled],
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
