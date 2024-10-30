import 'package:flutter/foundation.dart';

import '../util/db_util.dart';
import '../util/note_util.dart';
import 'base_note.dart';
import 'note_type.dart';

class ConsultationNote extends ChangeNotifier with NoteUtil implements BaseNote {
  final String drName;
  final int consultationDate;
  final String comment;
  @override
  int? id = -1;
  @override
  NoteType rectype = NoteType.consult;

  ConsultationNote({required this.drName, required this.consultationDate, this.comment = '', this.id});

  ConsultationNote.fromMap(Map<String, dynamic> map): this(
      id: map['id'],
      drName: map['field1'],
      consultationDate: (map['field2'] is String) ? int.parse(map['field2']) : map['field2'],
      comment: map['field3']
  );

  @override
  Future<int> save() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.insert('mednote',
        {'rectype': 'consult', 'field1': drName, 'field2': consultationDate,
          'field3': comment, 'created': DateTime.now().millisecondsSinceEpoch
        });
    notifyListeners();
    return key;
  }

  @override
  Future<int> update() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.update('mednote',
        {'rectype': 'consult', 'field1': drName, 'field2': consultationDate,
          'field3': comment, 'lastupdate': DateTime.now().millisecondsSinceEpoch
        }, 'id = ?', [id]);
    notifyListeners();
    return key;
  }

}
