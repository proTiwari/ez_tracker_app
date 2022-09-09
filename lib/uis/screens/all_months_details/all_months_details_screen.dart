
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:share_extend/share_extend.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:ui';
import 'package:expandable/expandable.dart';
import 'package:ez_tracker_app/resources/color_manager.dart';
import 'package:ez_tracker_app/resources/values_manager.dart';
import 'package:ez_tracker_app/uis/screens/all_months_details/widgets/all_months_detail_appbar.dart';
import 'package:ez_tracker_app/uis/screens/all_months_details/widgets/build_elevated_button.dart';
import 'package:ez_tracker_app/uis/screens/all_months_details/widgets/widget_to_image.dart';
import 'package:ez_tracker_app/uis/widgets/app_drawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:path_provider/path_provider.dart';
import '../../../services/firestore_service.dart';
import '../../../utils/boundarytoimage.dart';
import 'package:pdf/pdf.dart';

class AllMonthsDetailsScreen extends StatefulWidget {
  const AllMonthsDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AllMonthsDetailsScreen> createState() => _AllMonthsDetailsScreenState();
}

class _AllMonthsDetailsScreenState extends State<AllMonthsDetailsScreen> {
  // GlobalKey _globalKey = new GlobalKey();

  bool inside = false;
  Uint8List? imageInMemory;

  late Uint8List image;

  List lis = [];
  Map<String, dynamic> reportMap = {};

  @override
  void initState() {
    super.initState();
    getReport();
  }

  Future<void> _capturePng(_globalKey) async {
    try {
      print('inside');
      inside = true;
      RenderRepaintBoundary boundary =
      _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        print("Waiting for boundary to be painted.");
        await Future.delayed(const Duration(milliseconds: 1));
        return _capturePng(_globalKey);
      }
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      final directory = (await getExternalStorageDirectory())?.path;
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes!);
      final RenderBox box = context.findRenderObject() as RenderBox;
      // ShareExtend.share(directory!, "image");
      String bs64 = base64Encode(pngBytes);
      final pdf = pw.Document();
      final imagepdf = pw.MemoryImage(
        pngBytes,
      );
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Center(
          child: pw.Image(imagepdf),
        ); // Center
      }));





      // final pdf = pw.Document();
      //
      // pdf.addPage(pw.Page(
      //     pageFormat: PdfPageFormat.a4,
      //     build: (pw.Context context) {
      //       return '';
      //       // return pw.Center(
      //       //   child: pw.Text("Hello World"),
      //       // ); // Center
      //     }));
      //
      // PdfImage image = PdfImage(
      //     pdf,
      //     image: pngBytes, width: 1800, height: 1400,
      //     );

      // ShareExtend.share(, "image");

      // ShareExtend.share("share text", "text");
      print(pngBytes);
      print(bs64);
      print('png done');
      setState(() {
        inside = false;
      });

    } catch (e) {
      print(e);
    }
  }
  // Future<Uint8List?> _capturePng(key) async {
  //   RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
  //
  //   if (boundary.debugNeedsPaint) {
  //     print("Waiting for boundary to be painted.");
  //     await Future.delayed(const Duration(milliseconds: 1));
  //     return _capturePng(key);
  //   }
  //
  //   var image = await boundary.toImage();
  //   var byteData = await image.toByteData(format: ImageByteFormat.png);
  //
  //   return byteData?.buffer.asUint8List();
  // }
  //
  // void _printPngBytes() async {
  //   var pngBytes = await _capturePng(key1);
  //   var bs64 = base64Encode(pngBytes!);
  //   print(pngBytes);
  //   print(bs64);
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: const MonthDetailAppbar(),
        drawer: const AppDrawer(),
        body: ListView.builder(
            itemCount: int.parse(reportMap.length.toString()),
            itemBuilder: (context, index) {
              GlobalKey _globalKey = new GlobalKey();
              return WidgetToImage(
                builder: (_globalKey){
                  // this.key1 = key;
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
                        padding:
                            EdgeInsets.symmetric(horizontal: AppPadding.p15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${(reportMap.keys.elementAt(index))}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${reportMap.values.elementAt(index)['drive']} Drive . ${reportMap.values.elementAt(index)['distance']} Miles',
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
                              children: [
                                Text(
                                  '\$${reportMap.values.elementAt(index)['potential']}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 24, 127, 28),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${reportMap.values.elementAt(index)['complete']}% Complete',
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
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Column(
                          children: [
                            Divider(
                              color: ColorManager.black
                                  .withOpacity(OpacityConst.o3),
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
                                          sections: showingSections(index)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppWidth.w15),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: AppSize.s10,
                                          width: AppSize.s10,
                                          decoration: const BoxDecoration(
                                              color: Colors.blue),
                                        ),
                                        SizedBox(width: AppWidth.w15),
                                        const Text("Business Drives"),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 160, 0, 0),
                                        ),
                                        Text("${''} \n ${''} \n ${''}"),
                                      ],
                                    ),
                                  ],
                                )),
                              ],
                            ),
                                GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap:() => _capturePng(_globalKey),
                                child: AbsorbPointer(
                                    child: const BuildElevatedButton(
                                        icon: Icon(
                                          Icons.sim_card,
                                          color: Color.fromARGB(255, 15, 76, 126),
                                        ),
                                        title: 'Send July Report',
                                        titleColor: Colors.blue,
                                        bgColor: Colors.white,
                                      ),
                                )),


                            // child: const BuildElevatedButton(
                            //   icon: Icon(
                            //     Icons.sim_card,
                            //     color: Color.fromARGB(255, 15, 76, 126),
                            //   ),
                            //   title: 'Send July Report',
                            //   titleColor: Colors.blue,
                            //   bgColor: Colors.white,
                            // ),

                            const SizedBox(height: 12),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: (){},
                              child: AbsorbPointer(
                                child: BuildElevatedButton(
                                  icon: Container(
                                    alignment: Alignment.center,
                                    height: 25,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.navigate_next,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  title: 'Go to July Drives',
                                  titleColor: Colors.white,
                                  bgColor: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                  }
              );
            }));
  }

  List<PieChartSectionData> showingSections(ind) {
    return List.generate(2, (index) {
      switch (index) {
        case 0:
          print(
              'personal ${double.parse(reportMap.values.elementAt(ind)['business'].toString())}');
          print(
              'personal ${(double.parse(reportMap.values.elementAt(ind)['business'].toString()) + double.parse(reportMap.values.elementAt(ind)['personal'].toString()))}');

          print(100 *
              (double.parse(
                      reportMap.values.elementAt(ind)['business'].toString()) /
                  (double.parse(reportMap.values
                          .elementAt(ind)['business']
                          .toString()) +
                      double.parse(reportMap.values
                          .elementAt(ind)['personal']
                          .toString()))));
          return PieChartSectionData(
            color: Colors.blue,
            value: 100 *
                (double.parse(reportMap.values
                        .elementAt(ind)['business']
                        .toString()) /
                    (double.parse(reportMap.values
                            .elementAt(ind)['business']
                            .toString()) +
                        double.parse(reportMap.values
                            .elementAt(ind)['personal']
                            .toString()))),
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
          print(
              'business ${double.parse(reportMap.values.elementAt(ind)['business'].toString())}');
          print(100 *
              (double.parse(
                      reportMap.values.elementAt(ind)['personal'].toString()) /
                  (double.parse(reportMap.values
                          .elementAt(ind)['business']
                          .toString()) +
                      double.parse(reportMap.values
                          .elementAt(ind)['personal']
                          .toString()))));
          return PieChartSectionData(
            color: Colors.red,
            value: 100 *
                (double.parse(reportMap.values
                        .elementAt(ind)['personal']
                        .toString()) /
                    (double.parse(reportMap.values
                            .elementAt(ind)['business']
                            .toString()) +
                        double.parse(reportMap.values
                            .elementAt(ind)['personal']
                            .toString()))),
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

  Future getReport() async {
    DateTime dateTime = DateTime.now();

    var month = dateTime.month;

    var percentageComp = 0;

    var janbusiness = 0;
    var janpersonal = 0;

    var febbusiness = 0;
    var febpersonal = 0;

    var marchbusiness = 0;
    var marchpersonal = 0;

    var aprilbusiness = 0;
    var aprilpersonal = 0;

    var maybusiness = 0;
    var maypersonal = 0;

    var junebusiness = 0;
    var junepersonal = 0;

    var julybusiness = 0;
    var julypersonal = 0;

    var augbusiness = 0;
    var augpersonal = 0;

    var sepbusiness = 0;
    var seppersonal = 0;

    var octbusiness = 0;
    var octpersonal = 0;

    var novbusiness = 0;
    var novpersonal = 0;

    var decbusiness = 0;
    var decpersonal = 0;

    num janStar = 0;
    num febStar = 0;
    num marchStar = 0;
    num aprilStar = 0;
    num mayStar = 0;
    num juneStar = 0;
    num julyStar = 0;
    num augustStar = 0;
    num sepStar = 0;
    num octStar = 0;
    num novStar = 0;
    num decStar = 0;

    var janDis = 0.0;
    var febDis = 0.0;
    var marchDis = 0.0;
    var aprilDis = 0.0;
    var mayDis = 0.0;
    var juneDis = 0.0;
    var julyDis = 0.0;
    var augDis = 0.0;
    var sepDis = 0.0;
    var octDis = 0.0;
    var novDis = 0.0;
    var decDis = 0.0;

    List l = [];
    List janData = [];
    List febData = [];
    List marData = [];
    List aprilData = [];
    List mayData = [];
    List juneData = [];
    List julyData = [];
    List augData = [];
    List sepData = [];
    List octData = [];
    List novData = [];
    List decData = [];

    lis = await FireStoreService.instance.getReportFromFirebase();
    setState(() {
      lis;
      for (var i in lis) {
        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '01') {
          if (month == 1) {
            percentageComp = ((dateTime.day / 31) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          print("jan");
          janData.add(i);
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          var distance = calculateDistance(lat, lang, lat1, lang1);
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              janbusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              janpersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          janDis += distance;
          try {
            janStar = janStar + i['ratings'].toInt();
          } catch (e) {
            janStar = janStar + 0;
          }
          reportMap['january'] = {
            'personal': janpersonal,
            'business': janbusiness,
            'complete': percentageComp,
            'potential': janStar * 100,
            'drive': janData.length,
            'distance':
                double.parse((janDis * 0.6213711922).toStringAsFixed(2)),
            'data': janData,
          };
        }

        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '02') {
          print('february');
          if (month == 2) {
            percentageComp = ((dateTime.day / 29) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          febData.add(i);
          print("feb");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              janbusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              janpersonal += 1;
            }
          } catch (e) {
            print("this is feb ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);

          febDis += distance;
          try {
            febStar = febStar + i['ratings'].toInt();
          } catch (e) {
            febStar = febStar + 0;
          }

          reportMap['february'] = {
            'business': febbusiness,
            'personal': febpersonal,
            'complete': percentageComp,
            'potential': febStar * 100,
            'drive': febData.length,
            'distance':
                double.parse((febDis * 0.6213711922).toStringAsFixed(2)),
            'data': febData,
          };
        }

        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '03') {
          if (month == 3) {
            percentageComp = ((dateTime.day / 31) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          marData.add(i);
          print("march");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              marchbusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              marchpersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);
          marchDis += distance;
          try {
            marchStar = marchStar + i['ratings'].toInt();
          } catch (e) {
            marchStar = marchStar + 0;
          }

          reportMap['march'] = {
            'personal': marchpersonal,
            'business': marchbusiness,
            'complete': percentageComp,
            'potential': marchStar * 100,
            'drive': marData.length,
            'distance':
                double.parse((marchDis * 0.6213711922).toStringAsFixed(2)),
            'data': marData,
          };
        }

        if ((i['source_details']['created_date'].toString().substring(5, 7)) ==
            '04') {
          if (month == 4) {
            percentageComp = ((dateTime.day / 30) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          aprilData.add(i);
          print("april");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              aprilbusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              aprilpersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);
          aprilDis += distance;
          try {
            aprilStar = aprilStar + i['ratings'].toInt();
          } catch (e) {
            aprilStar = aprilStar + 0;
          }

          reportMap['april'] = {
            'personal': aprilpersonal,
            'business': aprilbusiness,
            'complete': percentageComp,
            'potential': aprilStar * 100,
            'drive': aprilData.length,
            'distance':
                double.parse((aprilDis * 0.6213711922).toStringAsFixed(2)),
            'data': aprilData,
          };
        }

        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '05') {
          if (month == 5) {
            percentageComp = ((dateTime.day / 31) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          mayData.add(i);
          print("may");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              maybusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              maypersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);
          mayDis += distance;
          try {
            mayStar = mayStar + i['ratings'].toInt();
          } catch (e) {
            mayStar = mayStar + 0;
          }

          reportMap['may'] = {
            'personal': maypersonal,
            'business': maybusiness,
            'complete': percentageComp,
            'potential': mayStar * 100,
            'drive': mayData.length,
            'distance':
                double.parse((mayDis * 0.6213711922).toStringAsFixed(2)),
            'data': mayData,
          };
        }

        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '06') {
          juneData.add(i);
          if (month == 6) {
            percentageComp = ((dateTime.day / 30) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          print("june");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              junebusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              junepersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);
          juneDis += distance;
          try {
            juneStar = juneStar + i['ratings'].toInt();
          } catch (e) {
            juneStar = juneStar + 0;
          }

          reportMap['june'] = {
            'personal': junepersonal,
            'business': junebusiness,
            'complete': percentageComp,
            'potential': juneStar * 100,
            'drive': juneData.length,
            'distance':
                double.parse((juneDis * 0.6213711922).toStringAsFixed(2)),
            'data': juneData,
          };
        }

        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '07') {
          if (month == 7) {
            percentageComp = ((dateTime.day / 31) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          julyData.add(i);
          print("july");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              julybusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              julypersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);
          julyDis += distance;
          try {
            julyStar = julyStar + i['ratings'].toInt();
          } catch (e) {
            julyStar = julyStar + 0;
          }

          reportMap['july'] = {
            'personal': julypersonal,
            'business': julybusiness,
            'complete': percentageComp,
            'potential': julyStar * 100,
            'drive': julyData.length,
            'distance':
                double.parse((julyDis * 0.6213711922).toStringAsFixed(2)),
            'data': julyData,
          };
        }

        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '08') {
          if (month == 8) {
            percentageComp = ((dateTime.day / 31) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          augData.add(i);
          print("aug");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              augbusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              augpersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);
          augDis += distance;
          try {
            augustStar = augustStar + i['ratings'].toInt();
          } catch (e) {
            augustStar = augustStar + 0;
          }

          reportMap['august'] = {
            'personal': augpersonal,
            'business': augbusiness,
            'complete': percentageComp,
            'potential': augustStar * 100,
            'drive': augData.length,
            'distance':
                double.parse((augDis * 0.6213711922).toStringAsFixed(2)),
            'data': augData,
          };
        }
        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '09') {
          if (month == 9) {
            percentageComp = ((dateTime.day / 30) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          sepData.add(i);
          print("sep");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          var distance = calculateDistance(lat, lang, lat1, lang1);
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              sepbusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              seppersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          sepDis += distance;
          try {
            sepStar = sepStar + i['ratings'].toInt();
            print('sepStar: ${sepStar}');
          } catch (e) {
            sepStar = sepStar + 0;
            print(e);
          }

          reportMap['september'] = {
            'personal': seppersonal,
            'business': sepbusiness,
            'complete': percentageComp,
            'potential': sepStar * 100,
            'drive': sepData.length,
            'distance':
                double.parse((sepDis * 0.6213711922).toStringAsFixed(2)),
            'data': sepData,
          };
        }

        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '10') {
          if (month == 10) {
            percentageComp = ((dateTime.day / 31) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          print("oct");
          octData.add(i);
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              octbusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              octpersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);
          octDis += distance;
          try {
            octStar = octStar + i['ratings'].toInt();
          } catch (e) {
            octStar = octStar + 0;
          }

          reportMap['october'] = {
            'personal': octpersonal,
            'business': octbusiness,
            'complete': percentageComp,
            'potential': octStar * 100,
            'drive': octData.length,
            'distance':
                double.parse((octDis * 0.6213711922).toStringAsFixed(2)),
            'data': octData,
          };
        }
        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '11') {
          if (month == 11) {
            percentageComp = ((dateTime.day / 30) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          novData.add(i);
          print("nov");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              novbusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              novpersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);
          novDis += distance;
          try {
            novStar = novStar + i['ratings'].toInt();
          } catch (e) {
            novStar = novStar + 0;
          }

          reportMap['november'] = {
            'personal': novpersonal,
            'business': novbusiness,
            'complete': percentageComp,
            'potential': novStar * 100,
            'drive': novData.length,
            'distance':
                double.parse((novDis * 0.6213711922).toStringAsFixed(2)),
            'data': novData,
          };
        }

        if (i['source_details']['created_date'].toString().substring(5, 7) ==
            '12') {
          if (month == 12) {
            percentageComp = ((dateTime.day / 31) * 100).toInt();
          } else {
            percentageComp = 100;
          }
          decData.add(i);
          print("dec");
          var lat = i['destination_details']['latitude'].toString();
          var lang = i['destination_details']['longitude'].toString();
          var lat1 = i['source_details']['latitude'].toString();
          var lang1 = i['source_details']['longitude'].toString();
          try {
            if (i['primary_category'] == 'business') {
              print('present');
              decbusiness += 1;
            } else if (i['primary_category'] == 'personal') {
              print('personal data presen');
              decpersonal += 1;
            }
          } catch (e) {
            print("this is jan ${e}");
          }
          var distance = calculateDistance(lat, lang, lat1, lang1);
          decDis += distance;
          try {
            decStar = decStar + i['ratings'].toInt();
          } catch (e) {
            decStar = decStar + 0;
          }

          reportMap['december'] = {
            'personal': decpersonal,
            'business': decbusiness,
            'complete': percentageComp,
            'potential': decStar * 100,
            'drive': decData.length,
            'distance':
                double.parse((decDis * 0.6213711922).toStringAsFixed(2)),
            'data': decData,
          };
        }
      }

      printWrapped("${reportMap}");
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((double.parse(lat2) - double.parse(lat1)) * p) / 2 +
        c(double.parse(lat1) * p) *
            c(double.parse(lat2) * p) *
            (1 - c((double.parse(lon2) - double.parse(lon1)) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
