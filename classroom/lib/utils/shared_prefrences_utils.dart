import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefrencesUtils {
  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName') ?? 'Default User';
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? 'user@example.com';
  }

  static Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userEmail');
  }
}
