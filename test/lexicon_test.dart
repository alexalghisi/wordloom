import 'package:flutter_test/flutter_test.dart';
import 'package:wordloom/src/lexicon.dart';

void main() {
  test('keeps the first spelling and drops junk lines', () {
    final words = parseLexicon('Cat\n\ncat\n!!\n  cot \n');

    expect(words, ['cat', 'cot']);
  });

  test('asset lexicon is unique and includes the demo families', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final words = await AssetLexicon.load();

    expect(words.toSet(), hasLength(words.length));
    expect(
      words,
      containsAll([
        'cat',
        'cot',
        'cut',
        'listen',
        'silent',
        'enlist',
        'tinsel',
        'inlets',
      ]),
    );
    expect(words.every((word) => RegExp(r'^[a-z]+$').hasMatch(word)), isTrue);
  });
}
