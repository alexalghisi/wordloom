import 'package:flutter_test/flutter_test.dart';
import 'package:wordloom/src/lists/list_library.dart';
import 'package:wordloom/src/lists/memory_list_vault.dart';
import 'package:wordloom/src/lists/saved_list.dart';

void main() {
  test('creates, renames, fills, and deletes a list', () async {
    final library = ListLibrary(vault: MemoryListVault());
    await library.load();

    expect(await library.create('  '), 'Enter a name.');
    expect(await library.create('Crossword'), isNull);
    expect(library.active?.id, 'list-1');
    expect(await library.create('crossword'), 'That list already exists.');

    expect(await library.addWord('Cat'), isNull);
    expect(await library.addWord('cat'), isNull);
    expect(library.active?.words, ['cat']);
    expect(await library.addWord('c4t'), 'Not a word.');

    expect(await library.rename('list-1', 'Spelling'), isNull);
    expect(library.lists.single.name, 'Spelling');

    await library.removeWord('list-1', 'cat');
    expect(library.lists.single.words, isEmpty);

    await library.delete('list-1');
    expect(library.lists, isEmpty);
    expect(library.activeId, isNull);
    expect(await library.addWord('cat'), 'Create a list first.');
  });

  test('keeps lists when a new library reads the same vault', () async {
    final vault = MemoryListVault();
    final first = ListLibrary(vault: vault);
    await first.load();
    await first.create('Crossword');
    await first.addWord('cot');

    final second = ListLibrary(vault: vault);
    await second.load();

    expect(second.lists.single.words, ['cot']);
    expect(second.activeId, 'list-1');
  });

  test('mints the next id from whatever is already stored', () async {
    final library = ListLibrary(
      vault: MemoryListVault([
        SavedList(id: 'list-4', name: 'Old', words: const []),
      ]),
    );
    await library.load();
    await library.create('New');

    expect(library.lists.map((list) => list.id), ['list-4', 'list-5']);
  });
}
