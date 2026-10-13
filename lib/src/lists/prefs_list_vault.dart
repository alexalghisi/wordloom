import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordloom/src/lists/list_vault.dart';
import 'package:wordloom/src/lists/saved_list.dart';

class PrefsListVault implements ListVault {
  PrefsListVault(this._prefs);

  static const String storageKey = 'wordloom.lists';

  final SharedPreferences _prefs;

  @override
  Future<List<SavedList>> read() async {
    final raw = _prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) {
      return const [];
    }
    return decodeSavedLists(raw);
  }

  @override
  Future<void> write(List<SavedList> lists) async {
    await _prefs.setString(storageKey, encodeSavedLists(lists));
  }
}
