import 'package:flutter/material.dart';

class QuestionListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final Function(int) onQuestionTap;

  const QuestionListScreen({Key? key, required this.questions, required this.onQuestionTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Questions')),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          String questionText = q.containsKey('id')
              ? 'Q${q['id']}: ${q['question']}'
              : q['question'];
          return ListTile(
            title: Text(questionText, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () => onQuestionTap(index),
          );
        },
      ),
    );
  }
}
