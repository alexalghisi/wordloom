import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordloom/src/lexicon.dart';
import 'package:wordloom/src/lists/list_library.dart';
import 'package:wordloom/src/lists/prefs_list_vault.dart';
import 'package:wordloom/src/ui/wordloom_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final lexicon = await AssetLexicon.load();
  final prefs = await SharedPreferences.getInstance();
  final library = ListLibrary(vault: PrefsListVault(prefs));
  await library.load();
  runApp(WordloomApp(lexicon: lexicon, library: library));
}
