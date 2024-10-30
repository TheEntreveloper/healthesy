import 'package:flutter/material.dart';
import 'package:healthesy/view/symptoms_note_view.dart';
import '../model/base_note.dart';
import '../model/note_type.dart';
import 'consultation_note_view.dart';
import 'incident_note_view.dart';
import 'medcond_note_view.dart';
import 'medtests_note_view.dart';

class EdNote extends StatefulWidget {
  BaseNote baseNote;

  EdNote({Key? key, required this.baseNote}) : super(key: key);

  @override
  _EdNoteState createState() => _EdNoteState();
}

class _EdNoteState extends State<EdNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Edit Note')),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.topCenter,
          child: getNoteEditor(),
        )
    );
  }

  Widget getNoteEditor() {
    switch(widget.baseNote.rectype) {
      case NoteType.consult:
        return ConsultationNoteView(baseNote: widget.baseNote);
      case NoteType.medcond:
        return MedcondNoteView(baseNote: widget.baseNote);
      case NoteType.eventful:
        return IncidentNoteView(baseNote: widget.baseNote);
      case NoteType.symptoms:
        return SymptomsNoteView(baseNote: widget.baseNote);
      case NoteType.tests:
        return MedtestsNoteView(baseNote: widget.baseNote);
    }
    return Text('Nothing to edit');
  }
}
