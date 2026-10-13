import 'package:flutter_test/flutter_test.dart';
import 'package:wordloom/src/lists/list_library.dart';
import 'package:wordloom/src/lists/memory_list_vault.dart';
import 'package:wordloom/src/ui/wordloom_app.dart';

const List<String> demoLexicon = [
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

Future<ListLibrary> pumpWorkshop(
  WidgetTester tester, {
  ListLibrary? library,
  List<String> lexicon = demoLexicon,
}) async {
  final lists = library ?? ListLibrary(vault: MemoryListVault());
  if (!lists.ready) {
    await lists.load();
  }
  await tester.pumpWidget(WordloomApp(lexicon: lexicon, library: lists));
  await tester.pumpAndSettle();
  return lists;
}
