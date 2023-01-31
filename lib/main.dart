import 'package:flutter/material.dart';
import 'package:flutter_quizz/presentation/quiz/screens/quiz_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent)),
      home: const QuizScreen(),
    );
  }
}
