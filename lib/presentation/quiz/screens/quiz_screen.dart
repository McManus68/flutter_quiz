import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quizz/presentation/common/widgets/custom_button.dart';
import 'package:flutter_quizz/presentation/quiz/viewmodel/quiz_state.dart';
import 'package:flutter_quizz/presentation/quiz/viewmodel/quiz_view_model.dart';
import 'package:flutter_quizz/presentation/quiz/widgets/quiz_question.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/question.dart';
import '../../common/widgets/error.dart';
import '../widgets/quiz_results.dart';

class QuizScreen extends HookConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final viewModelState = ref.watch(quizViewModelProvider);
    final questionsFuture = ref.watch(questionsProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF22293E),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: questionsFuture.when(
            data: (questions) =>
                _buildBody(context, ref, viewModelState, pageController, questions),
            error: (error, _) =>
                Error(message: error.toString(), callback: () => refreshAll(context, ref)),
            loading: () => const Center(child: CircularProgressIndicator())),
        bottomSheet: questionsFuture.maybeWhen(
            data: (questions) {
              if (!viewModelState.answered) return const SizedBox.shrink();
              var currentIndex = pageController.page?.toInt() ?? 0;
              return CustomButton(
                  title: (currentIndex + 1) < questions.length ? 'Next Question' : 'See results',
                  onTap: () {
                    ref.read(quizViewModelProvider.notifier).nextQuestion(questions, currentIndex);
                    if (currentIndex + 1 < questions.length) {
                      pageController.nextPage(
                          duration: const Duration(microseconds: 250), curve: Curves.linear);
                    }
                  });
            },
            orElse: () => const SizedBox.shrink()),
      ),
    );
  }

  void refreshAll(BuildContext context, WidgetRef ref) {
    ref.refresh(questionsProvider);
    ref.read(quizViewModelProvider.notifier).reset();
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, QuizState state,
      PageController pageController, List<Question> questions) {
    if (questions.isEmpty) {
      return Error(message: 'No questions found', callback: () => refreshAll(context, ref));
    }
    return state.status == QuizStatus.complete
        ? QuizResults(state: state, nbQuestions: questions.length)
        : QuizQuestion(pageController: pageController, state: state, questions: questions);
  }
}
