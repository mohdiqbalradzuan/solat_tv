import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solat_tv/globals.dart' as globals;

class VersionInfoWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _VersionInfoWidgetState();
}

class _VersionInfoWidgetState extends State<VersionInfoWidget> {
  static const platform = const MethodChannel('samples.flutter.dev/solat_tv');
  String gitHash = '';
  String gitTag = '';

  @override
  void initState() {
    this._getGitInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: globals.versionInfoPadding,
      right: globals.switchThemePadding - 12,
      child: Text('Version info: $gitTag',
          style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 10,
          )),
    );
  }

  _getGitInfo() async {
    await platform.invokeMethod('getGitHash').then((value) => setState(() {
          this.gitHash = value;
        }));

    await platform.invokeMethod('getGitTag').then((value) => setState(() {
          this.gitTag = value;
        }));
  }
}
