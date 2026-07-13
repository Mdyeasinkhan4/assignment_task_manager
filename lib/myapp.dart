import 'package:assignment_task_manager/screens/splash_screen.dart';
import 'package:assignment_task_manager/utils/app_colors.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          hintStyle: TextStyle(
            color: Colors.grey
          ),

          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none
          ),

          border: OutlineInputBorder(
              borderSide: BorderSide.none
          ),

        ),


        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.PColor,
                fixedSize: Size.fromWidth(double.maxFinite),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )
          )
        ),

          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.PColor,
            foregroundColor: Colors.white,
          ),


        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 28
          )
        )
      ),

      home: SplashScreen(),

    );
  }
}
