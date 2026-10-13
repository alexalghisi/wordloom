import 'package:flutter/material.dart';
import 'package:wordloom/src/lists/list_library.dart';
import 'package:wordloom/src/search/word_search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
    required this.search,
    required this.library,
    this.initialMode = SearchMode.pattern,
    this.initialQuery = '',
  });

  final WordSearch search;
  final ListLibrary library;
  final SearchMode initialMode;
  final String initialQuery;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _query = TextEditingController(
    text: widget.initialQuery,
  );
  late SearchMode _mode = widget.initialMode;
  List<String> _results = const [];
  String _message = '';
  bool _ran = false;
  bool _truncated = false;

  @override
  void initState() {
    super.initState();
    widget.library.addListener(_onLibrary);
    if (widget.initialQuery.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _run();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.library.removeListener(_onLibrary);
    _query.dispose();
    super.dispose();
  }

  void _onLibrary() {
    if (mounted) {
      setState(() {});
    }
  }

  void _run() {
    final outcome = widget.search.run(_mode, _query.text);
    setState(() {
      _ran = true;
      _results = outcome.results;
      _truncated = outcome.truncated;
      _message = outcome.problem ?? '';
    });
  }

  Future<void> _toggle(String word) async {
    final library = widget.library;
    String? error;
    if (library.containsWord(word)) {
      final id = library.activeId;
      if (id != null) {
        await library.removeWord(id, word);
      }
    } else {
      error = await library.addWord(word);
    }
    if (!mounted) {
      return;
    }
    setState(() => _message = error ?? '');
  }

  String get _status {
    if (_message.isNotEmpty) {
      return _message;
    }
    if (!_ran) {
      return 'A pattern uses ? for one unknown letter.';
    }
    if (_results.isEmpty) {
      return 'No matches.';
    }
    if (_truncated) {
      return 'Showing ${WordSearch.maxMatches} matches.';
    }
    final label = _results.length == 1 ? 'match' : 'matches';
    return '${_results.length} $label';
  }

  @override
  Widget build(BuildContext context) {
    final library = widget.library;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<SearchMode>(
            segments: const [
              ButtonSegment(value: SearchMode.pattern, label: Text('Pattern')),
              ButtonSegment(value: SearchMode.letters, label: Text('Letters')),
            ],
            selected: {_mode},
            onSelectionChanged: (selected) {
              setState(() => _mode = selected.first);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            key: const Key('query'),
            controller: _query,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _run(),
            decoration: InputDecoration(
              labelText: _mode == SearchMode.pattern ? 'Pattern' : 'Letters',
              hintText: _mode == SearchMode.pattern ? 'c?t' : 'listen',
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              key: const Key('run-search'),
              onPressed: _run,
              child: const Text('Find'),
            ),
          ),
          if (library.lists.isNotEmpty) ...[
            const SizedBox(height: 12),
            DropdownButton<String>(
              key: const Key('active-list'),
              isExpanded: true,
              value: library.activeId,
              items: [
                for (final list in library.lists)
                  DropdownMenuItem(value: list.id, child: Text(list.name)),
              ],
              onChanged: (id) {
                if (id != null) {
                  library.select(id);
                }
              },
            ),
          ],
          const SizedBox(height: 8),
          Text(_status, key: const Key('search-status')),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: _results.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final word = _results[index];
                final saved = library.containsWord(word);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(word),
                  trailing: TextButton(
                    key: Key('save-$word'),
                    onPressed: () => _toggle(word),
                    child: Text(saved ? 'Saved' : 'Save'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
