import 'package:flutter/material.dart';
import 'package:baju_dekat/model/information.dart';

class Footer extends StatelessWidget {
  const Footer(this._information, {super.key});
  final Information _information;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _information.short_description,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
