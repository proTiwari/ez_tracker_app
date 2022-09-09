import 'package:flutter/material.dart';

class BuildElevatedButton extends StatelessWidget {
  final Widget icon;
  final String title;
  final Color titleColor;
  final Color bgColor;
  const BuildElevatedButton({Key? key, required this.icon, required this.title, required this.titleColor, required this.bgColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(bgColor),
          ),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 5),
              Text(
                title,
                style: TextStyle(color: titleColor, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
