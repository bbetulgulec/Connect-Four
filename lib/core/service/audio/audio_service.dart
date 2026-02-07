import 'package:audioplayers/audioplayers.dart';

final AudioPlayer globalPlayer = AudioPlayer();

bool _isMusicStarted = false;

Future<void> playBackgroundMusic() async {
  if (_isMusicStarted) return;

  _isMusicStarted = true;

  await globalPlayer.setReleaseMode(ReleaseMode.loop);
  await globalPlayer.play(
    AssetSource('wav/squeaky_computer_chair.wav'),
    volume: 1.0,
  );
}

Future<void> stopBackgroundMusic() async {
  _isMusicStarted = false;
  await globalPlayer.stop();
}
