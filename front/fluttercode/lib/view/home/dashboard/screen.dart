import 'package:NIDE/service/local/auth.dart';
import 'package:NIDE/view/home/account/auth/signin.dart';
import 'package:NIDE/view/home/homepage/homepage.dart';
import 'package:NIDE/view/students/studentsscree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart';
import 'package:NIDE/component/colors.dart';
import 'package:NIDE/controller/dashboard.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var token;
  var profileId;

  @override
  void initState() {
    super.initState();
    getString();
  }

  void getString() async {
    var strToken = await LocalAuthService().getSecureToken();
    var strProfileId = await LocalAuthService().getProfileId();

    setState(() {
      token = strToken.toString();
      profileId = strProfileId.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: SizedBox(
          child: GetBuilder<DashboardController>(
        builder: (controller) => token == "null"
            ? SignInScreen()
            : Scaffold(
                backgroundColor: lightColor,
                body: SafeArea(
                  child: IndexedStack(
                    index: controller.tabIndex,
                    children: [
                      StudentsScreen(
                        token: token,
                        profileId: int.parse(profileId.toString()),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: PrimaryColor,
                  ),
                  child: SnakeNavigationBar.color(
                    snakeShape: SnakeShape.rectangle,
                    backgroundColor: PrimaryColor,
                    unselectedItemColor: lightColor,
                    showUnselectedLabels: true,
                    selectedItemColor: SecudaryColor,
                    snakeViewColor: PrimaryColor,
                    currentIndex: controller.tabIndex,
                    onTap: (val) {
                      controller.updateIndex(val);
                    },
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(
                        Icons.home_filled,
                        size: 30,
                      )),
                      BottomNavigationBarItem(
                        icon: Icon(
                          Icons.wallet,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      )),
    );
  }
}
