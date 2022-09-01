import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';

class TextTileFooter extends StatelessWidget {
  const TextTileFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.p10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.lightGrey,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r15),
          bottomRight: Radius.circular(AppRadius.r15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.location_on_outlined,
              size: AppSize.s30,
              color: ColorManager.darkGrey,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_outline,
              size: AppSize.s30,
              color: ColorManager.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}
