import 'package:flutter_test/flutter_test.dart';
import 'package:wordloom/src/search/word_search.dart';

void main() {
  const lexicon = [
    'acre',
    'act',
    'cat',
    'cot',
    'cut',
    'enlist',
    'inlets',
    'list',
    'listen',
    'silent',
    'steel',
    'tinsel',
  ];

  final search = WordSearch(lexicon);

  test('pattern treats ? as one unknown letter', () {
    final outcome = search.byPattern('C ? T');

    expect(outcome.problem, isNull);
    expect(outcome.results, ['cat', 'cot', 'cut']);
  });

  test('pattern rejects digits', () {
    final outcome = search.byPattern('c1t');

    expect(outcome.results, isEmpty);
    expect(outcome.problem, 'Use letters and ? only.');
  });

  test('blank pattern does not dump the lexicon', () {
    final outcome = search.byPattern('   ');

    expect(outcome.results, isEmpty);
    expect(outcome.problem, 'Enter a pattern.');
  });

  test('letters find words that fit the budget, longest first', () {
    final outcome = search.byLetters('listen');

    expect(outcome.problem, isNull);
    expect(outcome.results.take(5), [
      'enlist',
      'inlets',
      'listen',
      'silent',
      'tinsel',
    ]);
    expect(outcome.results, contains('list'));
    expect(outcome.results, isNot(contains('steel')));
    expect(outcome.results, isNot(contains('act')));
  });

  test('letter search ignores spaces and rejects marks', () {
    expect(search.byLetters('  list  ').results, contains('list'));
    expect(search.byLetters('li5t').problem, 'Use letters only.');
    expect(search.byLetters('').problem, 'Enter some letters.');
  });

  test('caps a huge pattern hit list', () {
    final words = [
      for (var i = 0; i < 70; i++)
        'a${String.fromCharCode(97 + (i % 26))}${String.fromCharCode(97 + (i ~/ 26))}',
    ];
    final outcome = WordSearch(words).byPattern('???');

    expect(outcome.results, hasLength(WordSearch.maxMatches));
    expect(outcome.truncated, isTrue);
    expect(outcome.results, orderedEquals([...outcome.results]..sort()));
  });
}
