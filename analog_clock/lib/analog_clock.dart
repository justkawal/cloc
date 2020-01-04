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
  Timer _timer;
  DateTime _dateTime = DateTime.now();
  String hour, minute, second;
  Map<String, dynamic> timeMap;
  Map<String, Map<String, dynamic>> startingPoint, stoppingPoint;
  bool isAnimating, stopMinute1, stopMinute2, isTellingTime;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    parseJsonFromAssets().then((onValue) {
      timeMap = onValue;
    }).then((v) {
      // Set the initial values.
      _updateModel();
      _updateTime();
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
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_dateTime);
      minute = DateFormat('mm').format(_dateTime);
      second = DateFormat('ss').format(_dateTime);
      print("printing hms");
      print(hour);
      print(minute);
      print(second);
      /* _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location; */
    });
  }

  Future<Map<String, dynamic>> parseJsonFromAssets() async {
    return rootBundle
        .loadString('mapFiles/time.json')
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  void _updateTime() {
    setState(() {
      _dateTime = _now = DateTime.now();

      hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_dateTime);
      minute = DateFormat('mm').format(_dateTime);
      second = DateFormat('ss').format(_dateTime);
      print("printing hms");
      print(hour);
      print(minute);
      print(second);

      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
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
      properties: SemanticsProperties(label: 'Analog clock with time.'
          // value: time,
          ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
              child: new Row(children: <Widget>[
            for (int i = 1; i <= 17; i++) getSimpleClock(id: i.toString())
          ])
              /* Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
              ],
            ), */
              ),
          Flexible(
              child: Row(children: <Widget>[
            for (int i = 18; i <= 34; i++) getSimpleClock(id: i.toString())
          ])

              /* Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
              ],
            ), */
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
              child: Row(children: <Widget>[
            for (int i = 60; i <= 76; i++) getSimpleClock(id: i.toString())
          ]) /* Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
              ],
            ), */
              ),
          Flexible(
              child: Row(children: <Widget>[
            for (int i = 77; i <= 93; i++) getSimpleClock(id: i.toString())
          ]) /* Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
                getSimpleClock(),
              ],
            ), */
              ),
        ],
      ),
    );
  }

  int getMinute(String key, String id, int index) {
    //print("timeMap:" + timeMap.toString());
    if (key != "other" && timeMap != null && timeMap.containsKey("time")) {
      return timeMap["time"]["2"][id][index];
    } else {
      return 37;
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
