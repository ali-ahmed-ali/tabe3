import 'package:shared_preferences/shared_preferences.dart';

/*
* NOTE: This file to save and retrieve from shared preferences
* */
class PrefManager {
  Future<bool> remove(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  Future<bool> clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  // TODO: user this method to save new pref
  Future<bool> set(String key, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value is int) {
      return await prefs.setInt(key, value);
    } else if (value is double) {
      return await prefs.setDouble(key, value);
    } else if (value is String) {
      return await prefs.setString(key, value);
    } else if (value is bool) {
      return await prefs.setBool(key, value);
    }
    return false;
  }

  // TODO: use this method to retrieve what you saved in pref using that key
  // TODO: NOTE: @defaultVal in case you didn't save data with this key
  Future<dynamic> get(String key, dynamic defaultVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.get(key);
    }
    return defaultVal;
  }

  // TODO: Just to check if this key exist
  Future<bool> contains(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
