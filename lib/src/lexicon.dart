import 'package:flutter/services.dart';

List<String> parseLexicon(String raw) {
  final words = <String>[];
  final seen = <String>{};
  for (final line in raw.split('\n')) {
    final word = line.trim().toLowerCase();
    if (!RegExp(r'^[a-z]+$').hasMatch(word)) {
      continue;
    }
    if (seen.add(word)) {
      words.add(word);
    }
  }
  return words;
}

class AssetLexicon {
  static Future<List<String>> load() async {
    final raw = await rootBundle.loadString('assets/lexicon.txt');
    return parseLexicon(raw);
  }
}
