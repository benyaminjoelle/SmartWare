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
  static const String _themeKey = 'theme_mode';
  static const String _userRoleKey = 'user_role';
  static const String _businessTypeKey = 'business_type';
  static const String _businessCategoriesKey = 'business_categories';
  // ============================================================
  // THEME
  // ============================================================

  static Future<void> saveTheme(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode);
  }

  static Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey);
  }

  // ============================================================
  // AUTH TOKEN
  // ============================================================


static Future<void> saveUserRole(String role) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userRoleKey, role);
}

static Future<String?> getUserRole() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userRoleKey);
}
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    print('════════ SAVE TOKEN ════════');
    print('🔑 Token received: $token');

    final result = await prefs.setString(_tokenKey, token);

    print('💾 SharedPreferences save result: $result');

    final savedToken = prefs.getString(_tokenKey);

    print('🔑 Token after saving: $savedToken');
    print('✅ Token saved correctly: ${savedToken == token}');
    print('═══════════════════════════');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString(_tokenKey);

    print('════════ GET TOKEN ════════');
    print('🔑 Stored token: $token');
    print('═══════════════════════════');

    return token;
  }

  // ============================================================
  // LANGUAGE
  // ============================================================

  static Future<void> saveLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_langKey) ?? 'en';
  }

  // ============================================================
  // USER ID
  // ============================================================

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_userIdKey);
  }

  static Future<void> saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_userIdKey, id);

    print('💾 User ID saved: $id');
  }

  // ============================================================
  // USER NAME
  // ============================================================

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_userNameKey);
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userNameKey, name);

    print('💾 User name saved: $name');
  }

  // ============================================================
  // USER PHONE
  // ============================================================

  static Future<String?> getUserPhone() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_userPhoneKey);
  }

  static Future<void> saveUserPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userPhoneKey, phone);

    print('💾 User phone saved: $phone');
  }

  // ============================================================
  // USER EMAIL
  // ============================================================

  static Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_userEmailKey) ?? '';
  }

  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userEmailKey, email);

    print('💾 User email saved: $email');
  }

  // ============================================================
  // BUSINESS NAME
  // ============================================================

  static Future<String?> getBusinessName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_businessNameKey);
  }

  static Future<void> saveBusinessName(String name) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_businessNameKey, name);

    print('💾 Business name saved: $name');
  }

  // ============================================================
  // USER PHOTO
  // ============================================================

  static Future<String?> getUserPhoto() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_userPhotoKey);
  }

  static Future<void> saveUserPhoto(String path) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userPhotoKey, path);
  }

  static Future<void> deleteUserPhoto() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userPhotoKey);
  }

  // ============================================================
  // DEBUG EVERYTHING
  // ============================================================

  static Future<void> debugUserData() async {
    final prefs = await SharedPreferences.getInstance();

    print('');
    print('════════ STORED USER DATA ════════');
    print('🔑 Token       : ${prefs.getString(_tokenKey)}');
    print('🆔 User ID     : ${prefs.getInt(_userIdKey)}');
    print('👤 Name        : ${prefs.getString(_userNameKey)}');
    print('📧 Email       : ${prefs.getString(_userEmailKey)}');
    print('📱 Phone       : ${prefs.getString(_userPhoneKey)}');
    print('🏢 Business    : ${prefs.getString(_businessNameKey)}');
    print('🖼️ Photo       : ${prefs.getString(_userPhotoKey)}');
    print('🌐 Language    : ${prefs.getString(_langKey)}');
    print('🏪 Business Type: ${prefs.getString(_businessTypeKey)}');
    print('📦 Categories: ${prefs.getStringList(_businessCategoriesKey)}',
);
    print('══════════════════════════════════');
    print('');
  }

// ============================================================
// ONBOARDING PREFERENCES
// ============================================================

static Future<void> saveBusinessType(String businessType) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString(_businessTypeKey, businessType);

  print('💾 Business type saved: $businessType');
}

static Future<String?> getBusinessType() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString(_businessTypeKey);
}

static Future<void> saveBusinessCategories(
    List<String> categories) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setStringList(
    _businessCategoriesKey,
    categories,
  );
  print('💾 Business categories saved: $categories');
}

static Future<List<String>> getBusinessCategories() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getStringList(_businessCategoriesKey) ?? [];
}

  // ============================================================
  // CLEAR USER / LOGOUT
  // ============================================================

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userRoleKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    await prefs.remove(_userPhoneKey);
    await prefs.remove(_userPhotoKey);
    await prefs.remove(_businessNameKey);
    await prefs.remove(_fcmTokenKey);
    await prefs.remove(_readNotificationsKey);
    await prefs.remove(_businessTypeKey);
    await prefs.remove(_businessCategoriesKey);

    print('🧹 User data completely wiped out from local storage.');
  }

}