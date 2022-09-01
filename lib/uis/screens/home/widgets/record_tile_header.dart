import 'package:ez_tracker_app/providers/record_tile_provider.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordTileHeader extends StatelessWidget {
  const RecordTileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordTileProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.p20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.trackerRecordDetails?.distanceInMiles ?? "0",
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s20,
                ),
              ),
              Text(
                'MILES',
                style: getRegularStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s12,
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(bottom: AppPadding.p4),
            decoration: BoxDecoration(
              color: ColorManager.white,
              border: Border.all(color: ColorManager.grey),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(AppPadding.p4),
                  color: ColorManager.lightGrey,
                  child: Text(provider.recordWeekDay),
                ),
                Text(provider.trackerRecordDetails?.recordCreatedDate?.day
                        .toString() ??
                    ''),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${provider.trackerRecordDetails?.potentialPrice ?? 0}",
                style: getBoldStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s20,
                ),
              ),
              Text(
                'POTENTIAL',
                style: getRegularStyle(
                  color: ColorManager.black,
                  fontSize: FontSize.s12,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
