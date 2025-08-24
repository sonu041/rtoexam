import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedIndex = null;
        feedback = null;
      });
    }
  }
  List<Map<String, dynamic>> questions = [];
  int currentQuestion = 0;
  int? selectedIndex;
  String? feedback;
  bool isLoading = true;

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
    final current = questions[currentQuestion];
    final List<String> options = List<String>.from(current['options']);
    return Scaffold(
      appBar: AppBar(title: const Text('Driving License Exam Practice')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (current.containsKey('image') && current['image'] != null && current['image'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: Image.asset(
                    current['image'],
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text('Image not found'),
                  ),
                ),
              ),
            Row(
              children: [
                if (current.containsKey('id'))
                  Text(
                    'Q${current['id']}: ',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                Expanded(
                  child: Text(
                    current['question'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...List.generate(options.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ElevatedButton(
                  onPressed: selectedIndex == null ? () => selectOption(index) : null,
                  child: Text(options[index]),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedIndex == index
                        ? (index == (current['answer'] is int
                            ? current['answer']
                            : int.tryParse(current['answer'].toString()) ?? -1)
                          ? Colors.green
                          : Colors.red)
                        : null,
                  ),
                ),
              );
            }),
            if (feedback != null) ...[
              const SizedBox(height: 24),
              Text(
                feedback!,
                style: TextStyle(
                  fontSize: 18,
                  color: feedback == 'Correct!' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (currentQuestion < questions.length - 1)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: nextQuestion,
                    child: const Text('Next'),
                  ),
                ),
              if (currentQuestion == questions.length - 1)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: const Text('Quiz Complete!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
