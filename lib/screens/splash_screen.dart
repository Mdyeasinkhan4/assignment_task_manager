import 'package:assignment_task_manager/controller/auth_controller.dart';
import 'package:assignment_task_manager/screens/main_nav_screen.dart';
import 'package:assignment_task_manager/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../widget/screen_bg.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      moveToNextScreen();
    });
  }

  Future<void> moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 5));
    await AuthController.getUserData();
    bool isLogin = await AuthController.usUserLogin();
    if (isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBG(
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.PColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.check, color: Colors.white, size: 22),
              ),
              SizedBox(width: 10),
              Text(
                'TaskManager',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}