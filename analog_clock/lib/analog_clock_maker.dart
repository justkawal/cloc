import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'drawn_hand.dart';

class AnalogClockMaker extends StatefulWidget {
  final int freeBlack, freeBlue;
  final double blackMin, blueMin;
  final Color primaryColor, highlightColor, accentColor;

  const AnalogClockMaker({
    @required this.blackMin,
    @required this.blueMin,
    @required this.freeBlack,
    @required this.freeBlue,
    @required this.primaryColor,
    @required this.accentColor,
    @required this.highlightColor,
  });

  @override
  _AnalogClockMakerState createState() => _AnalogClockMakerState();
}

class _AnalogClockMakerState extends State<AnalogClockMaker> {
  double blackMinutes = 37.0, blueMinutes = 37.0, anim1, anim2;
  int freeBlack, freeBlue, changeAnimation;
  Color primaryColor, highlightColor, accentColor;

  @override
  void initState() {
    super.initState();
    blackMinutes = widget.blackMin;
    blueMinutes = widget.blueMin;
    freeBlack = widget.freeBlack;
    freeBlue = widget.freeBlue;
    primaryColor = widget.primaryColor;
    highlightColor = widget.highlightColor;
    accentColor = widget.accentColor;

    Timer.periodic(Duration(milliseconds: 30), (Timer timer) {
      if (mounted) {
        if (widget.freeBlack == 1 && widget.freeBlue == 1) {
          if (blackMinutes == 59.5)
            blackMinutes = 0.0;
          else
            blackMinutes += 0.5;
          if (blueMinutes == 59.5)
            blueMinutes = 0.0;
          else
            blueMinutes += 0.5;
        } else {
          if (blackMinutes != widget.blackMin) {
            if (blackMinutes == 59.5)
              blackMinutes = 0.0;
            else
              blackMinutes += 0.5;
          }
          if (blueMinutes != widget.blueMin) {
            if (blueMinutes == 59.5)
              blueMinutes = 0.0;
            else
              blueMinutes += 0.5;
          }
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: widget.primaryColor),
            color: Colors.transparent,
            shape: BoxShape.circle),
        child: Stack(
          children: [
            // Example of a hand drawn with [CustomPainter].
            DrawnHand(
              color: widget.accentColor,
              thickness: 3,
              size: 0.94,
              angleRadians: blackMinutes * radians(360 / 60),
            ),
            DrawnHand(
              color: widget.highlightColor,
              thickness: 3,
              size: 0.94,
              angleRadians: blueMinutes * radians(360 / 60),
            ),
          ],
        ),
      ),
    );
  }
}
