import 'package:wordloom/src/lists/saved_list.dart';

abstract interface class ListVault {
  Future<List<SavedList>> read();

  Future<void> write(List<SavedList> lists);
}
