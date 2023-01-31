import 'dart:math';

import 'package:flutter_quizz/data/repository/quiz_repository_impl.dart';
import 'package:flutter_quizz/domain/entities/question.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repository/quiz_repository.dart';

final quizUseCaseProvider =
    Provider<QuizUseCase>((ref) => QuizUseCase(ref.read(quizRepositoryProvider)));

class QuizUseCase {
  QuizUseCase(this._repository);

  final QuizRepository _repository;

  Future<List<Question>> getQuestions() {
    return _repository.getQuestions(numQuestions: 5, categoryId: Random().nextInt(24) + 9);
  }
}
