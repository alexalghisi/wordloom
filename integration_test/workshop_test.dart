import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wordloom/src/lexicon.dart';
import 'package:wordloom/src/lists/list_library.dart';
import 'package:wordloom/src/lists/memory_list_vault.dart';
import 'package:wordloom/src/ui/wordloom_app.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('pattern search against the bundled lexicon', (tester) async {
    final lexicon = await AssetLexicon.load();
    final library = ListLibrary(vault: MemoryListVault());
    await library.load();
    await tester.pumpWidget(WordloomApp(lexicon: lexicon, library: library));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('query')), 'c?t');
    await tester.tap(find.byKey(const Key('run-search')));
    await tester.pumpAndSettle();

    expect(find.text('cat'), findsOneWidget);
    expect(find.text('cot'), findsOneWidget);
    expect(find.text('cut'), findsOneWidget);
  });
}
