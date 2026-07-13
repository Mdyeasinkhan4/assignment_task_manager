import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class TmAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const TmAppbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.PColor,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // TODO: search filter porer step-e add kora jete pare
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}