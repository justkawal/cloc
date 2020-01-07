import 'dart:async';
import 'dart:convert';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/semantics.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'package:flutter/services.dart' show rootBundle;
import 'drawn_hand.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// A basic analog clock.
///
/// You can add more animations to make it better!
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now(), customTheme;
  Timer _timer, _timer1;
  DateTime _dateTime = DateTime.now();
  List<String> hourList, minuteList, secondList;
  Map<String, dynamic> timeMap, startingPoint, nextPoint;
  bool isAnimating,
      stopMinute1,
      stopMinute2,
      isTellingTime,
      is24Format,
      isTellingNextTime;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    parseJsonFromAssets().then((onValue) {
      timeMap = onValue;
      timeMap["time1"] =
          timeMap["time2"] = timeMap["time3"] = timeMap["time4"] = "";
    }).then((v) {
      // Set the initial values.
      _updateModel();
      _initiateTimeMachine();
    });
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer1?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      if (isTellingNextTime) {
        is24Format = widget.model.is24HourFormat;
      }
      /*   hourList = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_dateTime)
          .split("");
      minuteList = DateFormat('mm').format(_dateTime).split(""); */
      //second = DateFormat('ss').format(_dateTime);
      /* print("printing hms");
      print(hour);
      print(minute);
      print(second); */
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets() async {
    return rootBundle
        .loadString('mapFiles/time.json')
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  // Get whether to show animation or to show the time!!
  void _initiateTimeMachine() {
    _now = DateTime.now();
    if (_now.second >= 0 && _now.second <= 30) {
      /**
       * set the value of time here without showing the 
       * encircling animation so as to tell the use the time on the spot
       **/
      _dateTime = _now = DateTime.now();

      hourList = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_dateTime)
          .split("");
      startingPoint["time1"] = timeMap["time"][hourList[0]];
      startingPoint["time2"] = timeMap["time"][hourList[1]];

      minuteList = DateFormat('mm').format(_dateTime).split("");
      startingPoint["time3"] = timeMap["time"][hourList[0]];
      startingPoint["time4"] = timeMap["time"][hourList[1]];

      _timer1 = Timer(
        Duration(seconds: 30) - Duration(seconds: _now.second),
        _startAnimation,
      );
    } else if (_now.second > 30 && _now.second <= 56) {
    } else {}
  }

  void _startAnimation() {}

  void _updateTime() {
    setState(() {
      _dateTime = _now = DateTime.now();

      hourList = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_dateTime)
          .split("");
      timeMap["time1"] = hourList[0];
      timeMap["time2"] = hourList[1];

      minuteList = DateFormat('mm').format(_dateTime).split("");
      timeMap["time3"] = minuteList[0];
      timeMap["time4"] = minuteList[1];
      // second = DateFormat('ss').format(_dateTime);
      /*  print("printing hms");
      print(hour);
      print(minute);
      print(second); */

      // Update once per 30 milisecond. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(minutes: 1) - Duration(seconds: _now.second) - Duration(),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // There are many ways to apply themes to your clock. Some are:
    //  - Inherit the parent Theme (see ClockCustomizer in the
    //    flutter_clock_helper package).
    //  - Override the Theme.of(context).colorScheme.
    //  - Create your own [ThemeData], demonstrated in [AnalogClock].
    //  - Create a map of [Color]s to custom keys, demonstrated in
    //    [DigitalClock].
    customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Clock Circle.
            primaryColor: Colors.black12,
            // hand color.
            highlightColor: Colors.black,
            accentColor: Color(0xFF669DF6),
            backgroundColor: Colors.white)
        : Theme.of(context).copyWith(
            primaryColor: Colors.white12,
            highlightColor: Colors.white,
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Colors.black);

    return Semantics.fromProperties(
      properties: SemanticsProperties(label: 'Digital clock with time.'
          // value: time,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getSimpleClock(id: "1"),
                getSimpleClock(id: "2"),
                getSimpleClock(id: "3"),
                getSimpleClock(id: "4"),
                getSimpleClock(id: "5"),
                getSimpleClock(id: "6"),
                getSimpleClock(id: "7"),
                getSimpleClock(id: "8"),
                getSimpleClock(id: "9"),
                getSimpleClock(id: "10"),
                getSimpleClock(id: "11"),
                getSimpleClock(id: "12"),
                getSimpleClock(id: "13"),
                getSimpleClock(id: "14"),
                getSimpleClock(id: "15"),
                getSimpleClock(id: "16"),
                getSimpleClock(id: "17"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getSimpleClock(id: "18"),
                getSimpleClock(id: "19"),
                getSimpleClock(id: "20"),
                getSimpleClock(id: "21"),
                getSimpleClock(id: "22"),
                getSimpleClock(id: "23"),
                getSimpleClock(id: "24"),
                getSimpleClock(id: "25"),
                getSimpleClock(id: "26"),
                getSimpleClock(id: "27"),
                getSimpleClock(id: "28"),
                getSimpleClock(id: "29"),
                getSimpleClock(id: "30"),
                getSimpleClock(id: "31"),
                getSimpleClock(id: "32"),
                getSimpleClock(id: "33"),
                getSimpleClock(id: "34"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // layer 3
                getSimpleClock(id: "35"),
                getSimpleClock(id: "36"),
                // first time
                getSimpleClock(key: "time1", id: "1"),
                getSimpleClock(key: "time1", id: "2"),
                getSimpleClock(key: "time1", id: "3"),
                // second time
                getSimpleClock(key: "time2", id: "1"),
                getSimpleClock(key: "time2", id: "2"),
                getSimpleClock(key: "time2", id: "3"),
                // middle
                getSimpleClock(id: "37"),
                // third time
                getSimpleClock(key: "time3", id: "1"),
                getSimpleClock(key: "time3", id: "2"),
                getSimpleClock(key: "time3", id: "3"),
                // fourth time
                getSimpleClock(key: "time4", id: "1"),
                getSimpleClock(key: "time4", id: "2"),
                getSimpleClock(key: "time4", id: "3"),
                // boundary
                getSimpleClock(id: "38"),
                getSimpleClock(id: "39"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // layer 3
                getSimpleClock(id: "40"),
                getSimpleClock(id: "41"),
                // first time
                getSimpleClock(key: "time1", id: "4"),
                getSimpleClock(key: "time1", id: "5"),
                getSimpleClock(key: "time1", id: "6"),
                // second time
                getSimpleClock(key: "time2", id: "4"),
                getSimpleClock(key: "time2", id: "5"),
                getSimpleClock(key: "time2", id: "6"),
                // middle
                getSimpleClock(id: "42"),
                // third time
                getSimpleClock(key: "time3", id: "4"),
                getSimpleClock(key: "time3", id: "5"),
                getSimpleClock(key: "time3", id: "6"),
                // fourth time
                getSimpleClock(key: "time4", id: "4"),
                getSimpleClock(key: "time4", id: "5"),
                getSimpleClock(key: "time4", id: "6"),
                // boundary
                getSimpleClock(id: "43"),
                getSimpleClock(id: "44"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // layer 3
                getSimpleClock(id: "45"),
                getSimpleClock(id: "46"),
                // first time
                getSimpleClock(key: "time1", id: "7"),
                getSimpleClock(key: "time1", id: "8"),
                getSimpleClock(key: "time1", id: "9"),
                // second time
                getSimpleClock(key: "time2", id: "7"),
                getSimpleClock(key: "time2", id: "8"),
                getSimpleClock(key: "time2", id: "9"),
                // middle
                getSimpleClock(id: "47"),
                // third time
                getSimpleClock(key: "time3", id: "7"),
                getSimpleClock(key: "time3", id: "8"),
                getSimpleClock(key: "time3", id: "9"),
                // fourth time
                getSimpleClock(key: "time4", id: "7"),
                getSimpleClock(key: "time4", id: "8"),
                getSimpleClock(key: "time4", id: "9"),
                // boundary
                getSimpleClock(id: "48"),
                getSimpleClock(id: "49"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // layer 3
                getSimpleClock(id: "50"),
                getSimpleClock(id: "51"),
                // first time
                getSimpleClock(key: "time1", id: "10"),
                getSimpleClock(key: "time1", id: "11"),
                getSimpleClock(key: "time1", id: "12"),
                // second time
                getSimpleClock(key: "time2", id: "10"),
                getSimpleClock(key: "time2", id: "11"),
                getSimpleClock(key: "time2", id: "12"),
                // middle
                getSimpleClock(id: "52"),
                // third time
                getSimpleClock(key: "time3", id: "10"),
                getSimpleClock(key: "time3", id: "11"),
                getSimpleClock(key: "time3", id: "12"),
                // fourth time
                getSimpleClock(key: "time4", id: "10"),
                getSimpleClock(key: "time4", id: "11"),
                getSimpleClock(key: "time4", id: "12"),
                // boundary
                getSimpleClock(id: "53"),
                getSimpleClock(id: "54"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // layer 3
                getSimpleClock(id: "55"),
                getSimpleClock(id: "56"),
                // first time
                getSimpleClock(key: "time1", id: "13"),
                getSimpleClock(key: "time1", id: "14"),
                getSimpleClock(key: "time1", id: "15"),
                // second time
                getSimpleClock(key: "time2", id: "13"),
                getSimpleClock(key: "time2", id: "14"),
                getSimpleClock(key: "time2", id: "15"),
                // middle
                getSimpleClock(id: "57"),
                // third time
                getSimpleClock(key: "time3", id: "13"),
                getSimpleClock(key: "time3", id: "14"),
                getSimpleClock(key: "time3", id: "15"),
                // fourth time
                getSimpleClock(key: "time4", id: "13"),
                getSimpleClock(key: "time4", id: "14"),
                getSimpleClock(key: "time4", id: "15"),
                // boundary
                getSimpleClock(id: "58"),
                getSimpleClock(id: "59"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getSimpleClock(id: "60"),
                getSimpleClock(id: "61"),
                getSimpleClock(id: "62"),
                getSimpleClock(id: "63"),
                getSimpleClock(id: "64"),
                getSimpleClock(id: "65"),
                getSimpleClock(id: "66"),
                getSimpleClock(id: "67"),
                getSimpleClock(id: "68"),
                getSimpleClock(id: "69"),
                getSimpleClock(id: "70"),
                getSimpleClock(id: "71"),
                getSimpleClock(id: "72"),
                getSimpleClock(id: "73"),
                getSimpleClock(id: "74"),
                getSimpleClock(id: "75"),
                getSimpleClock(id: "76"),
              ],
            ),
          ),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getSimpleClock(id: "77"),
                getSimpleClock(id: "78"),
                getSimpleClock(id: "79"),
                getSimpleClock(id: "80"),
                getSimpleClock(id: "81"),
                getSimpleClock(id: "82"),
                getSimpleClock(id: "83"),
                getSimpleClock(id: "84"),
                getSimpleClock(id: "85"),
                getSimpleClock(id: "86"),
                getSimpleClock(id: "87"),
                getSimpleClock(id: "88"),
                getSimpleClock(id: "89"),
                getSimpleClock(id: "90"),
                getSimpleClock(id: "91"),
                getSimpleClock(id: "92"),
                getSimpleClock(id: "93"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double getMinute(String key, String id, int index) {
    if (key != "other" &&
        timeMap != null &&
        timeMap.containsKey("time") &&
        (key == "time1" ||
            key == "time2" ||
            key == "time3" ||
            key == "time4")) {
      /*  print(timeMap["time1"].toString() +
          timeMap["time2"].toString() +
          ":" +
          timeMap["time3"].toString() +
          timeMap["time4"].toString()); */
      /* if (timeMap["time"][timeMap[key]][id][index] == 59.5) {
        timeMap["time"][timeMap[key]][id][index]  = 0.0;
      } else
        timeMap["time"][timeMap[key]][id][index]  += 0.5; */
      //print(timeMap["time"]["2"][id][index].toString());
      return timeMap["time"][timeMap[key]][id][index] + 0.0;
    } else {
      return 37.0;
    }
  }

  Widget getSimpleClock({String key = "other", @required String id}) {
    //final time = DateFormat.Hms().format(DateTime.now());

    return Flexible(
      child: Container(
        //color: customTheme.backgroundColor,
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
              angleRadians: getMinute(key, id, 0) * radiansPerTick,
            ),
            DrawnHand(
              color: customTheme.highlightColor,
              thickness: 3,
              size: 0.94,
              angleRadians: getMinute(key, id, 1) * radiansPerTick,
            ),
          ],
        ),
      ),
    );
  }
}
