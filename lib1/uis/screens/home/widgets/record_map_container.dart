import 'package:ez_tracker_app/helpers/constant.dart';
import 'package:ez_tracker_app/providers/record_tile_provider.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/routes_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/tracker_record/tracker_record_model.dart';
import '../../map_details/map_details_screen.dart';

class RecordMapContainer extends StatelessWidget {
  const RecordMapContainer({Key? key}) : super(key: key);

  void _navigateToMapDetails(BuildContext context) {
    final provider = Provider.of<RecordTileProvider>(context, listen: false);
    Navigator.of(context).pushNamed(
      AppRoutes.mapDetailsRoute,
      arguments: MapDetailsRouteModel(
        source: provider.trackerRecordDetails?.sourceDetails,
        destination: provider.trackerRecordDetails?.destinationDetails,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecordTileProvider>(context);
    return GestureDetector(
      onTap: () => _navigateToMapDetails(context),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppMargin.m20),
        width: double.infinity,
        height: AppHeight.h200,
        decoration: BoxDecoration(
          color: ColorManager.white,
          border: Border.all(color: ColorManager.black),
        ),
        child: Row(children: [
          _buildMapImage(
            markerColor: '0x00ff00',
            latLongModel: provider.trackerRecordDetails?.sourceDetails,
          ),
          _buildMapImage(
              markerColor: '0xff0000',
              latLongModel: provider.trackerRecordDetails?.destinationDetails),
        ]),
      ),
    );
  }

  Widget _buildMapImage({
    required LatLongModel? latLongModel,
    required String markerColor,
  }) {
    return Expanded(
      child: Image.network(
        "https://maps.googleapis.com/maps/api/staticmap?center=${latLongModel?.lat ?? 0},${latLongModel?.long ?? 0}&zoom=15&scale=1&size=200x200&maptype=roadmap&key=$googleMapApiKey&format=png&visual_refresh=true&markers=size:mid%7Ccolor:$markerColor%7Clabel:%7C${latLongModel?.lat ?? 0},${latLongModel?.long ?? 0}",
        fit: BoxFit.fill,
      ),
    );
  }
}
