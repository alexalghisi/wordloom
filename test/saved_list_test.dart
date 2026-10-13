import 'package:flutter_test/flutter_test.dart';
import 'package:wordloom/src/lists/saved_list.dart';

void main() {
  test('round trips a list and drops damaged entries', () {
    final raw = encodeSavedLists([
      SavedList(id: 'list-1', name: 'Crossword', words: ['cat', 'cot']),
    ]);

    final decoded = decodeSavedLists(raw);

    expect(decoded.single.name, 'Crossword');
    expect(decoded.single.words, ['cat', 'cot']);
    expect(decodeSavedLists('{"nope":true}'), isEmpty);
    expect(decodeSavedLists('not-json'), isEmpty);
    expect(
      decodeSavedLists(
        '[{"id":"list-2","name":"Kept","words":["cat", 4]}, {"id":""}]',
      ).single.words,
      ['cat'],
    );
  });
}
