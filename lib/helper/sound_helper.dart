import 'package:audioplayers/audioplayers.dart';
import 'package:tt_jig_ms/helper/helper.dart';

class SoundHelper {
  static final AudioPlayer _player = AudioPlayer()
    ..setReleaseMode(ReleaseMode.stop);

  static Future<void> success() async {
    await _player.play(AssetSource(AssetHelper.getSoundPath("Success.wav")));
  }

  static Future<void> fail() async {
    await _player.play(AssetSource(AssetHelper.getSoundPath("Failed.wav")));
  }
}
