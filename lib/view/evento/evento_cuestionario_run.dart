import 'dart:async';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  final int quizDurationMinutes = 15;
  DateTime? startTime;
  int remainingTime = 0;
  Timer? timer;

  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false;
  String selectedAnswer = '';

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  List<Map<String, dynamic>> questions = [
    {'question': '¿Cuál es la capital de Francia?', 'options': ['Madrid', 'París', 'Berlín', 'Lisboa'], 'answer': 'París'},
    {'question': '¿Cuál es 5 + 7?', 'options': ['10', '12', '11', '13'], 'answer': '12'},
    {'question': '¿Cuál es el color del cielo?', 'options': ['Azul', 'Verde', 'Rojo', 'Amarillo'], 'answer': 'Azul'},
    {'question': '¿Cuál es el océano más grande?', 'options': ['Atlántico', 'Índico', 'Pacífico', 'Ártico'], 'answer': 'Pacífico'},
    {'question': '¿Quién escribió "Cien años de soledad"?', 'options': ['Pablo Neruda','Gabriel García Márquez','Mario Vargas Llosa','Jorge Luis Borges'], 'answer': 'Gabriel García Márquez'},
    {'question': '¿Cuál es la raíz cuadrada de 64?', 'options': ['6','8','7','9'], 'answer': '8'},
    {'question': '¿Cuál es el planeta más cercano al sol?', 'options': ['Venus','Mercurio','Marte','Júpiter'], 'answer': 'Mercurio'},
    {'question': '¿Qué gas respiramos?', 'options': ['Oxígeno','Hidrógeno','Nitrógeno','Helio'], 'answer': 'Oxígeno'},
    {'question': '¿Cuál es el continente más grande?', 'options': ['Asia','África','Europa','América'], 'answer': 'Asia'},
    {'question': '¿Cuál es el símbolo químico del agua?', 'options': ['H2O','O2','CO2','HO'], 'answer': 'H2O'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    String? startTimeString = prefs.getString('quiz_start_time');
    currentQuestionIndex = prefs.getInt('quiz_index') ?? 0;
    score = prefs.getInt('quiz_score') ?? 0;

    if (startTimeString != null) {
      startTime = DateTime.parse(startTimeString);
    } else {
      startTime = DateTime.now();
      prefs.setString('quiz_start_time', startTime!.toIso8601String());
    }

    _calculateRemainingTime();
    _startTimer();
    _controller.forward();
  }

  void _calculateRemainingTime() {
    final now = DateTime.now();
    final endTime = startTime!.add(Duration(minutes: quizDurationMinutes));
    remainingTime = endTime.difference(now).inSeconds;

    if (remainingTime <= 0) {
      remainingTime = 0;
      _showQuizResultDynamic();
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        t.cancel();
        _showQuizResultDynamic();
      }
    });
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('quiz_index', currentQuestionIndex);
    prefs.setInt('quiz_score', score);
    if (startTime != null) prefs.setString('quiz_start_time', startTime!.toIso8601String());
  }

  Future<void> _clearState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_start_time');
    await prefs.remove('quiz_index');
    await prefs.remove('quiz_score');
  }

  void _answer(String option) {
    if (answered) return;
    setState(() {
      answered = true;
      selectedAnswer = option;
      if (option == questions[currentQuestionIndex]['answer']) score++;
    });
    _saveState();

    Future.delayed(const Duration(seconds: 1), () {
      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          answered = false;
          selectedAnswer = '';
        });
        _controller.forward(from: 0);
      } else {
        _showQuizResultDynamic();
      }
    });
  }

  void _showQuizResultDynamic() {
    timer?.cancel();
    final int timeUsed = quizDurationMinutes - (remainingTime ~/ 60);
    showQuizResult(
      participantName: 'Juan Pablo Valencia',
      participantCI: '14122404',
      score: score,
      totalQuestions: questions.length,
      timeUsed: timeUsed,
    );
    _clearState();
  }

  void showQuizResult({
    required String participantName,
    required String participantCI,
    required int score,
    required int totalQuestions,
    required int timeUsed,
  }) {
    final int incorrect = totalQuestions - score;
    final String percentage = ((score / totalQuestions) * 100).toStringAsFixed(0);

    Get.defaultDialog(
      title: '🎉 ¡Resultados de $participantName!',
      titleStyle: TextStyle(
        fontFamily: AppFonts.montserrat, fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.primaryColor,
      ),
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BarcodeWidget(data: participantCI, barcode: Barcode.code128(), width: 200, height: 60, drawText: true),
          const SizedBox(height: 16),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [AppColor.primaryColor, AppColor.secondaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: Center(
              child: Text('$score/$totalQuestions', style: TextStyle(fontFamily: AppFonts.montserrat, fontSize: 28, fontWeight: FontWeight.bold, color: AppColor.whiteColor)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(children: [Icon(Icons.check_circle, color: Colors.green, size: 32), const SizedBox(height: 4), Text('$score Correctas', style: TextStyle(fontFamily: AppFonts.montserrat, fontWeight: FontWeight.bold, color: Colors.green))]),
              Column(children: [Icon(Icons.cancel, color: Colors.red, size: 32), const SizedBox(height: 4), Text('$incorrect Incorrectas', style: TextStyle(fontFamily: AppFonts.montserrat, fontWeight: FontWeight.bold, color: Colors.red))]),
              Column(children: [Icon(Icons.timer, color: Colors.orange, size: 32), const SizedBox(height: 4), Text('$timeUsed min', style: TextStyle(fontFamily: AppFonts.montserrat, fontWeight: FontWeight.bold, color: Colors.orange))]),
            ],
          ),
          const SizedBox(height: 16),
          Text('Nota: $percentage%', style: TextStyle(fontFamily: AppFonts.montserrat, fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.secondaryColor)),
          const SizedBox(height: 16),
          Text(
            score == totalQuestions ? '¡Excelente trabajo! 🏆' : score >= totalQuestions * 0.7 ? '¡Muy bien! 👍 Sigue así' : 'No te rindas 💪 ¡Practica más!',
            style: TextStyle(fontFamily: AppFonts.montserrat, fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.primaryColor),
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColor.primaryButtonColor, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        onPressed: () => Get.back(),
        child: const Text('Aceptar', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  String _formatTime(int seconds) {
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty || remainingTime <= 0) return const Scaffold(body: Center(child: Text("No hay preguntas o tiempo agotado")));

    final question = questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      backgroundColor: AppColor.grey4Color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Temporizador y progreso
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tiempo: ${_formatTime(remainingTime)}', style: TextStyle(fontFamily: AppFonts.montserrat, fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.primaryColor)),
                  Text('${currentQuestionIndex + 1}/${questions.length}', style: TextStyle(fontFamily: AppFonts.montserrat, fontSize: 16, fontWeight: FontWeight.w500, color: AppColor.secondaryColor)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress, backgroundColor: AppColor.grey2Color, color: AppColor.primaryColor, minHeight: 8),
              const SizedBox(height: 20),
              // Pregunta con animación
              SlideTransition(
                position: _slideAnimation,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  color: AppColor.whiteColor,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(question['question'], style: TextStyle(fontFamily: AppFonts.montserrat, fontSize: 24, fontWeight: FontWeight.bold, color: AppColor.primaryTextColor)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Opciones tipo flashcard
              Expanded(
                child: ListView.builder(
                  itemCount: question['options'].length,
                  itemBuilder: (context, index) {
                    final option = question['options'][index];
                    return GestureDetector(
                      onTap: () => _answer(option),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                        decoration: BoxDecoration(
                          gradient: answered
                              ? LinearGradient(
                                  colors: option == question['answer']
                                      ? [Colors.greenAccent, Colors.green]
                                      : option == selectedAnswer
                                          ? [Colors.redAccent, Colors.red]
                                          : [Colors.grey.shade300, Colors.grey.shade200],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight)
                              : LinearGradient(
                                  colors: [Colors.white, Colors.grey.shade100],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6, offset: const Offset(0, 3))],
                        ),
                        child: Text(
                          option,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.montserrat,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: answered && (option == question['answer'] || option == selectedAnswer) ? AppColor.whiteColor : AppColor.primaryTextColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
