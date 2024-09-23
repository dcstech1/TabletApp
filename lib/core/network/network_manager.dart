import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tabletapp/core/network/services.dart';
import 'package:tabletapp/presentation/screens/global.dart';

import '../sharedPrefrences/shared_preference.dart'; /*
import 'package:orbnite/core/network/services.dart';
import 'package:orbnite/core/sharedPrefrence/shared_preference.dart';
*/

class NetworkManager {
  //final String baseUrl = 'http://192.168.1.3:18080/api';
  //final String baseUrl = 'https://onlinefoodordering.ca/RangerAPI/SelfServKiosk/api';
  final String baseUrl = GlobalDala.baseUrl;
  //final String baseUrl = 'https://onlinefoodordering.ca/RangerAPI/KioskUstaadG/api';
  //final String baseUrl = 'https://onlinefoodordering.ca/RangerAPI/Kioskindianaccent/api';  //0808


  String interpolateEndPoint(String endPoint, Map<String, String> urlValues) {
    for (var key in urlValues.keys) {
      if (endPoint.contains('\$$key')) {
        String? value = urlValues[key];
        if (value != null) {
          endPoint = endPoint.replaceAll('\$$key', value);
        }
      }
    }
    return endPoint;
  }

  Future<dynamic> request(ApiServices apiService,
      {Map<String, String>? headers,
      dynamic body,
      Map<String, String>? value,
      bool shouldFetchLocalToken = false}) async {
    Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    headers?.forEach((key, value) {
      defaultHeaders[key] = value;
    });
    if (shouldFetchLocalToken) {
      String token = await SharedPreferencesHelper.getToken() ?? '';
      defaultHeaders['Authorization'] = 'Bearer $token';
    }


    print("request body type: ${body.runtimeType} = $body");
    http.Response response;
    Uri? url;
    print(apiService.name);
    if (apiService.shouldInterpolate) {
      final String endPoints = interpolateEndPoint(apiService.endPoint, value!);
      url = Uri.parse('$baseUrl${endPoints}');
      print(url);
    } else {
      url = Uri.parse('$baseUrl${apiService.endPoint}');
    }
    switch (apiService.method) {
      case 'POST':
      //  print(body);
        print(jsonEncode(body));
        response = await http.post(url,
            headers: defaultHeaders, body: jsonEncode(body));
        break;
      case 'PUT':
        response = await http.put(url,
            headers: defaultHeaders, body: jsonEncode(body));
        break;
      case 'DELETE':
        response = await http.delete(url, headers: defaultHeaders);
        break;
      default:
        response = await http.get(url, headers: defaultHeaders);
        break;
    }
    print("response status code: ${response.statusCode}");
    print("response body: ${response.body}");

    if (response.statusCode == 307) {
      // Extract the new location from the response headers
      var newLocation = response.headers['location'];
      if (newLocation != null) {
        url = Uri.parse(newLocation);

        switch (apiService.method) {
          case 'POST':
            response = await http.post(url, headers: defaultHeaders, body: jsonEncode(body));
            break;
          case 'PUT':
            response = await http.put(url, headers: defaultHeaders, body: jsonEncode(body));
            break;
          case 'DELETE':
            response = await http.delete(url, headers: defaultHeaders);
            break;
          default:
            response = await http.get(url, headers: defaultHeaders);
            break;
        }
      } else {
        print('No location header found for 307 redirect.');
        return;
      }
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      try {
        Map<String, dynamic> errResponseToReturn ={'errorMessage': response.body.isNotEmpty ? response.body : 'Not Found'};
        return errResponseToReturn;
      } catch (e) {
        Map<String, dynamic> errResponseToReturn = {'errorMessage': 'Not Found'};
        return errResponseToReturn;
      }
    } else {
     /* print(parseErrors(jsonDecode(response.body)));
      Map<String, dynamic> errResponseToReturn = {'errorMessage': 'Not Found'};
      return errResponseToReturn;
*/
      try {
        final decodedResponse = jsonDecode(response.body);
        print("decoded error response type: ${decodedResponse.runtimeType} = $decodedResponse");
        return decodedResponse;
      } catch (e) {
        print("Non-JSON error response: ${response.body}");
        return {'errorMessage': response.body};
      }
      // throw Exception(parseErrors(jsonDecode(response.body)));
    }
  }

  String parseErrors(Map<String, dynamic> jsonErrors) {
    StringBuffer errors = StringBuffer();
    jsonErrors.forEach((field, messages) {
      messages.forEach((message) {
        errors.writeln("$field: $message");
      });
    });
    return errors.toString();
  }
}
