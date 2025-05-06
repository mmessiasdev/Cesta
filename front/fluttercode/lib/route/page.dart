import 'package:NIDE/route/route.dart';
import 'package:NIDE/view/home/account/auth/signin.dart';
import 'package:NIDE/view/home/dashboard/binding.dart';
import 'package:NIDE/view/home/dashboard/screen.dart';
import 'package:NIDE/view/home/homepage/homepage.dart';
import 'package:get/get.dart';

class AppPage {
  static var list = [
    GetPage(
      name: AppRoute.homepage,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoute.loginIn,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: AppRoute.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
  ];
}
