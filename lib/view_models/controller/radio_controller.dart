import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class RadioController extends GetxController {
  final AudioPlayer player = AudioPlayer();

  // Observables para estado
  final _isPlaying = false.obs;
  final _isLoading = true.obs;
  final _hasError = false.obs;

  // Getters públicos
  bool get isPlaying => _isPlaying.value;
  bool get isLoading => _isLoading.value;
  bool get hasError  => _hasError.value;

  // URL de streaming
  final String streamUrl = 'https://node-17.zeno.fm/7qzeshy6xf8uv.aac';

  @override
  void onInit() {
    super.onInit();
    // 1) Escucho el stream de estado de reproducción
    player.playingStream.listen((playing) {
      _isPlaying.value = playing;
    });

    // 2) Inicializo el stream
    initialize();
  }

  /// Inicializa o recarga la URL del stream.
  Future<void> initialize() async {
    _isLoading.value = true;
    try {
      // Solo setUrl la primera vez
      if (player.sequence == null || player.sequence!.isEmpty) {
        await player.setUrl(streamUrl);
      }
      _hasError.value = false;
    } catch (e) {
      _hasError.value = true;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Método público para reintentar la inicialización tras un error.
  Future<void> retry() => initialize();

  /// Play / Pause toggler
  void togglePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play().catchError((_) {
        // si falla al play, reintenta inicializar
        initialize();
      });
    }
    // Nota: no tocamos _isPlaying aquí; el listener de playingStream lo actualizará.
  }

  @override
  void onClose() {
    player.dispose(); // opcional si ya no lo necesitas cuando app cierra
    super.onClose();
  }
}
