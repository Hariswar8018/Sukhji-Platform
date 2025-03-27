import 'package:flutter/material.dart';
import 'package:ignou_bscg/model/user_scores.dart';

class QuizReview extends StatelessWidget {
  final UserScore userScore;

  const QuizReview({Key? key, required this.userScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Score: ${userScore.score}/${userScore.fullMarks}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Completed At: ${userScore.completedAt}',
                style: const TextStyle(fontSize: 16)),
            Text('Correct: ${userScore.noCorrect}, Wrong: ${userScore.noWrong}, Skipped: ${userScore.noSkip}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: userScore.questions.length,
                itemBuilder: (context, index) {
                  final question = userScore.questions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${index + 1}. ${question.question}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...List.generate(question.options.length, (optionIndex) {
                            final isCorrect = optionIndex == question.correctOption;
                            return Row(
                              children: [
                                Text('${optionIndex + 1}. ${question.options[optionIndex]}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isCorrect ? Colors.green : Colors.black,
                                    )),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
