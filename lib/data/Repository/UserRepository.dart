import 'package:tabletapp/data/models/home_model.dart';

import '../../core/network/network_manager.dart';
import '../../core/network/services.dart';
import '../models/user_details_model.dart';
import 'dart:developer';

class UserRepository {
  final NetworkManager _networkManager = NetworkManager();

  Future<UserDetailsModel?> getloginAccess({String? codeAccess}) async {
    // Map<String, String>? headers;
    print('token $codeAccess');

    Map<String, String> accessCodeValues = {'accesscode': codeAccess ?? ''};
    Map<String, dynamic> response = await _networkManager
        .request(ApiServices.loginAccess, value: accessCodeValues);

    print("Login user response = ${response.toString()}");
    if (response.containsKey('errorMessage')) {
      // throw Exception('Access code not found or invalid');
      // Alternatively, you can return null
      return null;
    }

    return UserDetailsModel.fromJson(response);
  }

  Future<dynamic> getOrderType() async {
    try {
      /*  print('response : ${await _networkManager
          .request(ApiServices.getOrderType)}');*/
      final response  =
          await _networkManager.request(ApiServices.getOrderType);
      if (response is Map<String, dynamic> && response.containsKey('errorMessage')) {
        print('postSubmitOrder error: ${response['errorMessage']}');
        return {'error': response['errorMessage']};
      } else if (response is String) {
        print('postSubmitOrder error: $response');
        return {'error': response};
      }

      return HomeModel.fromJson(response);


      /* if (response is Map<String, dynamic> && response.containsKey('errorMessage')) {
      print('postSubmitOrder error: ${response['errorMessage']}');
      return {'error': response['errorMessage']};
    } else if (response is String) {
      print('postSubmitOrder error: $response');
      return {'error': response};
    }

    return SubmitOrderModel.fromJson(response);*/


    } catch (e) {
      print("GetOrder Er: " + e.toString());
      return new HomeModel();
    }
  }
}
