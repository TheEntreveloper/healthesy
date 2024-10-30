import 'package:flutter/foundation.dart';

import '../util/db_util.dart';
import 'base_note.dart';

class Notes extends ChangeNotifier {
  List<Map<String, dynamic>> _result = [];

  load({String? conds,   List? condVals, }) async {
    DbUtil dbUtil = DbUtil('htsy1x');
    _result = await dbUtil.select('mednote', conds: conds, condVals: condVals);
    _result = [..._result];
    if (_result.isNotEmpty) {
      notifyListeners();
    }
  }

  /// op values: 1 = Save, 2 = Update
  Future<int> saveOrUpdateNote(BaseNote note, int op) async {
    int n;
    if (op == 1) {
      n = await note.save();
    } else {
      n = await note.update();
    }
    load();
    return n;
  }

  Future<int> deleteNote(int id) async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int n = await dbUtil.delete('mednote', 'id = ?', [id]);
    return n;
  }

  get result => _result;
}
