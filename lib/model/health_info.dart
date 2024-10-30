import 'package:flutter/foundation.dart';

import '../util/db_util.dart';
import '../util/model_util.dart';

class HealthInfo extends ChangeNotifier with ModelUtil {
  String? rf1;
  bool loadAfterSave = true;

  HealthInfo();

  rfFromMap(Map<String, dynamic> rf) {
    rf1 = '';
    rf.forEach((key, value) {
      if (value) { rf1 = '${rf1!}$key,'; }
    });
    return rf1;
  }

  load() async {
    await loadData('hinfo', conds: 'id=?', condVals: [1]);
    notifyListeners();
  }

  @override
  notifier() {
    notifyListeners();
  }

  Future<int> save(ht, wt, gender, ager, rf1) async {
    if (ht == null || wt == null || gender == null || ager == null || rf1 == null) return -1;

    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.insert('hinfo',
        {'id': 1, 'ht': ht!, 'wt': wt!, 'gender': gender!,
          'ager': ager!, 'rf1': rf1!, 'created': DateTime.now().millisecondsSinceEpoch
        });
    if (loadAfterSave) {
      await load();
    } else {
      notifyListeners();
    }
    return key;
  }

  Future<int> update(ht, wt, gender, ager, rf1) async {
    if (ht == null || wt == null || gender == null || ager == null || rf1 == null) return -1;

    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.update('hinfo',
        {'ht': ht!, 'wt': wt!, 'gender': gender!,
          'ager': ager!, 'rf1': rf1!, 'lastupdate': DateTime.now().millisecondsSinceEpoch
        }, 'id = ?', [1]);
    if (loadAfterSave) {
      await load();
    } else {
      notifyListeners();
    }
    return key;
  }
}
