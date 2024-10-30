import 'package:flutter/foundation.dart';

import '../util/db_util.dart';
import '../util/note_util.dart';
import 'base_note.dart';
import 'note_type.dart';

class SymptomsNote extends ChangeNotifier with NoteUtil implements BaseNote {
  final String symptoms;
  final int dateStarted;
  final String comment;
  final String imgPath;
  @override
  int? id = -1;
  @override
  NoteType rectype = NoteType.symptoms;

  SymptomsNote({required this.symptoms, required this.dateStarted, this.comment = '', this.imgPath = '', this.id});

  SymptomsNote.fromMap(Map<String, dynamic> map): this(
      id: map['id'],
      symptoms: map['field1'],
      dateStarted: (map['field3'] is String) ? int.parse(map['field3']) : map['field3'],
      comment: map['field4'],
      imgPath: map['field5']
  );

  @override
  Future<int> save() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.insert('mednote',
        {'rectype': 'symptoms', 'field1': symptoms, 'field3': dateStarted,
          'field4': comment, 'field5': imgPath, 'created': DateTime.now().millisecondsSinceEpoch
        });
    notifyListeners();
    return key;
  }

  @override
  Future<int> update() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.update('mednote',
        {'rectype': 'symptoms', 'field1': symptoms, 'field3': dateStarted,
          'field4': comment, 'field5': imgPath, 'lastupdate': DateTime.now().millisecondsSinceEpoch
        }, 'id = ?', [id]);
    notifyListeners();
    return key;
  }

}
