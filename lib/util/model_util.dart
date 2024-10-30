import 'db_util.dart';

mixin ModelUtil {
  List<Map<String, dynamic>> _result = [];

  loadData(String tableName, {String? conds,   List? condVals, String? orderBy,}) async {
    DbUtil dbUtil = DbUtil('htsy1x');
    _result = await dbUtil.select(tableName, conds: conds, condVals: condVals, orderBy: orderBy);
    _result = [..._result];//print('nres = ${_result.length}');
    if (_result.isNotEmpty) {
      notifier();
    }
  }

  notifier();

  Future<int> deleteRow(String tableName, int id) async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int n = await dbUtil.delete(tableName, 'id = ?', [id]);
    return n;
  }

  get result => _result;
}
