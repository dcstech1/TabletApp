// To parse this JSON data, do
//
//     final userDetailsModel = userDetailsModelFromJson(jsonString);

import 'dart:convert';

UserDetailsModel userDetailsModelFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));

String userDetailsModelToJson(UserDetailsModel data) => json.encode(data.toJson());

class UserDetailsModel {
    int? id;
    String? userName;
    String? userFullName;
    int? isManager;
    int? isAdmin;
    int? isDriver;
    int? isStaffBankEnabled;
    String? staffBankStatus;
    String? token;

    UserDetailsModel({
        this.id,
        this.userName,
        this.userFullName,
        this.isManager,
        this.isAdmin,
        this.isDriver,
        this.isStaffBankEnabled,
        this.staffBankStatus,
        this.token,
    });

    factory UserDetailsModel.fromJson(Map<String, dynamic> json) => UserDetailsModel(
        id: json["id"],
        userName: json["userName"],
        userFullName: json["userFullName"],
        isManager: json["isManager"],
        isAdmin: json["isAdmin"],
        isDriver: json["isDriver"],
        isStaffBankEnabled: json["isStaffBankEnabled"],
        staffBankStatus: json["staffBankStatus"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "userFullName": userFullName,
        "isManager": isManager,
        "isAdmin": isAdmin,
        "isDriver": isDriver,
        "isStaffBankEnabled": isStaffBankEnabled,
        "staffBankStatus": staffBankStatus,
        "token": token,
    };
}
