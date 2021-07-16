import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:solat_tv/src/business_logic/blocs/solat_timer_blocs.dart';
import 'package:solat_tv/src/views/ui/widget/clock_painter.dart';

class AzanClockWidget extends StatefulWidget {
  final double _width;

  AzanClockWidget(this._width);

  @override
  State<StatefulWidget> createState() => _AzanClockWidgetState();
}

class _AzanClockWidgetState extends State<AzanClockWidget> {
  final _timerController = Get.put(SolatTimerBlocs());

  @override
  void initState() {
    this._timerController.startClockTimer();
    super.initState();
  }

  @override
  void dispose() {
    this._timerController.stopClockTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            StreamBuilder(
              stream: this._timerController.currentTime.stream,
              builder: (context, AsyncSnapshot snapshot) {
                var now = DateTime.now();

                return Text(
                  '${DateFormat('EEEE').format(now)} - ${this._timerController.showTime('HH:mm:ss', now)}',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget._width / 12.0,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                );
              },
            ),
            Text(
              '${HijriCalendar.now().toFormat('dd MMMM yyyy')}',
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: widget._width / 18.0,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            Text(
              '${DateFormat('dd MMMM yyyy').format(now)}',
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontSize: widget._width / 20.0,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        SizedBox(height: 30),
        StreamBuilder(
          stream: this._timerController.currentTime.stream,
          builder: (context, AsyncSnapshot snapshot) {
            return _buildClock(widget._width * 0.85);
          },
        ),
      ],
    );
  }

  Widget _buildClock(double width) {
    return Stack(
      children: [
        Container(
          width: width,
          height: width,
          child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(
              painter: ClockPainter(context, DateTime.now()),
            ),
          ),
        ),
        CircularPercentIndicator(
          radius: width * 1,
          lineWidth: 5.0,
          percent: this._timerController.percent,
          circularStrokeCap: CircularStrokeCap.round,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
            ],
            tileMode: TileMode.decal,
          ),
          animationDuration: 1000,
          animateFromLastPercent: true,
          rotateLinearGradient: true,
        )
      ],
    );
  }
}
