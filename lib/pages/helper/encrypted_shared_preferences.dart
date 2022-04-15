import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class EncryptedSharedPreferencesHelper {
  static final EncryptedSharedPreferences _encryptedSharedPreferences =
      EncryptedSharedPreferences();

  static Future<bool> savePreferences(
      {required String key, required String value}) async {
    try {
      return await _encryptedSharedPreferences.setString(key, value);
    } catch (e) {
      print('Save preferences exception: $e');
      return false;
    }
  }

  static Future<String?> getPreferences({required String key}) async {
    try {
      return await _encryptedSharedPreferences.getString(key);
    } catch (e) {
      print('Get preferences exception: $e');
      return null;
    }
  }

  static clearEncrpt() async {
    await _encryptedSharedPreferences.clear();
  }
}
