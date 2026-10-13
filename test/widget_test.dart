import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wordloom/main.dart';

void main() {
  testWidgets('shows the workshop name', (tester) async {
    await tester.pumpWidget(const WordloomApp());

    expect(find.text('Wordloom'), findsWidgets);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
