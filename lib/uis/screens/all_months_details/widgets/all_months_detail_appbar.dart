import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:flutter/material.dart';

class MonthDetailAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MonthDetailAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: ColorManager.black),
      title: const Text(
        'View All Months',
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
