// To parse this JSON data, do
//
//     final tableGroupModel = tableGroupModelFromJson(jsonString);

import 'dart:convert';

List<TableGroupModel> tableGroupModelFromJson(String str) => List<TableGroupModel>.from(json.decode(str).map((x) => TableGroupModel.fromJson(x)));

String tableGroupModelToJson(List<TableGroupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TableGroupModel {
  int? id;
  String? name;

  TableGroupModel({
    this.id,
    this.name,
  });

  factory TableGroupModel.fromJson(Map<String, dynamic> json) => TableGroupModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
