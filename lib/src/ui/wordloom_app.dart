import 'package:flutter/material.dart';
import 'package:wordloom/src/lists/list_library.dart';
import 'package:wordloom/src/search/word_search.dart';
import 'package:wordloom/src/ui/lists_page.dart';
import 'package:wordloom/src/ui/search_page.dart';
import 'package:wordloom/src/ui/wordloom_theme.dart';

class WordloomApp extends StatefulWidget {
  const WordloomApp({
    super.key,
    required this.lexicon,
    required this.library,
    this.initialMode = SearchMode.pattern,
    this.initialQuery = '',
  });

  final List<String> lexicon;
  final ListLibrary library;
  final SearchMode initialMode;
  final String initialQuery;

  @override
  State<WordloomApp> createState() => _WordloomAppState();
}

class _WordloomAppState extends State<WordloomApp> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final search = WordSearch(widget.lexicon);
    return MaterialApp(
      title: 'Wordloom',
      theme: wordloomTheme(),
      home: Scaffold(
        appBar: AppBar(title: const Text('Wordloom')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth > 760
                ? 720.0
                : constraints.maxWidth;
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: width,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    Expanded(
                      child: IndexedStack(
                        index: _index,
                        children: [
                          SearchPage(
                            search: search,
                            library: widget.library,
                            initialMode: widget.initialMode,
                            initialQuery: widget.initialQuery,
                          ),
                          ListsPage(library: widget.library),
                        ],
                      ),
                    ),
                    NavigationBar(
                      selectedIndex: _index,
                      onDestinationSelected: (value) {
                        setState(() => _index = value);
                      },
                      destinations: const [
                        NavigationDestination(
                          icon: Icon(Icons.search),
                          label: 'Search',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.bookmark_border),
                          label: 'Lists',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
