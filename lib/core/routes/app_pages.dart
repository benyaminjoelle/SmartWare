import 'package:get/get.dart';
import 'package:smartware/core/routes/app_routes.dart';
import 'package:smartware/features/auth/bindings/client_signup_binding.dart';
import 'package:smartware/features/auth/bindings/forgot_pass_binding.dart';
import 'package:smartware/features/auth/bindings/login_binding.dart';
import 'package:smartware/features/auth/bindings/owner_signup_binding.dart';
import 'package:smartware/features/auth/bindings/signup_onboarding_binding.dart';
import 'package:smartware/features/auth/bindings/worker_signup_binding.dart';
import 'package:smartware/features/auth/views/login/reset_password.dart';

import 'package:smartware/features/auth/views/signup/client/client_signup_view.dart';
import 'package:smartware/features/auth/views/signup/user_verification.dart';
import 'package:smartware/features/auth/views/signup/worker/worker_signup_view.dart';
import 'package:smartware/features/auth/views/signup/owner/owner_signup_view.dart';
import 'package:smartware/features/auth/views/signup/signup_onboarding.dart';
import 'package:smartware/features/auth/views/login/forgot_password.dart';

import 'package:smartware/features/auth/views/login/verify_code.dart';

import 'package:smartware/features/auth/views/login/login.dart';
import 'package:smartware/features/client/cart/views/checkout_view.dart';
import 'package:smartware/features/client/cart/views/client_cart_view.dart';
import 'package:smartware/features/client/home/views/client_home_view.dart';
import 'package:smartware/features/client/orders/views/client_orders_view.dart';
import 'package:smartware/features/client/profile/bindings/client_profile_binding.dart';
import 'package:smartware/features/client/profile/bindings/client_profile_completion_binding.dart';
import 'package:smartware/features/client/profile/bindings/client_edit_profile_binding.dart';
import 'package:smartware/features/client/profile/bindings/client_settings_binding.dart';
import 'package:smartware/features/client/profile/views/client_profile_completion_view.dart';
import 'package:smartware/features/client/profile/views/client_profile_view.dart';
import 'package:smartware/features/client/profile/views/client_edit_profile_view.dart';
import 'package:smartware/features/client/profile/views/client_settings._view.dart';
import 'package:smartware/features/client/root/binding/root_binding.dart';
import 'package:smartware/features/client/root/view/root_view.dart';
import 'package:smartware/features/onboarding/binding/carousel_binding.dart';
import 'package:smartware/features/onboarding/views/onboarding_view.dart';
import 'package:smartware/features/owner/analytics/views/owner_analytic_view.dart';
import 'package:smartware/features/owner/home/views/owner_home_view.dart';
import 'package:smartware/features/owner/notifications/views/owner_notifications_view.dart';
import 'package:smartware/features/owner/orders/views/owner_orders_view.dart';
import 'package:smartware/features/owner/products/views/owner_products_view.dart';
import 'package:smartware/features/owner/profile/views/owner_edit_profile_view.dart';
import 'package:smartware/features/owner/profile/views/owner_profile_view.dart';
import 'package:smartware/features/owner/profile/views/owner_settings_view.dart';
import 'package:smartware/features/owner/profile/views/owner_workers_view.dart';
import 'package:smartware/features/owner/root/binding/owner_root_binding.dart';
import 'package:smartware/features/owner/root/view/owner_root_view.dart';

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
      page: () => const VerifyCode(),
      binding: ForgotPassBinding(),
    ),
    GetPage(
      name: AppRoutes.userverification,
      page: () => UserVerification(),
      binding: SignupOnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPassword(),
      binding: ForgotPassBinding(),
    ),
    GetPage(
      name: AppRoutes.signupOnboarding,
      page: () => SignupOnboarding(),
      binding: SignupOnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.clientSignup,
      page: () => ClientSignupView(),
      binding: ClientSignupBinding(),
    ),
    GetPage(
      name: AppRoutes.ownerSignup,
      page: () => OwnerSignupView(),
      binding: OwnerSignupBinding(),
    ),
    GetPage(
      name: AppRoutes.workerSignup,
      page: () => WorkerSignupView(),
      binding: WorkerSignupBinding(),
    ),
    //============= Client routes =================
    GetPage(
      name: AppRoutes.clientRoot,
      page: () => ClientRootView(),
      binding: ClientRootBinding(),
    ),
    GetPage(
      name: AppRoutes.clientHome,
      page: () => ClientHomeView(),
      binding: ClientRootBinding(),
    ),
    GetPage(
      name: AppRoutes.clientProfile,
      page: () => ClientProfileView(),
      binding: ClientProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.clientSettings,
      page: () => ClientSettings(),
      binding: ClientSettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.clientEditPofile,
      page: () => ClientEditProfileView(),
      binding: ClientEditProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.clientCompletion,
      page: () => ClientProfileCompletionView(),
      binding: ClientProfileCompletionBinding(),
    ),
    GetPage(name:
     AppRoutes.clientOrders,
     page: () => ClientOrdersView()
    ),
    GetPage(
      name: AppRoutes.clientCart,
      page: () => ClientCartView()
    ),
    GetPage(
      name: AppRoutes.userverification,
      page: () => UserVerification()
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => CheckoutView()
    ),
     GetPage(
      name: AppRoutes.ownerRoot,
      page: () => OwnerRootView(),
      binding: OwnerRootBinding(),
    ),
    GetPage(
      name: AppRoutes.onwerHome,
      page: () => OwnerHomeView(),
      binding: OwnerRootBinding(),
    ),
     GetPage(
      name: AppRoutes.onwerAnalytics,
      page: () => OwnerAnalyticsView(),
      binding: OwnerRootBinding(),
    ), GetPage(
      name: AppRoutes.onwerNotifications,
      page: () => OwnerNotificationsView(),
      binding: OwnerRootBinding(),
    ), GetPage(
      name: AppRoutes.onwerOrders,
      page: () => OwnerOrdersView(),
      binding: OwnerRootBinding(),
    ), GetPage(
      name: AppRoutes.onwerProfile,
      page: () => OwnerProfileView(),
      binding: OwnerRootBinding(),
    ),
    GetPage(
      name: AppRoutes.ownerEditPofile,
      page: () => OwnerEditProfileView(),
    ),
    GetPage(
      name: AppRoutes.ownerSettings,
      page: () => OwnerSettingsView(),
      binding: OwnerRootBinding(),
    ),
    GetPage(
      name: AppRoutes.ownerWorkers,
      page: () => OwnerWorkersView(),
      binding: OwnerRootBinding(),
    ),
     GetPage(
      name: AppRoutes.ownerProducts,
      page: () => OwnerProductsView(),
      binding: OwnerRootBinding(),
    ),
  ];
}
