import 'dart:convert';

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
  static const String _ownerProductCategories =
    'owner_product_categories';
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

  static const String _profileCompletedKey = 'profile_completed';

  //=============== profile completion ===============
  static Future<void> saveProfileCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_profileCompletedKey, value);
  }

  static Future<bool> getProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_profileCompletedKey) ?? false;
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
    print('📦 Categories: ${prefs.getStringList(_businessCategoriesKey)}');
    print('══════════════════════════════════');
    print('');
  }
  // ============================================================
  // CLIENT ONBOARDING
  // ============================================================

  static const String _clientOnboardingStep = 'client_onboarding_step';

  static const String _clientProfileCompletion = 'client_profile_completion';

  static const String _clientPreferencesCompleted =
      'client_preferences_completed';

  static const String _clientDocumentsCompleted = 'client_documents_completed';

  static const String _clientProfileCompleted = 'client_profile_completed';

  static const String _clientFacilityId = 'client_facility_id';

  static const String _clientBusinessName = 'client_business_name';

  static const String _clientBusinessType = 'client_business_type';

  static const String _clientSelectedProducts = 'client_selected_products';

  // ============================================================
  // SAVE ONBOARDING STEP
  // ============================================================

  static Future<void> saveClientOnboardingStep(int step) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_clientOnboardingStep, step);
  }

  // ============================================================
  // GET ONBOARDING STEP
  // ============================================================

  static Future<int> getClientOnboardingStep() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_clientOnboardingStep) ?? 0;
  }

  // ============================================================
  // SAVE PROFILE COMPLETION
  // ============================================================

  static Future<void> saveClientProfileCompletion(int completion) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_clientProfileCompletion, completion);
  }

  // ============================================================
  // GET PROFILE COMPLETION
  // ============================================================

  static Future<int> getClientProfileCompletion() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_clientProfileCompletion) ?? 0;
  }

  // ============================================================
  // PREFERENCES COMPLETED
  // ============================================================

  static Future<void> setClientPreferencesCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_clientPreferencesCompleted, value);
  }

  static Future<bool> isClientPreferencesCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_clientPreferencesCompleted) ?? false;
  }

  // ============================================================
  // DOCUMENTS COMPLETED
  // ============================================================

  static Future<void> setClientDocumentsCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_clientDocumentsCompleted, value);
  }

  static Future<bool> areClientDocumentsCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_clientDocumentsCompleted) ?? false;
  }

  // ============================================================
  // PROFILE COMPLETED
  // ============================================================

  static Future<void> setClientProfileCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_clientProfileCompleted, value);
  }

  static Future<bool> isClientProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_clientProfileCompleted) ?? false;
  }

  // ============================================================
  // FACILITY ID
  // ============================================================

  static Future<void> saveClientFacilityId(int facilityId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_clientFacilityId, facilityId);
  }

  static Future<int?> getClientFacilityId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_clientFacilityId);
  }

  // ============================================================
  // BUSINESS NAME
  // ============================================================

  static Future<void> saveClientBusinessName(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_clientBusinessName, value);
  }

  static Future<String> getClientBusinessName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_clientBusinessName) ?? '';
  }

  // ============================================================
  // BUSINESS TYPE
  // ============================================================

  static Future<void> saveClientBusinessType(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_clientBusinessType, value);
  }

  static Future<String> getClientBusinessType() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_clientBusinessType) ?? '';
  }

  // ============================================================
  // SELECTED PRODUCTS
  // ============================================================

  static Future<void> saveClientSelectedProducts(List<String> products) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_clientSelectedProducts, products);
  }

  static Future<List<String>> getClientSelectedProducts() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_clientSelectedProducts) ?? [];
  }

  // ============================================================
  // CLEAR CLIENT ONBOARDING
  // ============================================================

  static Future<void> clearClientOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_clientOnboardingStep);

    await prefs.remove(_clientProfileCompletion);

    await prefs.remove(_clientPreferencesCompleted);

    await prefs.remove(_clientDocumentsCompleted);

    await prefs.remove(_clientProfileCompleted);

    await prefs.remove(_clientFacilityId);

    await prefs.remove(_clientBusinessName);

    await prefs.remove(_clientBusinessType);

    await prefs.remove(_clientSelectedProducts);
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

  static Future<void> saveBusinessCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_businessCategoriesKey, categories);
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
    await prefs.remove(_ownerProductCategories);

    print('🧹 User data completely wiped out from local storage.');
  }
  // ============================================================
  // OWNER ONBOARDING
  // ============================================================

  static const String _ownerOnboardingStep = 'owner_onboarding_step';

  static const String _ownerProfileCompletion = 'owner_profile_completion';

  static const String _ownerPreferencesCompleted =
      'owner_preferences_completed';

  static const String _ownerDocumentsCompleted = 'owner_documents_completed';

  static const String _ownerProfileCompleted = 'owner_profile_completed';

  static const String _ownerFacilityId = 'owner_facility_id';

  static const String _ownerBusinessName = 'owner_business_name';

  static const String _ownerBusinessType = 'owner_business_type';

  static const String _ownerSelectedProducts = 'owner_selected_products';

  // ============================================================
  // SAVE OWNER ONBOARDING STEP
  // ============================================================

  static Future<void> saveOwnerOnboardingStep(int step) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_ownerOnboardingStep, step);
  }

  // ============================================================
  // GET OWNER ONBOARDING STEP
  // ============================================================

  static Future<int> getOwnerOnboardingStep() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_ownerOnboardingStep) ?? 0;
  }

  // ============================================================
  // SAVE OWNER PROFILE COMPLETION
  // ============================================================

  static Future<void> saveOwnerProfileCompletion(int completion) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_ownerProfileCompletion, completion);
  }

  // ============================================================
  // GET OWNER PROFILE COMPLETION
  // ============================================================

  static Future<int> getOwnerProfileCompletion() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt(_ownerProfileCompletion) ?? 0;
  }

  // ============================================================
  // OWNER PREFERENCES COMPLETED
  // ============================================================

  static Future<void> setOwnerPreferencesCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_ownerPreferencesCompleted, value);
  }

  static Future<bool> isOwnerPreferencesCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_ownerPreferencesCompleted) ?? false;
  }

  // ============================================================
  // OWNER DOCUMENTS COMPLETED
  // ============================================================

  static Future<void> setOwnerDocumentsCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_ownerDocumentsCompleted, value);
  }

  static Future<bool> areOwnerDocumentsCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_ownerDocumentsCompleted) ?? false;
  }

  // ============================================================
  // OWNER PROFILE COMPLETED
  // ============================================================

  static Future<void> setOwnerProfileCompleted(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_ownerProfileCompleted, value);
  }

  static Future<bool> isOwnerProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_ownerProfileCompleted) ?? false;
  }

  // ============================================================
  // OWNER FACILITY ID
  // ============================================================

  static Future<void> saveOwnerFacilityId(int facilityId) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_ownerFacilityId, facilityId);

    print('💾 Owner Facility ID saved: $facilityId');
  }
  static Future<int?> getOwnerFacilityId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_ownerFacilityId);
  }

  // ============================================================
  // OWNER BUSINESS NAME
  // ============================================================

  static Future<void> saveOwnerBusinessName(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_ownerBusinessName, value);
  }

  static Future<String> getOwnerBusinessName() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_ownerBusinessName) ?? '';
  }

  // ============================================================
  // OWNER BUSINESS TYPE
  // ============================================================

  static Future<void> saveOwnerBusinessType(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_ownerBusinessType, value);
  }

  static Future<String> getOwnerBusinessType() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(_ownerBusinessType) ?? '';
  }

  // ============================================================
  // OWNER SELECTED PRODUCTS
  // ============================================================

  static Future<void> saveOwnerSelectedProducts(List<String> products) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_ownerSelectedProducts, products);
  }

  static Future<List<String>> getOwnerSelectedProducts() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_ownerSelectedProducts) ?? [];
  }

  // ============================================================
  // CLEAR OWNER ONBOARDING
  // ============================================================

  static Future<void> clearOwnerOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_ownerOnboardingStep);

    await prefs.remove(_ownerProfileCompletion);

    await prefs.remove(_ownerPreferencesCompleted);

    await prefs.remove(_ownerDocumentsCompleted);

    await prefs.remove(_ownerProfileCompleted);

    await prefs.remove(_ownerFacilityId);

    await prefs.remove(_ownerBusinessName);

    await prefs.remove(_ownerBusinessType);
    await prefs.remove(_ownerProductCategories);

    await prefs.remove(_ownerSelectedProducts);
  }
  // ============================================================
  // OWNER BUSINESS CATEGORIES
  // ============================================================

  static const String _ownerBusinessCategories = 'owner_business_categories';

  static Future<void> saveOwnerBusinessCategories(
    List<String> categories,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(_ownerBusinessCategories, categories);

    print('💾 Owner business categories saved: $categories');
  }

  static Future<List<String>> getOwnerBusinessCategories() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getStringList(_ownerBusinessCategories) ?? [];
  }
  static Future<void> saveOwnerProductCategories(
  List<Map<String, dynamic>> categories,
) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString(
    _ownerProductCategories,
    jsonEncode(categories),
  );

  print('💾 Owner product categories saved: $categories');
}

static Future<List<Map<String, dynamic>>> getOwnerProductCategories() async {
  final prefs = await SharedPreferences.getInstance();

  final value = prefs.getString(_ownerProductCategories);

  if (value == null || value.isEmpty) {
    return [];
  }

  try {
    final decoded = jsonDecode(value);

    if (decoded is! List) {
      return [];
    }

    return decoded
        .whereType<Map>()
        .map(
          (category) => Map<String, dynamic>.from(category),
        )
        .toList();
  } catch (e) {
    print('❌ Failed to decode owner product categories: $e');
    return [];
  }
}
}
