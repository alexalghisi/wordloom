import 'package:flutter/material.dart';
import 'package:wordloom/src/lists/list_library.dart';
import 'package:wordloom/src/lists/saved_list.dart';
import 'package:wordloom/src/ui/wordloom_theme.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({super.key, required this.library});

  final ListLibrary library;

  @override
  State<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _rename = TextEditingController();
  String _message = '';
  String? _renamingId;

  @override
  void initState() {
    super.initState();
    widget.library.addListener(_onLibrary);
  }

  @override
  void dispose() {
    widget.library.removeListener(_onLibrary);
    _name.dispose();
    _rename.dispose();
    super.dispose();
  }

  void _onLibrary() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _create() async {
    final error = await widget.library.create(_name.text);
    if (!mounted) {
      return;
    }
    setState(() {
      _message = error ?? '';
      if (error == null) {
        _name.clear();
      }
    });
  }

  Future<void> _commitRename(String id) async {
    final error = await widget.library.rename(id, _rename.text);
    if (!mounted) {
      return;
    }
    setState(() {
      _message = error ?? '';
      if (error == null) {
        _renamingId = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final library = widget.library;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        TextField(
          key: const Key('list-name'),
          controller: _name,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _create(),
          decoration: const InputDecoration(labelText: 'New list'),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            key: const Key('create-list'),
            onPressed: _create,
            child: const Text('Create'),
          ),
        ),
        if (_message.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(_message, key: const Key('list-message')),
        ],
        const SizedBox(height: 16),
        if (library.lists.isEmpty)
          const Text('No lists yet.')
        else
          for (final list in library.lists) ...[
            _ListCard(
              list: list,
              active: list.id == library.activeId,
              renaming: _renamingId == list.id,
              renameController: _rename,
              onOpen: () => library.select(list.id),
              onStartRename: () {
                setState(() {
                  _renamingId = list.id;
                  _rename.text = list.name;
                });
              },
              onCommitRename: () => _commitRename(list.id),
              onDelete: () => library.delete(list.id),
              onRemoveWord: (word) => library.removeWord(list.id, word),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _ListCard extends StatelessWidget {
  const _ListCard({
    required this.list,
    required this.active,
    required this.renaming,
    required this.renameController,
    required this.onOpen,
    required this.onStartRename,
    required this.onCommitRename,
    required this.onDelete,
    required this.onRemoveWord,
  });

  final SavedList list;
  final bool active;
  final bool renaming;
  final TextEditingController renameController;
  final VoidCallback onOpen;
  final VoidCallback onStartRename;
  final VoidCallback onCommitRename;
  final VoidCallback onDelete;
  final ValueChanged<String> onRemoveWord;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: wordloomCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: active ? scheme.primary : wordloomRule),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: renaming
                      ? TextField(
                          key: Key('rename-field-${list.id}'),
                          controller: renameController,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => onCommitRename(),
                          decoration: const InputDecoration(labelText: 'Name'),
                        )
                      : GestureDetector(
                          onTap: onOpen,
                          child: Text(
                            list.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                ),
                if (!renaming)
                  IconButton(
                    key: Key('rename-${list.id}'),
                    onPressed: onStartRename,
                    icon: const Icon(Icons.edit_outlined),
                  ),
                IconButton(
                  key: Key('delete-${list.id}'),
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            if (active)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Active', style: TextStyle(color: scheme.primary)),
              ),
            if (list.words.isEmpty)
              const Text('Empty')
            else
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final word in list.words)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(word),
                        IconButton(
                          key: Key('remove-${list.id}-$word'),
                          onPressed: () => onRemoveWord(word),
                          icon: const Icon(Icons.close, size: 18),
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
