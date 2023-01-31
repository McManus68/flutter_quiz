import 'package:flutter_quizz/domain/entities/question.dart';

abstract class QuizRepository {
  Future<List<Question>> getQuestions({required int numQuestions, required int categoryId});
}
