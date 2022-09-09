import 'package:ez_tracker_app/models/tracker_record/location_detail_model.dart';
import 'package:ez_tracker_app/providers/record_tile_provider.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordAddressSection extends StatelessWidget {
  const RecordAddressSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordTileProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRow(
          locationDetailsModel: provider.sourceLocationDetails,
          markerColor: Colors.green,
        ),
        SizedBox(height: AppHeight.h10),
        _buildRow(
          locationDetailsModel: provider.destinationLocationDetails,
          markerColor: Colors.red,
        ),
      ],
    );
  }

  Widget _buildRow({
    required LocationDetailsModel locationDetailsModel,
    required Color markerColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppMargin.m20),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      padding: EdgeInsets.all(
        AppPadding.p10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: AppWidth.w10,
            height: AppWidth.w10,
            decoration: BoxDecoration(
              color: markerColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppWidth.w8),
          Expanded(
            child: Text(
              locationDetailsModel.address ?? '-',
              style: getBoldStyle(
                color: ColorManager.black,
                fontSize: FontSize.s16,
              ),
            ),
          ),
          Text(
            locationDetailsModel.time ?? '-',
            textAlign: TextAlign.center,
            style: getMediumStyle(
              color: ColorManager.black,
              fontSize: FontSize.s16,
            ),
          ),
        ],
      ),
    );
  }
}
