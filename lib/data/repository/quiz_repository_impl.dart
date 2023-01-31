import 'package:flutter_quizz/data/api/remote_api.dart';
import 'package:flutter_quizz/data/models/request/question_request.dart';
import 'package:flutter_quizz/domain/entities/question.dart';
import 'package:flutter_quizz/domain/repository/quiz_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final quizRepositoryProvider =
    Provider<QuizRepository>((ref) => QuizRepositoryImpl(ref.read(remoteApiProvider)));

class QuizRepositoryImpl extends QuizRepository {
  final RemoteApi _remoteApi;

  QuizRepositoryImpl(this._remoteApi);

  @override
  Future<List<Question>> getQuestions({required int numQuestions, required int categoryId}) {
    return _remoteApi
        .getQuestions(QuestionRequest(type: 'multiple', amount: numQuestions, category: categoryId))
        .then((value) => value.map((e) => e.toEntity()).toList());
  }
}
