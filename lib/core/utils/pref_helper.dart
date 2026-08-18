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
    print('══════════════════════════════════');
    print('');
  }
// ============================================================
// CLIENT ONBOARDING
// ============================================================

static const String _clientOnboardingStep =
    'client_onboarding_step';

static const String _clientProfileCompletion =
    'client_profile_completion';

static const String _clientPreferencesCompleted =
    'client_preferences_completed';

static const String _clientDocumentsCompleted =
    'client_documents_completed';

static const String _clientProfileCompleted =
    'client_profile_completed';

static const String _clientFacilityId =
    'client_facility_id';

static const String _clientBusinessName =
    'client_business_name';

static const String _clientBusinessType =
    'client_business_type';

static const String _clientSelectedProducts =
    'client_selected_products';


// ============================================================
// SAVE ONBOARDING STEP
// ============================================================

static Future<void> saveClientOnboardingStep(
  int step,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt(
    _clientOnboardingStep,
    step,
  );
}


// ============================================================
// GET ONBOARDING STEP
// ============================================================

static Future<int> getClientOnboardingStep() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getInt(
        _clientOnboardingStep,
      ) ??
      0;
}


// ============================================================
// SAVE PROFILE COMPLETION
// ============================================================

static Future<void> saveClientProfileCompletion(
  int completion,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt(
    _clientProfileCompletion,
    completion,
  );
}


// ============================================================
// GET PROFILE COMPLETION
// ============================================================

static Future<int> getClientProfileCompletion() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getInt(
        _clientProfileCompletion,
      ) ??
      0;
}


// ============================================================
// PREFERENCES COMPLETED
// ============================================================

static Future<void> setClientPreferencesCompleted(
  bool value,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool(
    _clientPreferencesCompleted,
    value,
  );
}


static Future<bool> isClientPreferencesCompleted() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getBool(
        _clientPreferencesCompleted,
      ) ??
      false;
}


// ============================================================
// DOCUMENTS COMPLETED
// ============================================================

static Future<void> setClientDocumentsCompleted(
  bool value,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool(
    _clientDocumentsCompleted,
    value,
  );
}


static Future<bool> areClientDocumentsCompleted() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getBool(
        _clientDocumentsCompleted,
      ) ??
      false;
}


// ============================================================
// PROFILE COMPLETED
// ============================================================

static Future<void> setClientProfileCompleted(
  bool value,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool(
    _clientProfileCompleted,
    value,
  );
}


static Future<bool> isClientProfileCompleted() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getBool(
        _clientProfileCompleted,
      ) ??
      false;
}


// ============================================================
// FACILITY ID
// ============================================================

static Future<void> saveClientFacilityId(
  int facilityId,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt(
    _clientFacilityId,
    facilityId,
  );
}


static Future<int?> getClientFacilityId() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getInt(
    _clientFacilityId,
  );
}


// ============================================================
// BUSINESS NAME
// ============================================================

static Future<void> saveClientBusinessName(
  String value,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString(
    _clientBusinessName,
    value,
  );
}


static Future<String> getClientBusinessName() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString(
        _clientBusinessName,
      ) ??
      '';
}


// ============================================================
// BUSINESS TYPE
// ============================================================

static Future<void> saveClientBusinessType(
  String value,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString(
    _clientBusinessType,
    value,
  );
}


static Future<String> getClientBusinessType() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString(
        _clientBusinessType,
      ) ??
      '';
}


// ============================================================
// SELECTED PRODUCTS
// ============================================================

static Future<void> saveClientSelectedProducts(
  List<String> products,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setStringList(
    _clientSelectedProducts,
    products,
  );
}


static Future<List<String>>
    getClientSelectedProducts() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getStringList(
        _clientSelectedProducts,
      ) ??
      [];
}


// ============================================================
// CLEAR CLIENT ONBOARDING
// ============================================================

static Future<void> clearClientOnboarding() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.remove(
    _clientOnboardingStep,
  );

  await prefs.remove(
    _clientProfileCompletion,
  );

  await prefs.remove(
    _clientPreferencesCompleted,
  );

  await prefs.remove(
    _clientDocumentsCompleted,
  );

  await prefs.remove(
    _clientProfileCompleted,
  );

  await prefs.remove(
    _clientFacilityId,
  );

  await prefs.remove(
    _clientBusinessName,
  );

  await prefs.remove(
    _clientBusinessType,
  );

  await prefs.remove(
    _clientSelectedProducts,
  );
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

    print('🧹 User data completely wiped out from local storage.');
  }

}