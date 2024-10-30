import 'note_type.dart';

abstract class BaseNote {
  int? id = -1;
  NoteType rectype = NoteType.consult;
  Future<int> save();
  Future<int> update();
}
