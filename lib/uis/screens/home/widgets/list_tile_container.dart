import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:ez_tracker_app/uis/screens/home/widgets/record_tile_header.dart';
import 'package:ez_tracker_app/uis/screens/home/widgets/record_map_container.dart';
import 'package:flutter/material.dart';

import 'record_address_section.dart';
import 'list_tile_footer.dart';
import 'list_tile_rating_bar.dart';

class ListTileContainer extends StatelessWidget {
  const ListTileContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppMargin.m20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.r15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.only(top: AppPadding.p10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const RecordTileHeader(),
          SizedBox(height: AppHeight.h10),
          const RecordMapContainer(),
          SizedBox(height: AppHeight.h20),
          const RecordAddressSection(),
          SizedBox(height: AppHeight.h20),
          const ListTileRatingBar(),
          SizedBox(height: AppHeight.h20),
          const TextTileFooter(),
        ],
      ),
    );
  }
}
