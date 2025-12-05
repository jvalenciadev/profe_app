import 'dart:async';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:programa_profe/models/evento_opciones_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/response/api_response.dart';
import '../../data/response/status.dart';
import '../../models/evento_cuestionario_model.dart';
import '../../models/evento_model.dart';
import '../../models/persona_model.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';
import '../../view_models/controller/evento/evento_cuestionario_models.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late EventoModel evento;
  late Persona persona;
  late CuestionarioModel cuestionario;
  final CuestionarioController _ctrl = Get.put(CuestionarioController());

  List<Pregunta> questions = [];
  late int quizDurationMinutes;
  DateTime? startTime;
  int remainingTime = 0;
  Timer? timer;

  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false;
  int? selectedOptionId;
  bool finished = false;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isDisposed = false;
  late String _prefsPrefix;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    evento = EventoModel.fromJson(args['evento']);
    persona = Persona.fromJson(args['persona']);
    cuestionario = CuestionarioModel.fromJson(args['cuestionario']);

    quizDurationMinutes = cuestionario.respuesta?.eveCueTiempo?.inMinutes ?? 15;
    _prefsPrefix =
        "quiz_${evento.eveId}_${persona.ci}_${cuestionario.respuesta?.eveCueId}";

    ever(_ctrl.preguntasResponse, (ApiResponse<OpcionesModel> resp) {
      if (resp.status == Status.COMPLETED) {
        _safeSetState(() {
          questions = resp.data?.respuesta ?? [];
        });
      } else if (resp.status == Status.ERROR) {
        _showSnack('Error', resp.message ?? 'Error al cargar preguntas');
      }
    });

    _ctrl.preguntasResponse.value = ApiResponse.loading();
    _ctrl.eventoPreguntaPost({"eve_cue_id": cuestionario.respuesta?.eveCueId});

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _loadState();
  }

  void _safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) setState(fn);
  }

  void _showSnack(String title, String msg) {
    Get.snackbar(title, msg, snackPosition: SnackPosition.BOTTOM);
  }

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();
  String _k(String key) => '$_prefsPrefix\_$key';

  Future<void> _loadState() async {
    final prefs = await _prefs;
    final startStr = prefs.getString(_k('start_time'));
    currentQuestionIndex = prefs.getInt(_k('index')) ?? 0;
    score = prefs.getInt(_k('score')) ?? 0;
    selectedOptionId = prefs.getInt(_k('selected'));
    answered = prefs.getBool(_k('answered')) ?? false;
    remainingTime = prefs.getInt(_k('remaining')) ?? -1;
    finished = prefs.getBool(_k('finished')) ?? false;

    if (finished) {
      _safeSetState(() {});
      return;
    }

    startTime =
        startStr != null
            ? DateTime.tryParse(startStr) ?? DateTime.now()
            : DateTime.now();
    if (startStr == null)
      await prefs.setString(_k('start_time'), startTime!.toIso8601String());

    if (remainingTime <= 0) _calculateRemainingTime();
    _startTimer();
    _controller.forward();
  }

  Future<void> _saveState() async {
    final prefs = await _prefs;
    await prefs.setInt(_k('index'), currentQuestionIndex);
    await prefs.setInt(_k('score'), score);
    if (startTime != null)
      await prefs.setString(_k('start_time'), startTime!.toIso8601String());
    if (selectedOptionId != null)
      await prefs.setInt(_k('selected'), selectedOptionId!);
    await prefs.setBool(_k('answered'), answered);
    await prefs.setInt(_k('remaining'), remainingTime);
    await prefs.setBool(_k('finished'), finished);
  }

  Future<void> _clearState() async {
    final prefs = await _prefs;
    await prefs.remove(_k('start_time'));
    await prefs.remove(_k('index'));
    await prefs.remove(_k('score'));
    await prefs.remove(_k('selected'));
    await prefs.remove(_k('answered'));
    await prefs.remove(_k('remaining'));
    await prefs.remove(_k('finished'));

    _safeSetState(() {
      currentQuestionIndex = 0;
      score = 0;
      selectedOptionId = null;
      answered = false;
      remainingTime = quizDurationMinutes * 60;
      finished = false;
      startTime = null;
    });
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    final end = (startTime ?? DateTime.now()).add(
      Duration(minutes: quizDurationMinutes),
    );
    remainingTime = end.difference(now).inSeconds;
    if (remainingTime <= 0) {
      remainingTime = 0;
      _showQuizResultAndFinish();
    }
  }

  void _startTimer() {
    timer?.cancel();
    if (remainingTime <= 0) remainingTime = quizDurationMinutes * 60;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingTime > 0) {
        _safeSetState(() => remainingTime--);
        if (remainingTime % 5 == 0) _saveState();
      } else {
        t.cancel();
        _showQuizResultAndFinish();
      }
    });
  }

  void _answer(Opcion opt) {
    if (answered || finished) return;

    final isCorrect = opt.esCorrecta == 1;
    _safeSetState(() {
      answered = true;
      selectedOptionId = opt.id;
      if (isCorrect) score++;
    });
    _saveState();

    Future.delayed(const Duration(milliseconds: 850), () {
      if (!_isDisposed && mounted) {
        if (currentQuestionIndex < questions.length - 1) {
          _safeSetState(() {
            currentQuestionIndex++;
            answered = false;
            selectedOptionId = null;
          });
          _controller.forward(from: 0);
          _saveState();
        } else {
          _showQuizResultAndFinish();
        }
      }
    });
  }

void _showQuizResultAndFinish() {
  if (finished) return;
  timer?.cancel();

  finished = true;
  _saveState();

  final usedMinutes = quizDurationMinutes - (remainingTime ~/ 60);
  final total = questions.length;
  final incorrect = total - score;
  final percent = total == 0 ? 0 : ((score / total) * 100).round();

  Get.defaultDialog(
    title: 'Resultados del Cuestionario',
    titleStyle: TextStyle(
      fontFamily: AppFonts.montserrat,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColor.primaryColor,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    content: Column(
      children: [
        // Círculo creativo con iniciales del participante
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColor.primaryColor, AppColor.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Center(
            child: Text(
              '${persona.nombre1?[0] ?? ''}${persona.apellido1?[0] ?? ''}',
              style: TextStyle(
                fontFamily: AppFonts.montserrat,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Nombre completo del participante
        Text(
          '${persona.nombre1} ${persona.apellido1}',
          style: TextStyle(
            fontFamily: AppFonts.montserrat,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.secondaryColor,
          ),
        ),
        const SizedBox(height: 12),

        // Código de barras con CI
        BarcodeWidget(
          barcode: Barcode.code128(),
          data: "${persona.ci}",
          width: 220,
          height: 60,
        ),
        const SizedBox(height: 20),

        // Estadísticas en tarjetas
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statCard(Icons.check, Colors.green, '$score', 'Correctas'),
            _statCard(Icons.close, Colors.red, '$incorrect', 'Incorrectas'),
            _statCard(Icons.timer, Colors.orange, '$usedMinutes', 'Min'),
          ],
        ),
        const SizedBox(height: 20),

        // Nota
        Text(
          'Nota: $percent%',
          style: TextStyle(
            fontFamily: AppFonts.montserrat,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.secondaryColor,
          ),
        ),
        const SizedBox(height: 8),

        // Mensaje motivacional
        Text(
          percent == 100
              ? 'Excelente desempeño'
              : percent >= 70
                  ? 'Muy bien hecho'
                  : 'Sigue practicando',
          style: TextStyle(
            fontFamily: AppFonts.montserrat,
            fontSize: 16,
            color: AppColor.primaryTextColor,
          ),
        ),
      ],
    ),
    confirm: Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryButtonColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Get.back(),
            child: const Text(
              'Aceptar',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColor.primaryColor, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await _clearState();
              _safeSetState(() {
                finished = false;
                currentQuestionIndex = 0;
                score = 0;
                answered = false;
                selectedOptionId = null;
                startTime = DateTime.now();
                remainingTime = quizDurationMinutes * 60;
              });
              await _saveState();
              _startTimer();
              Get.back();
            },
            child: const Text(
              'Reintentar',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget auxiliar para estadística
Widget _statCard(IconData icon, Color color, String value, String label) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.montserrat,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}


  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey4Color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              if (questions.isEmpty)
                Expanded(
                  child: Center(
                    child:
                        _ctrl.preguntasResponse.value.status == Status.LOADING
                            ? const CircularProgressIndicator()
                            : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('No se encontraron preguntas'),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    _ctrl.preguntasResponse.value =
                                        ApiResponse.loading();
                                    _ctrl.eventoPreguntaPost({
                                      "eve_cue_id":
                                          cuestionario.respuesta?.eveCueId,
                                    });
                                  },
                                  child: const Text('Reintentar'),
                                ),
                              ],
                            ),
                  ),
                )
              else if (finished)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Has terminado este cuestionario.'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () async {
                            await _clearState();
                            _safeSetState(() {
                              finished = false;
                              currentQuestionIndex = 0;
                              score = 0;
                              answered = false;
                              selectedOptionId = null;
                              startTime = DateTime.now();
                              remainingTime = quizDurationMinutes * 60;
                            });
                            _startTimer();
                          },
                          child: const Text('Volver a intentar'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimerAndProgress(),
                          Text(
                            '${currentQuestionIndex + 1}/${questions.length}',
                            style: TextStyle(
                              fontFamily: AppFonts.montserrat,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: (currentQuestionIndex + 1) / questions.length,
                        backgroundColor: AppColor.grey2Color,
                        color: AppColor.primaryColor,
                        minHeight: 8,
                      ),
                      const SizedBox(height: 18),
                      SlideTransition(
                        position: _slideAnimation,
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pregunta ${currentQuestionIndex + 1}',
                                  style: TextStyle(
                                    fontFamily: AppFonts.montserrat,
                                    color: AppColor.secondaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  questions[currentQuestionIndex].texto ?? '',
                                  style: TextStyle(
                                    fontFamily: AppFonts.montserrat,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, idx) {
                            final opt =
                                questions[currentQuestionIndex].opciones![idx];
                            final isCorrect = opt.esCorrecta == 1;
                            final isSelected = opt.id == selectedOptionId;

                            Color bgColor = AppColor.whiteColor;
                            Color textColor = AppColor.primaryTextColor;

                            if (answered) {
                              if (isSelected) {
                                bgColor = isCorrect ? const Color.fromARGB(255, 10, 151, 14) : const Color.fromARGB(255, 206, 33, 21);
                                textColor = AppColor.whiteColor;
                              } else if (isCorrect) {
                                bgColor = Colors.green.shade200;
                                textColor = AppColor.whiteColor;
                              }
                            }

                            return GestureDetector(
                              onTap: () => _answer(opt),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        opt.texto ?? '',
                                        style: TextStyle(
                                          fontFamily: AppFonts.montserrat,
                                          fontSize: 16,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                    if (answered && isSelected)
                                      Icon(
                                        isCorrect
                                            ? Icons.check_circle
                                            : Icons.cancel,
                                        color: AppColor.whiteColor,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemCount:
                              questions[currentQuestionIndex]
                                  .opciones
                                  ?.length ??
                              0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Terminar',
                                  middleText:
                                      '¿Deseas terminar el cuestionario ahora?',
                                  textConfirm: 'Sí',
                                  textCancel: 'No',
                                  onConfirm: () {
                                    Get.back();
                                    _showQuizResultAndFinish();
                                  },
                                );
                              },
                              child: const Text('Terminar ahora'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.eveNombre ?? 'Evento',
                  style: TextStyle(
                    fontFamily: AppFonts.montserrat,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.whiteColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  evento.eveLugar ?? '',
                  style: TextStyle(
                    fontFamily: AppFonts.montserrat,
                    color: AppColor.whiteColor.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColor.secondaryColor,
              child: Text(
                persona.nombre1?.substring(0, 1) ?? '',
                style: TextStyle(
                  color: AppColor.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${persona.nombre1} ${persona.apellido1}',
              style: TextStyle(fontFamily: AppFonts.montserrat, fontSize: 12),
            ),
            Text(
              'CI: ${persona.ci}',
              style: TextStyle(
                fontSize: 11,
                color: AppColor.secondaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerAndProgress() {
  final percent = quizDurationMinutes == 0
      ? 0.0
      : (remainingTime / (quizDurationMinutes * 60));

  Color getTimeColor() {
    if (percent < 0.25) return Colors.redAccent;
    if (percent < 0.5) return Colors.orangeAccent;
    return AppColor.primaryColor;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: AppColor.whiteColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        )
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Tiempo restante
        Row(
          children: [
            Icon(Icons.timer, color: getTimeColor(), size: 28),
            const SizedBox(width: 8),
            Text(
              _formatTime(remainingTime),
              style: TextStyle(
                fontFamily: AppFonts.montserrat,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: getTimeColor(),
              ),
            ),
          ],
        ),
       
      ],
    ),
  );
}

  @override
  void dispose() {
    _isDisposed = true;
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
