import 'package:flutter/foundation.dart';
import 'package:wordloom/src/lists/list_vault.dart';
import 'package:wordloom/src/lists/saved_list.dart';

class ListLibrary extends ChangeNotifier {
  ListLibrary({required this.vault});

  final ListVault vault;
  List<SavedList> _lists = const [];
  bool ready = false;
  String? activeId;

  List<SavedList> get lists => List<SavedList>.unmodifiable(_lists);

  SavedList? get active {
    for (final list in _lists) {
      if (list.id == activeId) {
        return list;
      }
    }
    return null;
  }

  Future<void> load() async {
    _lists = await vault.read();
    activeId = _lists.isEmpty ? null : _lists.first.id;
    ready = true;
    notifyListeners();
  }

  Future<String?> create(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return 'Enter a name.';
    }
    if (_nameTaken(trimmed)) {
      return 'That list already exists.';
    }
    final created = SavedList(id: _mintId(), name: trimmed, words: const []);
    _lists = [..._lists, created];
    activeId = created.id;
    await _persist();
    return null;
  }

  Future<String?> rename(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return 'Enter a name.';
    }
    if (_nameTaken(trimmed, exceptId: id)) {
      return 'That list already exists.';
    }
    final index = _indexOf(id);
    if (index < 0) {
      return 'That list is gone.';
    }
    final next = [..._lists];
    next[index] = next[index].copyWith(name: trimmed);
    _lists = next;
    await _persist();
    return null;
  }

  Future<void> delete(String id) async {
    _lists = [
      for (final list in _lists)
        if (list.id != id) list,
    ];
    if (activeId == id) {
      activeId = _lists.isEmpty ? null : _lists.first.id;
    }
    await _persist();
  }

  Future<String?> addWord(String word) async {
    final id = activeId;
    if (id == null) {
      return 'Create a list first.';
    }
    final clean = word.trim().toLowerCase();
    if (!RegExp(r'^[a-z]+$').hasMatch(clean)) {
      return 'Not a word.';
    }
    final index = _indexOf(id);
    if (index < 0) {
      return 'That list is gone.';
    }
    if (_lists[index].words.contains(clean)) {
      return null;
    }
    final next = [..._lists];
    next[index] = next[index].copyWith(words: [...next[index].words, clean]);
    _lists = next;
    await _persist();
    return null;
  }

  Future<void> removeWord(String id, String word) async {
    final index = _indexOf(id);
    if (index < 0) {
      return;
    }
    final next = [..._lists];
    next[index] = next[index].copyWith(
      words: [
        for (final item in next[index].words)
          if (item != word) item,
      ],
    );
    _lists = next;
    await _persist();
  }

  void select(String id) {
    if (_indexOf(id) < 0 || activeId == id) {
      return;
    }
    activeId = id;
    notifyListeners();
  }

  bool containsWord(String word) {
    final current = active;
    if (current == null) {
      return false;
    }
    return current.words.contains(word);
  }

  Future<void> _persist() async {
    await vault.write(_lists);
    notifyListeners();
  }

  bool _nameTaken(String name, {String? exceptId}) {
    final folded = name.toLowerCase();
    return _lists.any(
      (list) => list.id != exceptId && list.name.toLowerCase() == folded,
    );
  }

  int _indexOf(String id) {
    return _lists.indexWhere((list) => list.id == id);
  }

  String _mintId() {
    var max = 0;
    for (final list in _lists) {
      final match = RegExp(r'^list-(\d+)$').firstMatch(list.id);
      if (match == null) {
        continue;
      }
      final value = int.tryParse(match.group(1) ?? '');
      if (value != null && value > max) {
        max = value;
      }
    }
    return 'list-${max + 1}';
  }
}
