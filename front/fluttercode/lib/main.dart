import 'package:Cesta/component/colors.dart';
import 'package:Cesta/controller/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:Cesta/route/route.dart';
import 'package:Cesta/route/page.dart';
import 'package:flutter/services.dart';

// flutter run --web-renderer html --dart-define-from-file=env.local.json

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig

  Get.put(AuthController()); // ou Get.lazyPut(() => AuthController());

  // Bloqueando a rotação da tela para o modo retrato (portrait)
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Retrato normal
    DeviceOrientation.portraitDown // Retrato invertido (se necessário)
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: lightColor, // cor da barra superior
    statusBarIconBrightness: Brightness.light, // ícones da barra superior
    systemNavigationBarColor: PrimaryColor, // cor da barra inferior
    systemNavigationBarIconBrightness:
        Brightness.light, // ícones da barra inferior
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppPage.list,
      initialRoute: AppRoute.dashboard,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      builder: EasyLoading.init(),
      theme: ThemeData(fontFamily: 'Montserrat'),
    );
  }
}
