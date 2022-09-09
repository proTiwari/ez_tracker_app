import 'package:ez_tracker_app/uis/screens/all_months_details/widgets/all_months_detail_header.dart';
import 'package:ez_tracker_app/uis/screens/all_months_details/widgets/build_elevated_button.dart';
import 'package:ez_tracker_app/uis/screens/all_months_details/widgets/build_text.dart';
import 'package:flutter/material.dart';

class MonthDetailsFirstContainer extends StatelessWidget {
  const MonthDetailsFirstContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          bottom: const BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      padding: const EdgeInsets.only(
        left: 20,
        top: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        children: [
          const MonthsDetailsHeaders(),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 24, 127, 28),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BuildText(
                title: '\$2.08',
                text: 'LOGGED',
              ),
              BuildText(
                title: '\$2.08',
                text: 'POTENTIAL',
              ),
            ],
          ),
          const SizedBox(height: 12),
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
            title: 'View/Edit All Drives',
            titleColor: Colors.white,
            bgColor: Colors.blue,
          )
        ],
      ),
    );
  }
}
