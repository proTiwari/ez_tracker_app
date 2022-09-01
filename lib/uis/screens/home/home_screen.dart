import 'package:ez_tracker_app/models/tracker_record/tracker_record_model.dart';
import 'package:ez_tracker_app/providers/home_provider.dart';
import 'package:ez_tracker_app/providers/record_tile_provider.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:ez_tracker_app/uis/screens/home/widgets/list_tile_swipable.dart';
import 'package:ez_tracker_app/uis/widgets/app_card.dart';
import 'package:ez_tracker_app/uis/widgets/app_drawer.dart';
import 'package:ez_tracker_app/uis/widgets/app_indicator.dart';
import 'package:ez_tracker_app/utils/utility_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../services/background_location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPosition();
    });
  }

  Future<void> getPosition() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.getPosition();
    BackgroundLocationService.instance.initLocationTrackingEvent();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      await homeProvider.checkLocationServiceEnabled();
      BackgroundLocationService.instance.initLocationTrackingEvent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: ColorManager.grey2,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('MMMM').format(DateTime.now()),
              style: getMediumStyle(
                color: ColorManager.black,
                fontSize: FontSize.s18,
              ),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: ColorManager.black,
            )
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.sim_card,
              color: ColorManager.grey2,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(AppHeight.h50),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: ColorManager.accent,
                  width: 4,
                ),
              ),
            ),
            padding: EdgeInsets.only(
              bottom: AppPadding.p5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildHeaderColumn(title: 'DRIVES', value: '0'),
                _buildHeaderColumn(title: 'MILES DRIVEN', value: '00000'),
                _buildHeaderColumn(title: 'LOGGED', value: '\$0'),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final homeProvider = Provider.of<HomeProvider>(context);
    if (!(homeProvider.isLocationServiceEnabled ?? true)) {
      return _buildLocationPermissionColumn();
    }

    return _buildRecordListWidget();
  }

  Widget _buildRecordListWidget() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return StreamBuilder<List<TrackerRecordModel>?>(
      stream: homeProvider.getUnClassifiedRecords(),
      builder: (_, dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return AppIndicator(
            indicatorColor: Theme.of(context).primaryColor,
          );
        }

        if (dataSnapShot.hasError) {
          return UtilityHelper.showNoDataWidget(
              message: 'Something went wrong');
        }

        final List<TrackerRecordModel>? records = dataSnapShot.data;
        return (records?.isNotEmpty ?? false)
            ? ListView.builder(
                padding: const EdgeInsets.all(20),
                shrinkWrap: true,
                itemCount: records?.length ?? 0,
                itemBuilder: ((context, index) {
                  return ChangeNotifierProvider.value(
                    value: RecordTileProvider(
                        trackerRecordDetails: records?[index]),
                    child: const RecordListTileSwipable(),
                  );
                }),
              )
            : UtilityHelper.showNoDataWidget(
                message: 'There are no unclassified drives found.',
              );
      },
    );
  }

  Widget _buildHeaderColumn({
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: getMediumStyle(
            color: ColorManager.grey1,
            fontSize: FontSize.s20,
          ),
        ),
        Text(
          title,
          style: getMediumStyle(
            color: ColorManager.grey2,
            fontSize: FontSize.s10,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPermissionColumn() {
    return AppCard(
      bgColor: ColorManager.white,
      padding: EdgeInsets.all(AppPadding.p14),
      margin: EdgeInsets.all(AppMargin.m20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enable Location',
            style: getBoldStyle(
              color: ColorManager.black,
              fontSize: FontSize.s20,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppHeight.h10),
          Text(
            'Tracker EZ cannot log your drives without location access',
            style: getMediumStyle(
              color: ColorManager.grey2,
              fontSize: FontSize.s18,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppHeight.h8),
          Text(
            'Enable this permission in settings',
            style: getRegularStyle(
              color: ColorManager.grey1,
              fontSize: FontSize.s16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppHeight.h5),
          Text(
            'Permissions > Location',
            style: getRegularStyle(
              color: ColorManager.black,
              fontSize: FontSize.s16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
