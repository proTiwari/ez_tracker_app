import 'package:ez_tracker_app/providers/record_tile_provider.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ListTileRatingBar extends StatelessWidget {
  const ListTileRatingBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordTileProvider>(context);
    return Column(
      children: [
        Text(
          provider.trackerRecordDetails?.ratings == null
              ? 'Rate your activity'
              : 'Your ratings',
          style: getBoldStyle(
            color: ColorManager.grey,
            fontSize: FontSize.s16,
          ),
        ),
        SizedBox(height: AppHeight.h5),
        AbsorbPointer(
          absorbing: provider.trackerRecordDetails?.ratings != null,
          child: RatingBar(
            glowColor: ColorManager.accent,
            initialRating: provider.trackerRecordDetails?.ratings ?? 0,
            direction: Axis.horizontal,
            // allowHalfRating: true,
            itemCount: 5,
            ratingWidget: RatingWidget(
              full: const Icon(
                Icons.star,
                color: ColorManager.accent,
              ),
              half: const Icon(
                Icons.star_half,
                color: ColorManager.accent,
              ),
              empty: const Icon(
                Icons.star_border,
                color: ColorManager.accent,
              ),
            ),
            itemPadding: EdgeInsets.symmetric(horizontal: AppPadding.p4),
            onRatingUpdate: (rating) =>
                onUpdateRatings(context, rating: rating),
          ),
        ),
      ],
    );
  }

  void onUpdateRatings(BuildContext context, {required double rating}) {
    final provider = Provider.of<RecordTileProvider>(context, listen: false);
    if (provider.trackerRecordDetails?.ratings != null) return;
    provider.updateRatings(rating);
  }
}
