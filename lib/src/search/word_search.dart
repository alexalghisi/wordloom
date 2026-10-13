enum SearchMode { pattern, letters }

class SearchOutcome {
  const SearchOutcome({
    required this.results,
    this.problem,
    this.truncated = false,
  });

  final List<String> results;
  final String? problem;
  final bool truncated;
}

class WordSearch {
  WordSearch(List<String> words) : _words = List<String>.unmodifiable(words);

  static const int maxMatches = 60;

  final List<String> _words;

  SearchOutcome run(SearchMode mode, String raw) {
    return switch (mode) {
      SearchMode.pattern => byPattern(raw),
      SearchMode.letters => byLetters(raw),
    };
  }

  SearchOutcome byPattern(String raw) {
    final query = _sanitize(raw, wildcards: true);
    if (query == null) {
      return const SearchOutcome(
        results: [],
        problem: 'Use letters and ? only.',
      );
    }
    if (query.isEmpty) {
      return const SearchOutcome(results: [], problem: 'Enter a pattern.');
    }
    final matches = <String>[
      for (final word in _words)
        if (_patternFits(word, query)) word,
    ]..sort();
    return _pack(matches);
  }

  SearchOutcome byLetters(String raw) {
    final query = _sanitize(raw, wildcards: false);
    if (query == null) {
      return const SearchOutcome(results: [], problem: 'Use letters only.');
    }
    if (query.isEmpty) {
      return const SearchOutcome(results: [], problem: 'Enter some letters.');
    }
    final budget = _tally(query);
    final matches =
        <String>[
          for (final word in _words)
            if (word.length >= 3 && _within(word, budget)) word,
        ]..sort((String a, String b) {
          final byLength = b.length.compareTo(a.length);
          if (byLength != 0) {
            return byLength;
          }
          return a.compareTo(b);
        });
    return _pack(matches);
  }

  SearchOutcome _pack(List<String> matches) {
    final truncated = matches.length > maxMatches;
    return SearchOutcome(
      results: truncated ? matches.sublist(0, maxMatches) : matches,
      truncated: truncated,
    );
  }

  String? _sanitize(String raw, {required bool wildcards}) {
    final folded = raw.trim().toLowerCase();
    final allowed = wildcards ? RegExp(r'^[a-z?\s]+$') : RegExp(r'^[a-z\s]+$');
    if (folded.isNotEmpty && !allowed.hasMatch(folded)) {
      return null;
    }
    return folded.replaceAll(RegExp(r'\s+'), '');
  }

  bool _patternFits(String word, String pattern) {
    if (word.length != pattern.length) {
      return false;
    }
    for (var i = 0; i < pattern.length; i++) {
      final mark = pattern[i];
      if (mark == '?') {
        continue;
      }
      if (mark != word[i]) {
        return false;
      }
    }
    return true;
  }

  List<int> _tally(String letters) {
    final counts = List<int>.filled(26, 0);
    for (final code in letters.codeUnits) {
      counts[code - 97] += 1;
    }
    return counts;
  }

  bool _within(String word, List<int> budget) {
    final used = List<int>.filled(26, 0);
    for (final code in word.codeUnits) {
      if (code < 97 || code > 122) {
        return false;
      }
      final index = code - 97;
      used[index] += 1;
      if (used[index] > budget[index]) {
        return false;
      }
    }
    return true;
  }
}
