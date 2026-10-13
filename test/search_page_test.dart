import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordloom/src/lists/list_library.dart';
import 'package:wordloom/src/lists/memory_list_vault.dart';
import 'package:wordloom/src/search/word_search.dart';
import 'package:wordloom/src/ui/wordloom_app.dart';

import 'workshop_harness.dart';

void main() {
  testWidgets('pattern search lists cat, cot, and cut', (tester) async {
    await pumpWorkshop(tester);
    await tester.enterText(find.byKey(const Key('query')), 'c?t');
    await tester.tap(find.byKey(const Key('run-search')));
    await tester.pumpAndSettle();

    expect(find.text('cat'), findsOneWidget);
    expect(find.text('cot'), findsOneWidget);
    expect(find.text('cut'), findsOneWidget);
    expect(find.text('3 matches'), findsOneWidget);
  });

  testWidgets('letters search rejects a word that needs extra letters', (
    tester,
  ) async {
    await pumpWorkshop(tester);
    await tester.tap(find.text('Letters'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('query')), 'listen');
    await tester.tap(find.byKey(const Key('run-search')));
    await tester.pumpAndSettle();

    expect(find.text('silent'), findsOneWidget);
    expect(find.text('steel'), findsNothing);
    expect(find.text('Create a list first.'), findsNothing);
  });

  testWidgets('opens on a letter query when one is provided', (tester) async {
    final library = ListLibrary(vault: MemoryListVault());
    await library.load();
    await tester.pumpWidget(
      WordloomApp(
        lexicon: demoLexicon,
        library: library,
        initialMode: SearchMode.letters,
        initialQuery: 'listen',
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('silent'), findsOneWidget);
    expect(find.text('steel'), findsNothing);
  });

  testWidgets('save explains that a list is required', (tester) async {
    await pumpWorkshop(tester);
    await tester.enterText(find.byKey(const Key('query')), 'cat');
    await tester.tap(find.byKey(const Key('run-search')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-cat')));
    await tester.pumpAndSettle();

    expect(find.text('Create a list first.'), findsOneWidget);
  });
}
