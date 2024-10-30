import 'package:flutter/foundation.dart';
import '../util/db_util.dart';
import '../util/model_util.dart';

class Messages extends ChangeNotifier with ModelUtil {
  bool loadAfterSave = true;

  @override
  notifier() {
    notifyListeners();
  }

  load() async {
    loadData('messages', orderBy: 'created DESC');
  }

  Future<int> save(int mtype, int senderId, String title, String body) async {

    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.insert('messages',
        {'mtype': mtype, 'senderid': senderId, 'title': title, 'body': body,
           'created': DateTime.now().millisecondsSinceEpoch
        });
    if (loadAfterSave) { load(); } else {
      notifyListeners();
    }
    return key;
  }

  Future<int> update(int mtype, int senderId, String title, String body, int id) async {

    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.update('messages',
        {'mtype': mtype, 'senderid': senderId, 'title': title, 'body': body,
          'created': DateTime.now().millisecondsSinceEpoch
        }, 'id = ?', [id]);
    if (loadAfterSave) { load(); } else {
      notifyListeners();
    }
    return key;
  }

  Future<int> delete(int id) async {
    return deleteRow('messages', id);
  }

}
