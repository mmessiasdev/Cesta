import 'package:get/get.dart';
import 'package:Cesta/controller/auth.dart';
import 'package:Cesta/controller/dashboard.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
    Get.put(AuthController());
  }
}