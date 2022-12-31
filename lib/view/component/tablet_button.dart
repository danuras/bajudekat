import 'package:flutter/material.dart';

class TabletButton extends StatelessWidget {
  TabletButton({required this.text, required this.action, super.key});
  VoidCallback action;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
      decoration: const BoxDecoration(
        color: Color(0xff737fb3),
      ),
      child: InkWell(
        onTap: () {
          action();
        },
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
