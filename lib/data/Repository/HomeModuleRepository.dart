import 'package:tabletapp/data/models/dineintable_model.dart';
import 'package:tabletapp/data/models/home_model.dart';
import 'package:tabletapp/data/models/clientdetail_model.dart';
import 'package:tabletapp/data/models/variation_model.dart';
import 'package:tabletapp/data/models/variations_model.dart';
import 'package:tabletapp/data/models/walkin_model.dart';
import 'package:tabletapp/presentation/screens/global.dart';
import 'package:tabletapp/utils/constant.dart';

import '../../core/network/network_manager.dart';
import '../../core/network/services.dart';
import '../models/recall_model.dart';
import '../models/submit_order.dart';
import '../models/tablegroup_model.dart';

class HomeRepository {
  final NetworkManager _networkManager = NetworkManager();

  Future<List<WalkInModel>> getWalkInCategories({int? pos}) async {
    try {
      Map<String, String> posMap = {'p': (pos ?? 1).toString() ?? ''};
      dynamic response =
          await _networkManager.request(ApiServices.walkIn, value: posMap);

      if (response is List<dynamic>) {
        // If the response is a list, convert each element to WalkInModel
        List<WalkInModel> walkInList = response.map((element) {
          return WalkInModel.fromJson(element);
        }).toList();

        return walkInList;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        return [WalkInModel.fromJson(response)];
      } else {
        print("Invalid response format");
        return [];
      }
    } catch (e) {
      print("getWalkInCategories Er: " + e.toString());
      return [];
    }
  }

  Future<List<DineInTableModel>> getDineInTableList({int? pos}) async {
    try {
      Map<String, String> posMap = {'id': (pos ?? 1).toString() ?? ''};
      dynamic response =
          await _networkManager.request(ApiServices.dineInTable, value: posMap);

      if (response is List<dynamic>) {
        // If the response is a list, convert each element to WalkInModel
        List<DineInTableModel> dineInList = response.map((element) {
          return DineInTableModel.fromJson(element);
        }).toList();

        return dineInList;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        return [DineInTableModel.fromJson(response)];
      } else {
        print("Invalid response format");
        return [];
      }
    } catch (e) {
      print("getDineInTableList Er: " + e.toString());
      return [];
    }
  }

// Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => orderFlow(walkInList[index])));

  Future<List<VariationsModel>> getVariation({int? id}) async {
    try {
      Map<String, String> posMap = {'id': (id ?? 1).toString() ?? ''};
      dynamic response =
          await _networkManager.request(ApiServices.variations, value: posMap);

      if (response is List<dynamic>) {
        List<VariationsModel> variationsList = response.map((element) {
          return VariationsModel.fromJson(element);
        }).toList();

        return variationsList;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        return [VariationsModel.fromJson(response)];
      } else {
        print("Invalid response format");
        return [];
      }
    } catch (e) {
      print("getWalkInCategories Er: " + e.toString());
      return [];
    }
  }

  Future<List<RecallModel>> getOrderlistForRecall(int? userId) async {
    try {
      Map<String, String> posMap = {'userId': (userId ?? 1).toString() ?? ''};
      dynamic response =
          await _networkManager.request(ApiServices.recall, value: posMap);

      if (response is List<dynamic>) {
        // If the response is a list, convert each element to RecallModel
        List<RecallModel> RecallModelList = response.map((element) {
          return RecallModel.fromJson(element);
        }).toList();

        print('RecallModelList size ${RecallModelList.length}');
        return RecallModelList;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        return [RecallModel.fromJson(response)];
      } else {
        print("Invalid response format");
        return [];
      }
    } catch (e) {
      print("getOrderlistForRecall Er: " + e.toString());
      return [];
    }
  }


  Future<List<RecallModel>> getOrderlistForBarTab(int? userId) async {
    try {
      Map<String, String> posMap = {'userId': (userId ?? 1).toString() ?? ''};
      dynamic response =
          await _networkManager.request(ApiServices.barTab, value: posMap);

      if (response is List<dynamic>) {
        // If the response is a list, convert each element to RecallModel
        List<RecallModel> RecallModelList = response.map((element) {
          return RecallModel.fromJson(element);
        }).toList();

        print('RecallModelList size ${RecallModelList.length}');
        return RecallModelList;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        return [RecallModel.fromJson(response)];
      } else {
        print("Invalid response format");
        return [];
      }
    } catch (e) {
      print("getOrderlistForRecall Er: " + e.toString());
      return [];
    }
  }

  Future<List<RecallModel>> getOrderlistForRecallDineIn(String? orderId) async {
    try {
      Map<String, String> posMap = {'orderId': (orderId ?? 1).toString() ?? ''};
      dynamic response = await _networkManager.request(ApiServices.recallDineIn,
          value: posMap);

      if (response is List<dynamic>) {
        // If the response is a list, convert each element to RecallModel
        List<RecallModel> RecallModelList = response.map((element) {
          return RecallModel.fromJson(element);
        }).toList();

        print('RecallModelList size ${RecallModelList.length}');
        return RecallModelList;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        return [RecallModel.fromJson(response)];
      } else {
        print("Invalid response format");
        return [];
      }
    } catch (e) {
      print("getOrderlistForRecall Er: " + e.toString());
      return [];
    }
  }


  Future<List<RecallModel>> getOrderlistForRecallDelivery() async {
    try {

      Map<String, String> clientIdValues = {'userId': (GlobalDala.cartPayNowDataList[Constant.userIdMain] ?? 1).toString() ?? ''};
      dynamic response = await _networkManager.request(ApiServices.recallDelivery,
          value: clientIdValues);

      if (response is List<dynamic>) {
        // If the response is a list, convert each element to RecallModel
        List<RecallModel> RecallModelList = response.map((element) {
          return RecallModel.fromJson(element);
        }).toList();

        print('RecallModelList size ${RecallModelList.length}');
        return RecallModelList;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        return [RecallModel.fromJson(response)];
      } else {
        print("Invalid response format");
        return [];
      }
    } catch (e) {
      print("getOrderlistForRecall Er: " + e.toString());
      return [];
    }
  }

  Future<ClientDetailModel?> getPickupClientDetailsFromPhoneNo(
      {String? phoneNo}) async {
    // Map<String, String>? headers;
    print('token $phoneNo');

    Map<String, String> phoneNoValues = {'phoneNo': phoneNo ?? ''};
    Map<String, dynamic> response = await _networkManager
        .request(ApiServices.pickupFromPhoneNo, value: phoneNoValues);

    print(
        "getPickupClientDetailsFromPhoneNo response = ${response.toString()}");
    if (response.containsKey('errorMessage')) {
      // throw Exception('Access code not found or invalid');
      // Alternatively, you can return null
      print(
          'getPickupClientDetailsFromPhoneNo err ${response.containsKey('errorMessage')}');
      return null;
    }

    return ClientDetailModel.fromJson(response);
  }

  Future<List<ClientDetailModel>> searchClientDetailsFromPhoneNo(
      {String? phoneNo}) async {
    // Map<String, String>? headers;
    try {
      Map<String, String> phoneNoValues = {'phoneNo': phoneNo ?? ''};
      dynamic response = await _networkManager
          .request(ApiServices.searchFromPhoneNo, value: phoneNoValues);

      if (response is List<dynamic>) {
        // If the response is a list, convert each element to RecallModel
        List<ClientDetailModel> RecallModelList = response.map((element) {
          return ClientDetailModel.fromJson(element);
        }).toList();

        print('RecallModelList size ${RecallModelList.length}');
        return RecallModelList;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        return [ClientDetailModel.fromJson(response)];
      } else {
        print("Invalid response format");
        return [];
      }
    } catch (e) {
      print("searchClientDetailsFromPhoneNo Er: " + e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> getDeliveryCharges(String? address) async {
    Map<String, String> addressValues = {'address': address ?? ''};
    Map<String, dynamic> response = await _networkManager
        .request(ApiServices.deliveryCharge, value: addressValues);

    print("getDeliveryCharges response = ${response.toString()}");

    return response;
  }

  Future<ClientDetailModel?> getPickupClientDetailsFromJsonDataWithClientId(
      {required Map<String, dynamic> body, String? clientId}) async {
    // Map<String, String>? headers;
    print('token $clientId');

    Map<String, String> clientIdValues = {'clientId': clientId ?? ''};
    Map<String, dynamic> response;

    if (GlobalDala.cartPayNowDataList[Constant.orderTypeMain] == "PICKUP") {
      response = await _networkManager.request(
          ApiServices.pickupFromJsonDataWithClientId,
          value: clientIdValues,
          body: body);
    } else {
      response = await _networkManager.request(
          ApiServices.deliveryFromJsonDataWithClientId,
          value: clientIdValues,
          body: body);
    }

    print(
        "getPickupClientDetailsFromJsonDataWithClientId response = ${response.toString()}");
    if (response.containsKey('errorMessage')) {
      // throw Exception('Access code not found or invalid');
      // Alternatively, you can return null
      print(
          'getPickupClientDetailsFromJsonDataWithClientId err ${response.containsKey('errorMessage')}');
      return null;
    }

    return ClientDetailModel.fromJson(response);
  }

  Future<ClientDetailModel?> getPickupClientDetailsFromJsonData(
      {required Map<String, dynamic> body}) async {
    //  Map<String, String> phoneNoValues = {'phoneNo': phoneNo ?? ''};
    Map<String, dynamic> response = await _networkManager
        .request(ApiServices.pickupFromJsonData, body: body);

    print(
        "getPickupClientDetailsFromJsonData response = ${response.toString()}");
    if (response.containsKey('errorMessage')) {
      // throw Exception('Access code not found or invalid');
      // Alternatively, you can return null
      print(
          'getPickupClientDetailsFromJsonData err ${response.containsKey('errorMessage')}');
      return null;
    }

    return ClientDetailModel.fromJson(response);
  }

  Future<dynamic?> postSubmitOrder({required Map<String, dynamic> body}) async {
    Map<String, dynamic> response =
        await _networkManager.request(ApiServices.submitOrder, body: body);

    print("postSubmitOrder response type: ${response.runtimeType} = $response");

    if (response is Map<String, dynamic> &&
        response.containsKey('errorMessage')) {
      print('postSubmitOrder error: ${response['errorMessage']}');
      return {'error': response['errorMessage']};
    } else if (response is String) {
      print('postSubmitOrder error: $response');
      return {'error': response};
    }

    return SubmitOrderModel.fromJson(response);
  }


  Future<dynamic?> postBarTabEdit({required Map<String, dynamic> body}) async {
    Map<String, dynamic> response =
        await _networkManager.request(ApiServices.barTabEdit, body: body);

    print("postSubmitOrder response type: ${response.runtimeType} = $response");

    if (response is Map<String, dynamic> &&
        response.containsKey('errorMessage')) {
      print('postSubmitOrder error: ${response['errorMessage']}');
      return {'error': response['errorMessage']};
    } else if (response is String) {
      print('postSubmitOrder error: $response');
      return {'error': response};
    }

    return SubmitOrderModel.fromJson(response);
  }

  Future<dynamic?> postPayment({required Map<String, dynamic> body}) async {
    Map<String, dynamic> response =
        await _networkManager.request(ApiServices.payment, body: body);

    print("postPayment response type: ${response.runtimeType} = $response");
    if (response is Map<String, dynamic> &&
        response.containsKey('errorMessage')) {
      print('postSubmitOrder error: ${response['errorMessage']}');
      return {'error': response['errorMessage']};
    } else if (response is String) {
      print('postSubmitOrder error: $response');
      return {'error': response};
    }
    else
      {
        return {"statusCode": "0000", "statusMessage": "Payment registered."};

      }
  }

  Future<dynamic> postVoidOrder({required Map<String, dynamic> body}) async {
    print("postSubmitOrder body type: ${body.runtimeType} = $body");

    final response = await _networkManager.request(
      ApiServices.voidOrder,
      body: body,
    );

    print("postSubmitOrder response type: ${response.runtimeType} = $response");

    if (response is Map<String, dynamic> &&
        response.containsKey('errorMessage')) {
      print('postSubmitOrder error: ${response['errorMessage']}');
      return {'error': response['errorMessage']};
    } else if (response is String) {
      print('postSubmitOrder error: $response');
      return {'error': response};
    }

    return SubmitOrderModel.fromJson(response);
  }

  Future<dynamic> postRecallDelivery({required Map<String, dynamic> body}) async {
    print("postRecallDelivery body type: ${body.runtimeType} = $body");

    final response = await _networkManager.request(
      ApiServices.recallDeliveryPost,
      body: body,
    );

    print("postRecallDelivery response type: ${response.runtimeType} = $response");


    if (response is Map<String, dynamic>) {
      if (response.containsKey('errorMessage')) {
        print('postRecallDelivery error: ${response['errorMessage']}');
        return {'error': response['errorMessage']};
      } else if (response.containsKey('statusCode') &&
          response['statusCode'] == '0000') {
        print('postRecallDelivery success: ${response['statusMessage']}');
        return {'success': response['statusMessage']};
      } else {
        print('postRecallDelivery unexpected response: $response');
        return {'error': 'Unexpected response format'};
      }
    } else if (response is String) {
      print('postRecallDelivery error: $response');
      return {'error': response};
    }

    return {'error': 'Unknown error occurred'};
  }

  /* Future<SubmitOrderModel?> postVoidOrder({required Map<String, dynamic> body}) async {

    print("postSubmitOrder  = $body}");

    Map<String, dynamic> response = await _networkManager
        .request(ApiServices.voidOrder, body: body);

    print("postSubmitOrder response = ${response.toString()}");
    if (response.containsKey('errorMessage')) {
      // throw Exception('Access code not found or invalid');
      // Alternatively, you can return null
      print('postSubmitOrder err ${response.containsKey('errorMessage')}');
      return null;
    }

    return SubmitOrderModel.fromJson(response);
  }*/

  Future<ClientDetailModel> getClientDetailFromTakeAway() async {
    try {
      Map<String, dynamic> response =
          await _networkManager.request(ApiServices.takeAway);

      return ClientDetailModel.fromJson(response);
    } catch (e) {
      print("GetOrder Er: " + e.toString());
      return new ClientDetailModel();
    }
  }

  Future<List<TableGroupModel>> getTableGroup() async {
    try {
      dynamic response = await _networkManager.request(ApiServices.tabelGroup);

      if (response is List<dynamic>) {
        List<TableGroupModel> tableGroupModelList = response.map((element) {
          return TableGroupModel.fromJson(element);
        }).toList();

        print('TableGroupModelList size ${tableGroupModelList.length}');
        return tableGroupModelList;
      } else if (response is Map<String, dynamic>) {
        if (response.containsKey('errorMessage')) {
          print("Error: ${response['errorMessage']}");
          return [];
        }
        return [TableGroupModel.fromJson(response)];
      } else {
        print("Invalid response format");
        return [];
      }
    } catch (e) {
      print("getTableGroupModel Er: " + e.toString());
      return [];
    }
  }
}
