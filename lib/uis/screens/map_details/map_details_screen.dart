import 'dart:async';

import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/utils/utility_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../models/tracker_record/tracker_record_model.dart';
import '../../../resources/values_manager.dart';

class MapDetailsRouteModel {
  final LatLongModel? source;
  final LatLongModel? destination;

  MapDetailsRouteModel({
    required this.source,
    required this.destination,
  });
}

class MapDetailsScreen extends StatefulWidget {
  const MapDetailsScreen({Key? key, required this.routeModel})
      : super(key: key);

  final MapDetailsRouteModel? routeModel;

  @override
  State<MapDetailsScreen> createState() => _MapDetailsScreenState();
}

class _MapDetailsScreenState extends State<MapDetailsScreen> {
  final List<Marker> _markers = [];
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    addSourceMarker();
    addDestinationMarker();
  }

  void addSourceMarker() {
    _markers.add(Marker(
      markerId: const MarkerId('source'),
      position: LatLng(widget.routeModel?.source?.lat ?? 0,
          widget.routeModel?.source?.long ?? 0),
    ));
    setState(() {});
  }

  void addDestinationMarker() {
    _markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.routeModel?.destination?.lat ?? 0,
            widget.routeModel?.destination?.long ?? 0),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.close,
              color: ColorManager.grey2,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          'Map',
          style: getMediumStyle(
            color: ColorManager.black,
            fontSize: FontSize.s18,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppHeight.h4),
          child: Container(
            width: double.infinity,
            color: ColorManager.accent,
            height: 4,
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.routeModel?.source?.lat ?? 0,
              widget.routeModel?.source?.long ?? 0),
          zoom: 13,
        ),
        markers: Set<Marker>.of(_markers),
        mapType: MapType.terrain,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          Future.delayed(
            const Duration(milliseconds: 200),
            () => controller.animateCamera(
              CameraUpdate.newLatLngBounds(
                  UtilityHelper.boundsFromLatLngList(
                      _markers.map((loc) => loc.position).toList()),
                  1),
            ),
          );
        },
      ),
    );
  }
}
