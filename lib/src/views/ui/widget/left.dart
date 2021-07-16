import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:solat_tv/src/views/ui/widget/azan_clock.dart';
import 'package:solat_tv/globals.dart' as globals;

class LeftWidget extends StatefulWidget {
  final double _width;

  LeftWidget(this._width);

  @override
  State<StatefulWidget> createState() => _LeftState();
}

class _LeftState extends State<LeftWidget> {
  double _latitude;
  double _longitude;
  Address _currentAddress;

  @override
  void initState() {
    _getLastKnownPosition();
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
        Text(
            '${this._currentAddress == null ? 'Initializing....' : '${this._currentAddress.subLocality}, ${this._currentAddress.locality}, ${this._currentAddress.countryCode}'}'),
        AzanClockWidget(widget._width),
      ],
    );
  }

  void _getLastKnownPosition() async {
    await Geolocator.getLastKnownPosition().then(
      (value) => setState(() {
        if (value != null) {
          this._latitude = value.latitude;
          this._longitude = value.longitude;
        }
      }),
    );

    var coordinates = new Coordinates(this._latitude != null ? this._latitude : globals.defaultLat, this._longitude != null ? this._longitude : globals.defaultLong);

    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    if (addresses.length > 0 && addresses != null) {
      setState(() {
        this._currentAddress = addresses.first;
      });
    }
  }
}
