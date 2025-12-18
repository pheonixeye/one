import 'package:one/assets/assets.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class SoundHelper {
  SoundHelper._() {
    _initLocalFileBytes();
  }

  static final SoundHelper _instance = SoundHelper._();

  factory SoundHelper() {
    return _instance;
  }

  static Uint8List? _assetSoundBytes;

  static Future<void> _initLocalFileBytes() async {
    if (_assetSoundBytes == null) {
      final data = await rootBundle.load(AppAssets.notification_sound);
      _assetSoundBytes = Uint8List.sublistView(data);
    }
  }

  static Future<void> playSound(AudioPlayer player, [Uint8List? bytes]) async {
    if (_assetSoundBytes != null && bytes == null) {
      await player.setAudioSource(BytesSource(_assetSoundBytes!));
      player.play();
    } else if (bytes != null) {
      await player.setAudioSource(BytesSource(bytes));
      player.play();
    }
  }

  static Future<void> playBytes(AudioPlayer player, [Uint8List? bytes]) async {
    if (bytes != null) {
      await player.setAudioSource(BytesSource(bytes));
      player.play();
    }
  }
}

class BytesSource extends StreamAudioSource {
  final Uint8List bytes;
  final String contentType; // e.g., 'audio/mpeg' for MP3

  BytesSource(this.bytes, {this.contentType = 'audio/mpeg'});

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: contentType,
    );
  }
}

// Example usage:
// void playBytes(Uint8List audioBytes, String contentType) async {
//   final player = AudioPlayer();
//   await player
//       .setAudioSource(BytesSource(audioBytes, contentType: contentType));
//   player.play();
// }
