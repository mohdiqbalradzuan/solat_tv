import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:solat_tv/src/business_logic/blocs/solat_timer_blocs.dart';
import 'package:solat_tv/src/views/ui/widget/clock_painter.dart';

class ClockBuilderWidget extends StatefulWidget {
  final double width;

  ClockBuilderWidget(this.width);

  @override
  State<StatefulWidget> createState() => _ClockBuilderWidgetState();
}

class _ClockBuilderWidgetState extends State<ClockBuilderWidget> {
  final timerController = Get.put(SolatTimerBlocs());

  @override
  void initState() {
    timerController.startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timerController.stopTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Location information here"),
            StreamBuilder(
              stream: timerController.currentTime.stream,
              builder: (context, AsyncSnapshot snapshot) {
                return Text(
                  '${timerController.formatTime(DateTime.now().hour)}:${timerController.formatTime(DateTime.now().minute)}:${timerController.formatTime(DateTime.now().second)}',
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: widget.width / 10.0,
                        fontWeight: FontWeight.w300,
                      ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 40),
        StreamBuilder(
          stream: timerController.currentTime.stream,
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return _buildClock();
            }

            return _buildClock();
          },
        ),
      ],
    );
  }

  Widget _buildClock() {
    return Stack(
      children: [
        Container(
          width: widget.width,
          height: widget.width,
          child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(
              painter: ClockPainter(context, DateTime.now()),
            ),
          ),
        ),
        CircularPercentIndicator(
          radius: widget.width * 1,
          lineWidth: 5.0,
          percent: timerController.percent,
          circularStrokeCap: CircularStrokeCap.square,
          backgroundColor: Theme.of(context).canvasColor,
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
          // center: Container(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         '${timerController.formatTime(DateTime.now().hour)}:${timerController.formatTime(DateTime.now().minute)}:${timerController.formatTime(DateTime.now().second)}',
          //         style: Theme.of(context).textTheme.headline1.copyWith(
          //           fontSize: widget.width / 10.0,
          //           fontWeight: FontWeight.w400,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        )
      ],
    );
  }
}
