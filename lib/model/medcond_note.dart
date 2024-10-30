import 'package:flutter/foundation.dart';

import '../util/db_util.dart';
import '../util/note_util.dart';
import 'base_note.dart';
import 'note_type.dart';

class MedcondNote extends ChangeNotifier with NoteUtil implements BaseNote {
  final String drName, mcondName;
  final int dateDiagnosed;
  final String comment;
  final String imgPath;
  @override
  int? id = -1;
  @override
  NoteType rectype = NoteType.medcond;

  MedcondNote({required this.mcondName, required this.drName, required this.dateDiagnosed, this.comment = '', this.imgPath = '', this.id});

  MedcondNote.fromMap(Map<String, dynamic> map): this(
      id: map['id'],
      mcondName: map['field1'],
      drName: map['field2'],
      dateDiagnosed: (map['field3'] is String) ? int.parse(map['field3']) : map['field3'],
      comment: map['field4'],
      imgPath: map['field5']
  );

  @override
  Future<int> save() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.insert('mednote',
        {'rectype': 'medcond', 'field1': mcondName, 'field2': drName, 'field3': dateDiagnosed,
          'field4': comment, 'field5': imgPath, 'created': DateTime.now().millisecondsSinceEpoch
        });
    notifyListeners();
    return key;
  }

  @override
  Future<int> update() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.update('mednote',
        {'rectype': 'medcond', 'field1': mcondName, 'field2': drName, 'field3': dateDiagnosed,
          'field4': comment, 'field5': imgPath, 'lastupdate': DateTime.now().millisecondsSinceEpoch
        }, 'id = ?', [id]);
    notifyListeners();
    return key;
  }

}
