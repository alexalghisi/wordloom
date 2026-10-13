import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'workshop_harness.dart';

void main() {
  testWidgets('saves a match onto a list and then removes it', (tester) async {
    await pumpWorkshop(tester);

    await tester.tap(find.text('Lists'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('list-name')), 'Crossword');
    await tester.tap(find.byKey(const Key('create-list')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('query')), 'c?t');
    await tester.tap(find.byKey(const Key('run-search')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-cat')));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsOneWidget);

    await tester.tap(find.text('Lists'));
    await tester.pumpAndSettle();
    expect(find.text('cat'), findsOneWidget);

    await tester.tap(find.byKey(const Key('remove-list-1-cat')));
    await tester.pumpAndSettle();
    expect(find.text('cat'), findsNothing);
    expect(find.text('Empty'), findsOneWidget);
  });
}
