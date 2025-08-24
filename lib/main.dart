import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'question_list_screen.dart';
import 'question_detail_screen.dart';
void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driving License Exam Practice',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QuizPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  void previousQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
        selectedIndex = -1;
        feedback = null;
      });
    }
  }
  bool showListScreen = true;
  List<Map<String, dynamic>> questions = [];
  int currentQuestion = 0;
  int selectedIndex = -1;
  String? feedback;
  bool isLoading = true;

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedIndex = -1;
        feedback = null;
      });
    }
  }

  @override
  void initState() {
  super.initState();
  loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String data = await rootBundle.loadString('questions.json');
    final List<dynamic> jsonResult = json.decode(data);
    setState(() {
      questions = jsonResult.map((e) => Map<String, dynamic>.from(e)).toList();
      isLoading = false;
      showListScreen = true;
    });
  }

  void selectOption(int index) {
    final correctIndex = questions[currentQuestion]['answer'] is int
        ? questions[currentQuestion]['answer']
        : int.tryParse(questions[currentQuestion]['answer'].toString()) ?? -1;
    setState(() {
      selectedIndex = index;
      feedback = index == correctIndex ? 'Correct!' : 'Incorrect!';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No questions found.')),
      );
    }
    if (showListScreen) {
      return QuestionListScreen(
        questions: questions,
        onQuestionTap: (index) {
          setState(() {
            currentQuestion = index;
            selectedIndex = -1;
            feedback = null;
            showListScreen = false;
          });
        },
      );
    }
    final current = questions[currentQuestion];
    return QuestionDetailScreen(
      question: current,
      selectedIndex: selectedIndex,
      feedback: feedback,
      onSelectOption: selectOption,
      onNext: currentQuestion < questions.length - 1 ? nextQuestion : null,
      onPrevious: currentQuestion > 0 ? previousQuestion : null,
      isLast: currentQuestion == questions.length - 1,
      onBack: () {
        setState(() {
          showListScreen = true;
          selectedIndex = -1;
          feedback = null;
        });
      },
    );
  }
}
