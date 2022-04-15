import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static setSharedPrefences() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.setString(
        'teste_shared', 'Este é um teste de shared preferences');
  }

  static getSharedPreferences() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('teste_shared');
  }

  static clear() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
