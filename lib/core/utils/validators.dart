import 'package:get/get.dart';

class Validators {
  static String? phoneValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Phone Number'.tr;
    }
    // Only numbers allowed
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Phone number must contain only digits'.tr;
    }

    // Exactly 10 digits
    if (value.length != 10) {
      return 'Phone number must be exactly 10 digits'.tr;
    }
    // Must start with 09
    if (!value.startsWith('09')) {
      return 'Phone number must start with 09'.tr;
    }
    return null;
  }

  static String? passwordValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter The Password'.tr;
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long'.tr;
    }
    return null;
  }

  static String? nameValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please Enter Your Name'.tr;
    }

    // Only letters (English or Arabic)
    if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(value)) {
      return 'Only letters are allowed'.tr;
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters'.tr;
    }

    return null;
  }
  static String? usernameValidation(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Username is required'.tr;
  }

  final v = value.trim().toLowerCase();

  if (v.length < 3) {
    return 'Username too short'.tr;
  }

  if (v.length > 20) {
    return 'Username too long'.tr;
  }

  // only letters, numbers, underscore
  if (!RegExp(r'^[a-z0-9_]+$').hasMatch(v)) {
    return 'Only a-z, 0-9, _ allowed'.tr;
  }

  // cannot start with number
  if (RegExp(r'^[0-9]').hasMatch(v)) {
    return 'Username cannot start with a number'.tr;
  }

  return null;
}
  static String? emailValidation(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please Enter your Email'.tr;
  }

  // 2. Define the Email Regex pattern
  // This pattern ensures: text + @ + text + . + text
  final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // 3. Validate the format
  if (!emailRegExp.hasMatch(value)) {
    return "Please Enter a valid email address.".tr;
  }

  // 4. Return null if validation passes
  return null;
}

static String? emailOrPhoneValidation(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please Enter Email or Phone number'.tr;
  }

  // If the input contains '@', validate as email
  if (value.contains('@')) {
    return emailValidation(value);
  } 
  
  // Otherwise, validate as phone number
  // Note: We trim it in case the user added accidental spaces
  return phoneValidation(value.trim());
}

static String? validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the verification code'.tr;
    }
    if (value.length != 4) {
      return 'Verification code must be 4 digits'.tr;
    }
    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'Verification code must contain only digits'.tr;
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password'.tr;
    }

    if (value != password) {
      return 'Passwords do not match'.tr;
    }

    return null;
  }

  static String? validatePhoto(String? fileName) {
    if (fileName == null || fileName.isEmpty) {
      return 'Please upload your ID photo';
    }
    return null;
  }

  static String? validateDOB(int? day, String? month, int? year) {
    if (day == null || month == null || year == null) {
      return 'Please select your full date of birth'.tr;
    }

    final dob = DateTime(year, _monthStringToInt(month), day);
    final today = DateTime.now();
    final age = today.year -
        dob.year -
        ((today.month < dob.month ||
                (today.month == dob.month && today.day < dob.day))
            ? 1
            : 0);

    if (age < 18) {
      return 'You must be at least 18 years old'.tr;
    }

    return null;
  }

// Helper to convert month string to number
  static int _monthStringToInt(String month) {
    switch (month) {
      case 'Jan':
        return 1;
      case 'Feb':
        return 2;
      case 'Mar':
        return 3;
      case 'Apr':
        return 4;
      case 'May':
        return 5;
      case 'Jun':
        return 6;
      case 'Jul':
        return 7;
      case 'Aug':
        return 8;
      case 'Sep':
        return 9;
      case 'Oct':
        return 10;
      case 'Nov':
        return 11;
      case 'Dec':
        return 12;
      default:
        return 1;
    }
  }

  static String? validateStreet(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required'.tr;
    }
    if (value.length < 3) {
      return 'Street name is too short'.tr;
    }
    if (value.length > 149) {
      return 'Street name is too long';
    }
    return null;
  }

  static String? validateArea(String? value) {
    if (value == null || value.isEmpty) return 'Required'.tr;
    if (double.tryParse(value) == null) return 'Invalid number'.tr;
    return null;
  }

  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) return 'Required'.tr;
    if (double.tryParse(value) == null) return 'Invalid price'.tr;
    return null;
  }

  static String? validatePropertyDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required'.tr;
    }
    if (value.length < 50) {
      return 'description is too short';
    }

   

    return null;
  }
}
