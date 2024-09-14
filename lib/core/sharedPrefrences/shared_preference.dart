// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletapp/data/models/user_details_model.dart';

class SharedPreferencesHelper {
  static Future<void> saveUserData(UserDetailsModel user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("user Id :${user.id}");
    await prefs.setInt('id', user.id ?? 0);
    await prefs.setInt('isDriver', user.isDriver ?? 0);
    await prefs.setInt('isAdmin', user.isAdmin ?? 0);
    await prefs.setString('userName', user.userName ?? "");
    await prefs.setBool('isLoggedIn', true);
  }

  /*static Future<void> saveCreateServerData(
      CreateServerModel? serverData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMap = json.encode(serverData);
    await prefs.setString('data_create_servers', encodedMap);
  }*/

  static Future<void> saveBaseUrl(String baseurl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('baseurl', baseurl);
  }


  static Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? baseurl = prefs.getString('baseurl');
    return baseurl;
  }
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    return token;
  }

  static Future<void> saveUserSubscriptionStatus(bool isSubscribed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_isSubscribed', isSubscribed);
  }

  static Future<void> saveRemoteConfigSubscribed(bool isSubscribed) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remote_config_subscribed', isSubscribed);
  }


  static Future<String?> getForgeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('authentication_token');
    return token;
  }

  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("user Id :${prefs.getInt('id')}");
    return prefs.getInt('id');
  }
  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('user_email');
    return token;
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('user_name');
    return token;
  }

  static Future<bool?> getUserSubcriptionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isSubscribed = prefs.getBool('user_isSubscribed');
    return isSubscribed;
  }

  static Future<bool?> getRemoteConfigSubscriptionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? remoteConfigSubscribed =
        prefs.getBool('remote_config_subscribed');
    return remoteConfigSubscribed;
  }

  static Future<bool?> getCanCreateServerStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? canCreateServerStatus = prefs.getBool('can_create_servers');
    return canCreateServerStatus;
  }
}
