import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VirtureLoading extends StatefulWidget {
  const VirtureLoading({super.key});

  @override
  State<VirtureLoading> createState() => _VirtureLoadingState();
}

class _VirtureLoadingState extends State<VirtureLoading> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SpinKitRotatingCircle(
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }
}
