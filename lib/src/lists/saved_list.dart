import 'dart:convert';

class SavedList {
  SavedList({required this.id, required this.name, required List<String> words})
    : words = List<String>.unmodifiable(words);

  final String id;
  final String name;
  final List<String> words;

  SavedList copyWith({String? name, List<String>? words}) {
    return SavedList(
      id: id,
      name: name ?? this.name,
      words: words ?? this.words,
    );
  }

  Map<String, Object> toJson() {
    return {'id': id, 'name': name, 'words': words};
  }
}

List<SavedList> decodeSavedLists(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const [];
    }
    final lists = <SavedList>[];
    for (final item in decoded) {
      final parsed = _parseList(item);
      if (parsed != null) {
        lists.add(parsed);
      }
    }
    return lists;
  } on FormatException {
    return const [];
  }
}

String encodeSavedLists(List<SavedList> lists) {
  return jsonEncode(lists.map((list) => list.toJson()).toList());
}

SavedList? _parseList(Object? item) {
  if (item is! Map) {
    return null;
  }
  final id = item['id'];
  final name = item['name'];
  final words = item['words'];
  if (id is! String || id.isEmpty || name is! String || name.isEmpty) {
    return null;
  }
  if (words is! List) {
    return null;
  }
  final clean = <String>[];
  for (final word in words) {
    if (word is String && RegExp(r'^[a-z]+$').hasMatch(word)) {
      clean.add(word);
    }
  }
  return SavedList(id: id, name: name, words: clean);
}
