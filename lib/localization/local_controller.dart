import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartware/core/utils/pref_helper.dart';

class LocaleController extends GetxController {
  final Rx<Locale> currentLocale = const Locale('en').obs;

  Future<void> changeLanguage(String code) async {
    final locale = Locale(code);

    currentLocale.value = locale;

    Get.updateLocale(locale);

    await PrefHelper.saveLanguage(code);
    currentLocale.refresh();
  }

  Future<void> toggleLanguage() async {
    if (Get.locale?.languageCode == 'en') {
      await changeLanguage('ar');
    } else {
      await changeLanguage('en');
    }
  }
}
