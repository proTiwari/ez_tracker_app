import 'package:flutter/material.dart';

class MonthsDetailsHeaders extends StatelessWidget {
  const MonthsDetailsHeaders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
        )
      ],
    );
  }
}
