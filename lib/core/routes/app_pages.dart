import 'package:get/get.dart';
import 'package:storex/core/routes/app_routes.dart';
import 'package:storex/features/auth/bindings/forgot_pass_binding.dart';
import 'package:storex/features/auth/bindings/login_binding.dart';
import 'package:storex/features/auth/bindings/singup_onboarding_binding.dart';

import 'package:storex/features/auth/views/signup/client/signup_view.dart';
import 'package:storex/features/auth/views/signup/signup_onboarding.dart';
import 'package:storex/features/auth/views/login/forgot_password.dart';

import 'package:storex/features/auth/views/login/verify_code.dart';

import 'package:storex/features/auth/views/login/login.dart';
import 'package:storex/features/onboarding/binding/carousel_binding.dart';
import 'package:storex/features/onboarding/views/onboarding_view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => Login(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPassword(),
      binding: ForgotPassBinding(),
    ),
     GetPage(
      name: AppRoutes.verifyCode,
      page: () => const verifyCode(),
      // binding: ForgotPassBinding(),
    ),
    GetPage(
      name: AppRoutes.signupOnboarding,
      page: () =>  SignupOnboarding(),
      binding: SignupOnboardingBinding(),
    ),
     GetPage(
      name: AppRoutes.signup,
      page: () => SignupView(),

    ),
    
  
  ];
}
