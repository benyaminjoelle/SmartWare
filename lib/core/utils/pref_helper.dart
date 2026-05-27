import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
 static const String _langKey = 'app_language';
  static const String _tokenKey = 'auth_token';
  static const String _fcmTokenKey = 'fcm_token';
  static const String _userIdKey = 'user_id';
  static const String _readNotificationsKey = 'read_notifications';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';
  static const String _userPhotoKey = 'user_photo';
  static const String _businessNameKey = 'business_name';

//-------------------Auth Token------------------
 static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print("💾 Auth Token saved");
  }

//-------------------Languague------------------
  static Future<void> saveLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
  }

  /// Get saved language
  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_langKey) ?? 'en';
  }
//===================User Profile Data=====================

//--------------------User ID------------------
static Future<int?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(_userIdKey);
}

static Future<void> saveUserId(int id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_userIdKey, id);
}

//-------------------User Name------------------
static Future<String?> getUserName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userNameKey);
}

static Future<void> saveUserName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userNameKey, name);
}

//-------------------User Phone------------------
  static Future<String?> getUserPhone() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_phone');
}

  static Future<void> saveUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPhoneKey, phone);
  }

  //------------------User Email------------------
static Future<String> getUserEmail() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_email') ?? '';
}
static Future<void> saveUserEmail(String email) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_email', email);
}

//------------------Business Name----------------
static Future<String?> getBusinessName() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_businessNameKey);
}
static Future<void> saveBusinessName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_businessNameKey, name);
}

//-------------------User Photo------------------
static Future<String?> getUserPhoto() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userPhotoKey);
}
static Future<void> saveUserPhoto(String url) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userPhotoKey, url);
}

//------------------Clean User (logout)----------------
 static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
   await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userPhotoKey);
    await prefs.remove(_businessNameKey);
    await prefs.remove(_fcmTokenKey);
    await prefs.remove(_readNotificationsKey);
    print("🧹 User data completely wiped out from local storage.");
  }

}