import 'package:flutter/foundation.dart';
import '../util/db_util.dart';
import '../util/model_util.dart';

class HealthPractitioner extends ChangeNotifier with ModelUtil {

  load({String? drName}) async {
    List? condVals = null;
    String? conds = null;
    if (drName != null && drName.isNotEmpty) {
      conds = 'hp = ?';
      condVals = [drName];
    }
    await loadData('medpract', conds: conds, condVals: condVals);
    notifyListeners();
  }

  @override
  notifier() {
    notifyListeners();
  }

  Future<int> persist({required String hp, String? pn, String? email, String? tel, int? ptype, int? id}) async {
    DbUtil dbUtil = DbUtil('htsy1x');
    Map<String, Object> fields = {};
    fields['hp'] = hp;
    if (pn != null) { fields['pn'] = pn; }
    if (email != null) { fields['email'] = email; }
    if (tel != null) { fields['tel'] = tel; }
    if (ptype != null) { fields['ptype'] = ptype; }
    fields['regdate'] = DateTime.now().millisecondsSinceEpoch;
    int key;
    if (id == null) {
      key = await dbUtil.insert('medpract',
          fields);
    } else {
      key = await dbUtil.update('medpract', fields, 'id = ?', [id]);
    }
    load();
    notifyListeners();
    return key;
  }
}