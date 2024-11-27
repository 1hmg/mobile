import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  Future<void> saveUserData(String userId, String codAtributos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('codAtributos', codAtributos);
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<String?> getCodAtributos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('codAtributos');
  }

  Future<bool> isUserDataSaved() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userId') && prefs.containsKey('codAtributos');
  }
}
