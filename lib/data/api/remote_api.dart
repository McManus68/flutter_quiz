import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quizz/data/models/request/question_request.dart';
import 'package:flutter_quizz/data/models/response/question_response.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/errors/failure.dart';

final remoteApiProvider = Provider<RemoteApi>((ref) => RemoteApi());

class RemoteApi {
  static const String url = 'https://opentdb.com/api.php';

  Future<List<QuestionResponse>> getQuestions(QuestionRequest request) async {
    try {
      final response = await Dio().get(url, queryParameters: request.toMap());

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final results = List<Map<String, dynamic>>.from(data['results']);
        if (results.isNotEmpty) {
          return results.map((e) => QuestionResponse.fromMap(e)).toList();
        }
      }
      return [];
    } on DioError catch (err) {
      if (kDebugMode) {
        print(err);
      }
      throw Failure(message: err.response?.statusMessage ?? 'Something went wrong');
    } on SocketException catch (err) {
      if (kDebugMode) {
        print(err);
      }
      throw const Failure(message: 'Please check your connection');
    }
  }
}
