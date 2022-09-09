import 'package:ez_tracker_app/helpers/enum.dart';
import 'package:ez_tracker_app/providers/account_provider.dart';
import 'package:ez_tracker_app/providers/record_tile_provider.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/font_manager.dart';
import 'package:ez_tracker_app/resources/styles_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:ez_tracker_app/uis/screens/home/widgets/list_tile_container.dart';
import 'package:ez_tracker_app/uis/widgets/app_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';

import '../../../../models/tracker_record/tracker_record_model.dart';
import 'list_tile_rating_bar.dart';

class RecordListTileSwipable extends StatefulWidget {
  const RecordListTileSwipable({
    Key? key,
    this.recordDetails,
  }) : super(key: key);

  final TrackerRecordModel? recordDetails;

  @override
  State<RecordListTileSwipable> createState() => _RecordListTileSwipableState();
}

class _RecordListTileSwipableState extends State<RecordListTileSwipable> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   prepareIntialData();
    // });
  }

  // void prepareIntialData() {
  //   final recordTileProvider =
  //       Provider.of<RecordTileProvider>(context, listen: false);
  //   recordTileProvider.prepareInitialData();
  // }

  @override
  Widget build(BuildContext context) {
    final recordTileProvider = Provider.of<RecordTileProvider>(context);
    return recordTileProvider.isLoading
        ? AppIndicator(indicatorColor: Theme.of(context).primaryColor)
        : Dismissible(
            confirmDismiss: (direction) {
              if (direction == DismissDirection.startToEnd) {
                showCategoryPicker(
                  context,
                  categoryType: CategoryType.business,
                );
              }
              if (direction == DismissDirection.endToStart) {
                showCategoryPicker(
                  context,
                  categoryType: CategoryType.personal,
                );
              }
              return Future.value(false);
            },
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            key: UniqueKey(),
            child: const ListTileContainer(),
          );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.transparent,
      child: Align(
        child: Container(
          padding: EdgeInsets.all(AppPadding.p20),
          decoration: BoxDecoration(
            color: ColorManager.primary,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(AppRadius.r30),
              topRight: Radius.circular(AppRadius.r30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.business,
                color: Colors.white,
                size: AppSize.s30,
              ),
              SizedBox(height: AppHeight.h5),
              Text(
                "Business",
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s18,
                ),
              ),
            ],
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.transparent,
      child: Align(
        child: Container(
          padding: EdgeInsets.all(AppPadding.p20),
          decoration: BoxDecoration(
            color: ColorManager.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppRadius.r30),
              topLeft: Radius.circular(AppRadius.r30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.personal_injury,
                color: Colors.white,
                size: AppSize.s30,
              ),
              SizedBox(height: AppHeight.h5),
              Text(
                "Personal",
                style: getBoldStyle(
                  color: ColorManager.white,
                  fontSize: FontSize.s18,
                ),
              ),
            ],
          ),
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Future<void> showCategoryPicker(
    BuildContext context, {
    required CategoryType categoryType,
  }) async {
    final provider = Provider.of<RecordTileProvider>(context, listen: false);
    final AccountProvider accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    await accountProvider.getCategoriesData();
    final List<String>? categories = categoryType == CategoryType.business
        ? accountProvider.categoryModel?.business
        : accountProvider.categoryModel?.personal;
    String selectedCategory = provider.trackerRecordDetails?.subCategory ?? '';
    SelectDialog.showModal<String>(
      context,
      constraints: BoxConstraints.loose(Size.fromHeight(AppHeight.h50Percent)),
      label: "Please select category to continue",
      showSearchBox: false,
      selectedValue: selectedCategory,
      items: categories,
      onChange: (String selected) {
        setState(() {
          selectedCategory = selected;
          print(selected);
        });
        const ListTileRatingBar();
        onUpdateCategory(context,
        primary: categoryType.name, subCategory: selected);
      },
    );
  }

  void onUpdateCategory(
    BuildContext context, {
    required String? primary,
    required String? subCategory,
  }) {
    final provider = Provider.of<RecordTileProvider>(context, listen: false);

    provider.updateCategory(
      primary: primary,
      subCategory: subCategory,
    );
  }
}
