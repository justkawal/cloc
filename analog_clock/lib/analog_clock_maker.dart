import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'drawn_hand.dart';

class AnalogClockMaker extends StatefulWidget {
  final int freeBlack, freeBlue;
  final double blackMin, blueMin;
  final customTheme;

  const AnalogClockMaker({
    @required this.customTheme,
    @required this.blackMin,
    @required this.blueMin,
    @required this.freeBlack,
    @required this.freeBlue,
  });

  @override
  _AnalogClockMakerState createState() => _AnalogClockMakerState();
}

class _AnalogClockMakerState extends State<AnalogClockMaker> {
  DateTime datetime;
  var customTheme;

  int second = 30, minute = 15;
  double blackMinutes = 0.0, blueMinutes = 0.0;
  int freeBlack, freeBlue;
  DateTime d = DateTime(2019, 1, 1, 9, 12, 15, 0);
  //_AnalogClockMakerState(datetime) : this.datetime = datetime ?? DateTime.now();

  initState() {
    super.initState();
    customTheme = widget.customTheme;
    blackMinutes = widget.blackMin;
    blueMinutes = widget.blueMin;
    freeBlack = widget.freeBlack;
    freeBlue = widget.freeBlue;

    // update clock every second or minute based on second hand's visibility.
    Timer.periodic(Duration(milliseconds: 30), (Timer timer) {
      if (mounted) {
        // update is only called on live clocks. So, it's safe to update datetime.
        /* if (second == 60) {
        //minute += 1;
        //print("plus 1 minute");
      } else {
        print("plus 30");
      } */
        if (widget.freeBlack == 1 && widget.freeBlue == 1) {
          if (blackMinutes == 59.5) {
            blackMinutes = 0.0;
          } else {
            blackMinutes += 0.5;
          }
          if (blueMinutes == 59.5) {
            blueMinutes = 0.0;
          } else {
            blueMinutes += 0.5;
          }
        } else {
          if (blackMinutes != widget.blackMin) {
            if (blackMinutes == 59.5) {
              blackMinutes = 0.0;
            } else {
              blackMinutes += 0.5;
            }
          }

          if (blueMinutes != widget.blueMin) {
            if (blueMinutes == 59.5) {
              blueMinutes = 0.0;
            } else {
              blueMinutes += 0.5;
            }
          }
        }
        /* if (widget.moveTogether) {
            blackMinutes -= second / 60;
            blueMinutes -= second / 60;
          } else {
            if (!widget.stopBlack) blackMinutes -= second / 60;
            if (!widget.stopBlue) blueMinutes += second / 60;
          }
          if (blackMinutes < 0.0) blackMinutes += 60;

          if (blueMinutes > 60.0) blueMinutes -= 60; */

        //d = DateTime(2019, 1, 1, 9, minute, second);
        //datetime = d; //DateTime.now();

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: customTheme.primaryColor),
            color: Colors.transparent,
            shape: BoxShape.circle),
        child: Stack(
          children: [
            // Example of a hand drawn with [CustomPainter].
            DrawnHand(
              color: customTheme.accentColor,
              thickness: 3,
              size: 0.94,
              angleRadians: blackMinutes * radians(360 / 60),
            ),
            DrawnHand(
              color: customTheme.highlightColor,
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
