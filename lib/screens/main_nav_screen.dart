import 'package:assignment_task_manager/screens/all_task_screen.dart';
import 'package:assignment_task_manager/screens/calendar_screen.dart';
import 'package:assignment_task_manager/screens/categories_screen.dart';
import 'package:assignment_task_manager/screens/profile_screen.dart';
import 'package:flutter/material.dart';

import '../widget/app_drawer.dart';
import '../widget/tm_appbar.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int selectedIndex = 0;

  final List<String> titles = ['All Tasks', 'Categories', 'Calendar', 'Profile'];

  final List<Widget> screens = [
    AllTaskScreen(),
    CategoriesScreen(),
    CalendarScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppbar(title: titles[selectedIndex]),
      drawer: AppDrawer(),
      body: screens[selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.check_box_outlined), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.category_outlined), label: 'Categories'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}