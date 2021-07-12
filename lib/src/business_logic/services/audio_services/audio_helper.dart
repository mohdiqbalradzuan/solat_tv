import 'package:audioplayers/audioplayers.dart';

class AudioHelper {
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  void playAzan() async {
    audioCache.play('audio/azan_makkah.mp3');
  }
}