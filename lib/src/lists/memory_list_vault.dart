import 'package:wordloom/src/lists/list_vault.dart';
import 'package:wordloom/src/lists/saved_list.dart';

class MemoryListVault implements ListVault {
  MemoryListVault([List<SavedList>? seed]) : _lists = _copy(seed ?? const []);

  List<SavedList> _lists;

  @override
  Future<List<SavedList>> read() async {
    return _copy(_lists);
  }

  @override
  Future<void> write(List<SavedList> lists) async {
    _lists = _copy(lists);
  }

  static List<SavedList> _copy(List<SavedList> lists) {
    return [for (final list in lists) list.copyWith(words: list.words)];
  }
}
