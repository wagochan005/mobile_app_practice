// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:convert_kanji_to_hiragana/data.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:convert_kanji_to_hiragana/app_notifier_provider.dart';

class InputForm extends ConsumerStatefulWidget {
  const InputForm({super.key});

  @override
  ConsumerState<InputForm> createState() => _InputFormState();
}

class _InputFormState extends ConsumerState<InputForm> {

  final _formKey = GlobalKey<FormState>();

  /* ◆　TextEditingController
  TextField Widgetの入力文字列や選択文字を取得、変更する機能を持つ */
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /* ◆ Form
    TextFormFieldやFormFieldをグループ化して管理するWidget */
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* ◆ Padding
          余白を与えて子要素を配置するWidget */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            /* ◆ TextFormField
            テキスト入力フォームを実現するWidget */
            child: TextFormField(
              controller: _textEditingController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '文章を入力してください',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '文章が入力されていません';
                }
                return null;
              },
            ),
          ),
          /* ◆　SizeBox
          サイズを指定できるWidget */
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final formState = _formKey.currentState!;
              if(!formState.validate()){
              return;
              }
              final sentence = _textEditingController.text;
              await ref
                  .read(appNotifierProvider.notifier)
                  .convert(sentence);
            },
            child: const Text('変換')
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}