import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solat_tv/src/views/ui/widget/clock_builder.dart';

class LeftWidget extends StatefulWidget {
  final double width;

  LeftWidget(this.width);

  @override
  State<StatefulWidget> createState() => _LeftState();
}

class _LeftState extends State<LeftWidget> {
  String coordinateString;
  double latitude;
  double longitude;
  Address currentAddress;

  @override
  void initState() {
    _getLastKnownPosition();
    //super.initState();
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
        Text(
            "${currentAddress == null ? "Initializing...." : "${currentAddress.subLocality}, ${currentAddress.locality}, ${currentAddress.countryCode}"}"),
        ClockBuilderWidget(widget.width),
      ],
    );
  }

  void _getLastKnownPosition() async {
    await Geolocator.getLastKnownPosition().then(
      (value) => setState(() {
        if (value != null) {
          coordinateString = value.toString();
          latitude = value.latitude;
          longitude = value.longitude;
        }
      }),
    );

    final coordinates = new Coordinates(3.204946, 101.689958);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    if (addresses.length > 0 && addresses != null) {
      print("${addresses.first.subLocality} - ${addresses.first.locality}");
      currentAddress = addresses.first;
    }
  }
}
