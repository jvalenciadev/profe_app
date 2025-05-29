import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';

enum RadioStatus { loading, playing, paused, error }

class RadioController extends GetxController with WidgetsBindingObserver {
  final _status = RadioStatus.loading.obs;
  late AudioHandler _audioHandler;

  RadioStatus get status => _status.value;
  bool get isLoading => _status.value == RadioStatus.loading;
  bool get isPlaying => _status.value == RadioStatus.playing;
  bool get hasError => _status.value == RadioStatus.error;
  //https://node-17.zeno.fm/7qzeshy6xf8uv.aac
  //https://emiteradio.com/proxy/minedu?mp=/stream
  final String streamUrl = 'https://node-17.zeno.fm/7qzeshy6xf8uv.aac';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  Future<void> _initialize() async {
    _status.value = RadioStatus.loading;

    try {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.speech());

      _audioHandler = await AudioService.init(
        builder: () => RadioAudioHandler(streamUrl),
        config: AudioServiceConfig(
          androidNotificationChannelId: 'com.minedu.profe.radio',
          androidNotificationChannelName: 'Sintonía Educativo',
          androidNotificationOngoing: true,
          androidStopForegroundOnPause: true,
          androidNotificationClickStartsActivity: false,
          androidResumeOnClick: true,
        ),
      );

      _audioHandler.playbackState.listen((state) {
        if (state.processingState == AudioProcessingState.error) {
          _status.value = RadioStatus.error;
        } else {
          _status.value = state.playing ? RadioStatus.playing : RadioStatus.paused;
        }
      });

      // Solo inicializa, no empieces a reproducir
      // await _audioHandler.play(); // <-- Comentado para que inicie en estado detenido
    } catch (e) {
      print('Error initializing audio: \$e');
      _status.value = RadioStatus.error;
    }
  }

  void togglePlayPause() async {
    if (hasError || isLoading) return;

    try {
      if (isPlaying) {
        await _audioHandler.pause();
      } else {
        await _audioHandler.play();
      }
    } catch (e) {
      print('Error toggling playback: \$e');
      _status.value = RadioStatus.error;
    }
  }

  Future<void> retry() async {
    try {
      await _audioHandler.stop();
    } catch (_) {}
    await _initialize();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}

class RadioAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();
  final String streamUrl;

  RadioAudioHandler(this.streamUrl) {
    _player.playbackEventStream.listen((event) {
      playbackState.add(
        PlaybackState(
          controls: [
            _player.playing ? MediaControl.pause : MediaControl.play,
            MediaControl.stop,
          ],
          processingState: const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
          playing: _player.playing,
          androidCompactActionIndices: const [0],
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          updateTime: DateTime.now(),
        ),
      );
    }, onError: (e) {
      print('Stream error: \$e');
      playbackState.add(
        PlaybackState(
          processingState: AudioProcessingState.error,
          playing: false,
        ),
      );
    });

    _init();
  }

  Future<void> _init() async {
    try {
      // Metadatos para que Android muestre widget multimedia completo
      mediaItem.add(
        MediaItem(
          id: streamUrl,
          album: "Programa PROFE",
          title: "Sintonía Educativa",
          artist: "MINEDU",
          artUri: Uri.parse("https://profe.minedu.gob.bo/storage/profe/logo_radio.png"), // Cambia por tu logo
        ),
      );
      await _player.setUrl(streamUrl);
    } catch (e) {
      print('Error setting stream URL: \$e');
      playbackState.add(
        PlaybackState(
          processingState: AudioProcessingState.error,
          playing: false,
        ),
      );
    }
  }

  @override
  Future<void> play() async {
    try {
      if (_player.audioSource == null) await _init();
      await _player.play();
    } catch (e) {
      print('Play error: \$e');
    }
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();
}