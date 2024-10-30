import 'package:flutter/foundation.dart';

import '../util/db_util.dart';
import '../util/note_util.dart';
import 'base_note.dart';
import 'note_type.dart';

class IncidentNote extends ChangeNotifier with NoteUtil implements BaseNote {
  final String incidentName;
  final int incidentDate;
  final String comment;
  @override
  int? id = -1;
  @override
  NoteType rectype = NoteType.eventful;

  IncidentNote({required this.incidentName, required this.incidentDate, this.comment = '', this.id});

  IncidentNote.fromMap(Map<String, dynamic> map): this(
      id: map['id'],
      incidentName: map['field1'],
      incidentDate: (map['field2'] is String) ? int.parse(map['field2']) : map['field2'],
      comment: map['field3']
  );

  @override
  Future<int> save() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.insert('mednote',
        {'rectype': 'incident', 'field1': incidentName, 'field2': incidentDate,
          'field3': comment, 'created': DateTime.now().millisecondsSinceEpoch
        });
    notifyListeners();
    return key;
  }

  @override
  Future<int> update() async {
    DbUtil dbUtil = DbUtil('htsy1x');
    int key = await dbUtil.update('mednote',
        {'rectype': 'incident', 'field1': incidentName, 'field2': incidentDate,
          'field3': comment, 'lastupdate': DateTime.now().millisecondsSinceEpoch
        }, 'id = ?', [id]);
    notifyListeners();
    return key;
  }

}
