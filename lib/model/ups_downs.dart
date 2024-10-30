import 'package:flutter/foundation.dart';

import '../util/db_util.dart';

class UpsDowns extends ChangeNotifier {
  //late int status;
  //late String qnote;
  List<Map<String, dynamic>> _result = [];

  UpsDowns();

  //UpsDowns.init(this.status, this.qnote);

  Future<int> save(status, qnote) async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.insert('upsdowns', {'status':status, 'qnote': qnote, 'currdate': DateTime.now().millisecondsSinceEpoch});
    load();
    return key;
  }

  load() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    _result = await dbUtil.select('upsdowns');
    _result = [..._result];
    if (_result.isNotEmpty) {
      print('${_result.length} values loaded.');
      notifyListeners();
    }
  }

  get result => _result;
}
