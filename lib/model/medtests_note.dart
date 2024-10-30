import 'package:flutter/foundation.dart';

import '../util/db_util.dart';
import '../util/note_util.dart';
import 'base_note.dart';
import 'note_type.dart';

class MedtestsNote extends ChangeNotifier with NoteUtil implements BaseNote {
  final String medtests;
  final String testValue;
  final int testDate;
  final String comment;
  final String imgPath;
  String? insight = '';
  @override
  int? id = -1;
  @override
  NoteType rectype = NoteType.tests;

  MedtestsNote({required this.medtests, required this.testValue, required this.testDate, this.comment = '', this.imgPath = '', this.id, this.insight});

  MedtestsNote.fromMap(Map<String, dynamic> map): this(
      id: map['id'],
      medtests: map['field1'],
      testValue: map['field6'],
      testDate: (map['field3'] is String) ? int.parse(map['field3']) : map['field3'],
      comment: map['field4'],
      imgPath: map['field5'],
      insight: map['field2']
  );

  @override
  Future<int> save() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.insert('mednote',
        {'rectype': 'tests', 'field1': medtests, 'field6': testValue, 'field3': testDate,
          'field4': comment, 'field5': imgPath, 'field2': insight??'', 'created': DateTime.now().millisecondsSinceEpoch
        });
    notifyListeners();
    return key;
  }

  @override
  Future<int> update() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.update('mednote',
        {'rectype': 'tests', 'field1': medtests, 'field6': testValue, 'field3': testDate,
          'field4': comment, 'field5': imgPath, 'field2': insight ?? '', 'lastupdate': DateTime.now().millisecondsSinceEpoch
        }, 'id = ?', [id]);
    notifyListeners();
    return key;
  }

}
