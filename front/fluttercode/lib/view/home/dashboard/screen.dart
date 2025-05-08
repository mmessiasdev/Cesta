import 'package:Cesta/component/colors.dart';
import 'package:Cesta/controller/dashboard.dart';
import 'package:Cesta/service/local/auth.dart';
import 'package:Cesta/view/home/account/auth/signin.dart';
import 'package:Cesta/view/students/studentsscree.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? token;
  String? profileId;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strProfile = await LocalAuthService().getProfileId();

    setState(() {
      token = strToken?.toString();
      profileId = strProfile?.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<DashboardController>(
        builder: (controller) {
          // Verifica se os dados ainda não foram carregados
          if (token == null || profileId == null) {
            return const Center(child: SignInScreen());
          }

          // Após carregar e validar os dados, renderiza a tela principal
          return Scaffold(
            backgroundColor: lightColor,
            body: SafeArea(
              child: IndexedStack(
                index: controller.tabIndex,
                children: [
                  StudentsScreen(
                    token: token!,
                    profileId: int.tryParse(profileId!) ?? 0,
                  ),
                  // Outros widgets comentados
                  // HomePageSale(),
                  // HomePageSellers(),
                  // NotificationHomePage(),
                  // AccountScreen(
                  //   buttom: false,
                  // ),
                ],
              ),
            ),
            // Se quiser usar a bottomNavigationBar, descomente abaixo:
            /*
            bottomNavigationBar: Container(
              height: 60,
              decoration: BoxDecoration(
                color: lightColor,
              ),
              child: SnakeNavigationBar.color(
                snakeShape: SnakeShape.rectangle,
                backgroundColor: PrimaryColor,
                unselectedItemColor: nightColor,
                showUnselectedLabels: true,
                selectedItemColor: nightColor,
                snakeViewColor: SecudaryColor,
                currentIndex: controller.tabIndex,
                onTap: (val) {
                  controller.updateIndex(val);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search_sharp, size: 30)),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add, size: 30)),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.align_vertical_bottom, size: 30)),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.sell, size: 30)),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people, size: 30)),
                ],
              ),
            ),
            */
          );
        },
      ),
    );
  }
}
