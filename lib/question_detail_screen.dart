import 'package:flutter/material.dart';

class QuestionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> question;
  final int selectedIndex;
  final String? feedback;
  final Function(int) onSelectOption;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final bool isLast;
  final VoidCallback? onBack;

  const QuestionDetailScreen({
    Key? key,
    required this.question,
    required this.selectedIndex,
    required this.feedback,
    required this.onSelectOption,
  this.onNext,
  this.onPrevious,
  this.isLast = false,
  this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> options = List<String>.from(question['options']);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving License Exam Practice'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack ?? () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.containsKey('image') && question['image'] != null && question['image'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: Image.asset(
                    question['image'],
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Text('Image not found'),
                  ),
                ),
              ),
            Row(
              children: [
                if (question.containsKey('id'))
                  Text(
                    'Q${question['id']}: ',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                Expanded(
                  child: Text(
                    question['question'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...List.generate(options.length, (index) {
              final correctIndex = question['answer'] is int
                  ? question['answer']
                  : int.tryParse(question['answer'].toString()) ?? -1;
              Color? borderColor;
              if (selectedIndex != -1) {
                if (index == correctIndex) {
                  borderColor = Colors.green;
                } else if (index == selectedIndex) {
                  borderColor = Colors.red;
                }
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: borderColor ?? Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: selectedIndex == -1 ? () => onSelectOption(index) : null,
                      child: Text(
                        options[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == index
                            ? (index == correctIndex
                                ? Colors.green
                                : Colors.red)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        foregroundColor: Colors.black,
                        disabledForegroundColor: Colors.black,
                        disabledBackgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                ),
              );
            }),
            if (feedback != null) ...[
              const SizedBox(height: 24),
              Center(
                child: Text(
                  feedback!,
                  style: TextStyle(
                    fontSize: 18,
                    color: feedback == 'Correct!' ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (onPrevious != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: onPrevious,
                        child: const Text('Previous'),
                      ),
                    ),
                  if (!isLast && onNext != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                        onPressed: onNext,
                        child: const Text('Next'),
                      ),
                    ),
                ],
              ),
            ),
            if (isLast)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: const Text('Quiz Complete!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
