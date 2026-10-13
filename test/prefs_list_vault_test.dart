import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordloom/src/lists/prefs_list_vault.dart';
import 'package:wordloom/src/lists/saved_list.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('writes lists through shared preferences', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final vault = PrefsListVault(prefs);

    await vault.write([
      SavedList(id: 'list-1', name: 'Crossword', words: ['cat']),
    ]);

    final stored = prefs.getString(PrefsListVault.storageKey);
    expect(stored, isNotNull);
    final loaded = await PrefsListVault(prefs).read();
    expect(loaded.single.name, 'Crossword');
    expect(loaded.single.words, ['cat']);
  });

  test('reads an empty vault when nothing has been stored', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      PrefsListVault.storageKey: '{',
    });
    final prefs = await SharedPreferences.getInstance();

    expect(await PrefsListVault(prefs).read(), isEmpty);
  });
}
