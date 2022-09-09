// ignore_for_file: unused_field

import 'package:expandable/expandable.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:ez_tracker_app/uis/screens/all_months_details/widgets/all_months_detail_appbar.dart';
import 'package:ez_tracker_app/uis/screens/all_months_details/widgets/build_elevated_button.dart';
import 'package:ez_tracker_app/uis/widgets/app_drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AllMonthsDetailsScreen extends StatefulWidget {
  const AllMonthsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AllMonthsDetailsScreen> createState() => _AllMonthsDetailsScreenState();
}

class _AllMonthsDetailsScreenState extends State<AllMonthsDetailsScreen> {
  List<_ChartData> data = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MonthDetailAppbar(),
        drawer: const AppDrawer(),
        body: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5,
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: ExpandablePanel(
                  key: const Key('expandablePanel'),
                  theme: const ExpandableThemeData(
                    tapHeaderToExpand: true,
                    hasIcon: false,

                    // iconColor: Colors.black,
                  ),
                  header: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.p15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'July',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '1 Drive . 3 Miles',
                              style: TextStyle(
                                color: Color.fromARGB(255, 56, 55, 55),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text(
                              '\$2.08',
                              style: TextStyle(
                                color: Color.fromARGB(255, 24, 127, 28),
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '100% Complete',
                              style: TextStyle(
                                color: Color.fromARGB(255, 24, 127, 28),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  collapsed: const Text(
                    "",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  expanded: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Divider(
                          color:
                              ColorManager.black.withOpacity(OpacityConst.o3),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 0.7,
                                child: PieChart(
                                  PieChartData(
                                      pieTouchData: PieTouchData(),
                                      startDegreeOffset: 0,
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      sectionsSpace: 1,
                                      centerSpaceRadius: 0,
                                      sections: showingSections()),
                                ),
                              ),
                            ),
                            SizedBox(width: AppWidth.w15),
                            Expanded(
                                child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: AppSize.s10,
                                      width: AppSize.s10,
                                      decoration: const BoxDecoration(
                                          color: Colors.blue),
                                    ),
                                    SizedBox(width: AppWidth.w15),
                                    const Text("Bussiness Drives"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: AppSize.s10,
                                      width: AppSize.s10,
                                      decoration: const BoxDecoration(
                                          color: Colors.red),
                                    ),
                                    SizedBox(width: AppWidth.w15),
                                    const Text("Personal Drives"),
                                  ],
                                ),
                              ],
                            )),
                          ],
                        ),
                        const BuildElevatedButton(
                          icon: Icon(
                            Icons.sim_card,
                            color: Color.fromARGB(255, 15, 76, 126),
                          ),
                          title: 'Send July Report',
                          titleColor: Colors.blue,
                          bgColor: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        BuildElevatedButton(
                          icon: Container(
                            alignment: Alignment.center,
                            height: 25,
                            width: 25,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(
                              Icons.navigate_next,
                              color: Colors.blue,
                            ),
                          ),
                          title: 'Go to July Drives',
                          titleColor: Colors.white,
                          bgColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (index) {
      switch (index) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 80.0,
            radius: 80,
            title: "",
            titleStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            titlePositionPercentageOffset: 0.99,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: 20.0,
            radius: 80,
            title: "",
            titleStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            titlePositionPercentageOffset: 0.99,
          );

        default:
          return PieChartSectionData();
      }
    });
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final String x;
  final double y;
}
