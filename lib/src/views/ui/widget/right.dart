import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solat_tv/src/views/ui/widget/azan_schedule.dart';

class RightWidget extends StatefulWidget {
  final double _width;

  RightWidget(this._width);

  @override
  State<StatefulWidget> createState() => _RightState();
}

class _RightState extends State<RightWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AzanScheduleWidget(widget._width),
      ],
    );
  }
}
