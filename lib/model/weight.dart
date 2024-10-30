import 'package:flutter/foundation.dart';

import '../util/db_util.dart';

class Weight extends ChangeNotifier {
  List<Map<String, dynamic>> _result = [];

  Future<int> save(weight, qnote) async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.insert('dbldata', {'vtype':'wt', 'value':weight, 'qnote': qnote, 'currdate': DateTime.now().millisecondsSinceEpoch});
    load();
    return key;
  }

  Future<void> saveBulk(List<Map<String, Object>> wtData) async {
    DbUtil dbUtil = DbUtil('htsy1x');
    await dbUtil.insertBulk('dbldata', wtData);
    load();
  }

  load() async {
    // _result = [{'value': 70.2, 'currdate': DateTime(2022, 1, 1).millisecondsSinceEpoch, 'qnote':'My Jan weight'},
    //   {'value': 72.2, 'currdate': DateTime(2022, 2, 1).millisecondsSinceEpoch, 'qnote':'My Feb weight'},
    //   {'value': 70.9, 'currdate': DateTime(2022, 3, 1).millisecondsSinceEpoch, 'qnote':'My March weight'},
    //   {'value': 75.2, 'currdate': DateTime(2022, 4, 1).millisecondsSinceEpoch, 'qnote':'My April weight'}];
    DbUtil dbUtil = DbUtil('htsy1x');
    _result = await dbUtil.select('dbldata');
    _result = [..._result];
    _result.sort((Map<String, dynamic> m1, Map<String, dynamic> m2) {
      return DateTime.fromMillisecondsSinceEpoch(m1['currdate']).compareTo(DateTime.fromMillisecondsSinceEpoch(m2['currdate']));
    });
    if (_result.isNotEmpty) {
      print('${_result.length} wt values loaded.');
      notifyListeners();
    }
  }

  get result => _result;
}