import 'package:flutter/material.dart';

void main() {
  runApp(const WordloomApp());
}

class WordloomApp extends StatelessWidget {
  const WordloomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wordloom',
      home: Scaffold(
        appBar: AppBar(title: const Text('Wordloom')),
        body: const Center(child: Text('Wordloom')),
      ),
    );
  }
}
