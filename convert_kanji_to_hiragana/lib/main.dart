import 'package:flutter/material.dart';
import 'package:convert_kanji_to_hiragana/app_state.dart';
import 'package:convert_kanji_to_hiragana/app_notifier_provider.dart';
import 'package:convert_kanji_to_hiragana/convert_result.dart';
import 'package:convert_kanji_to_hiragana/input_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convert_kanji_to_hiragana/loading_indicator.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hiragana Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Hiragana Converter'),
      ),
      body: switch (appState) {
        Loading() => const LoadingIndicator(),
        Input() => const InputForm(),
        Data(sentence: final sentence) => ConvertResult(sentence: sentence),
      },
    );
  }
}