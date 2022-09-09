import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/routes_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: AppPadding.p30),
            height: AppHeight.h100,
            width: double.infinity,
            color: ColorManager.accent,
            child: Text(
              'EZ Tracker',
              style: getBoldStyle(
                color: ColorManager.white,
                fontSize: FontSize.s25,
              ),
            ),
          ),
          _buildListTile(
            context,
            icon: Icons.car_rental,
            title: 'Unclassified',
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.homeRoute);
            },
          ),
          _buildListTile(
            context,
            icon: Icons.local_activity,
            title: 'My Activity',
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.myActivityRoute);
            },
          ),
          _buildListTile(
            context,
            icon: Icons.car_crash,
            title: 'View All Months',
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.report);
          },
          ),

          _buildListTile(
            context,
            icon: Icons.help_center,
            title: 'Help',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.only(
          left: AppMargin.m14,
          top: AppMargin.m14,
          bottom: AppMargin.m10,
        ),
        width: double.infinity,
        child: Row(
          children: [
            Icon(
              icon,
              color: ColorManager.grey2,
            ),
            SizedBox(width: AppWidth.w15),
            Text(
              title,
              style: getRegularStyle(
                color: ColorManager.black,
                fontSize: FontSize.s16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
