import 'package:get/get.dart';
import 'package:NIDE/controller/auth.dart';
import 'package:NIDE/controller/dashboard.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(AuthController());
  }
}