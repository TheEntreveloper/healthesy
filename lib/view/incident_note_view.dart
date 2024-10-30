import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/base_note.dart';
import '../model/incident_note.dart';
import '../model/notes.dart';
import '../util/widget_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IncidentNoteView extends StatefulWidget {
  BaseNote? baseNote;

  IncidentNoteView({Key? key, this.baseNote}) : super(key: key);

  @override
  _IncidentNoteViewState createState() => _IncidentNoteViewState();
}

class _IncidentNoteViewState extends State<IncidentNoteView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _incidentNameController, _consultCommentController;
  DateTime dtLastPick = DateTime.now();
  TextEditingController dateInputController = TextEditingController();
  String _incidentName = '', btnText = '';
  int noteId = -1;

  @override
  void initState() {
    super.initState();
    //btnText = AppLocalizations.of(context)!.saveBtn;
    _incidentNameController = TextEditingController();
    _consultCommentController = TextEditingController();
    if (widget.baseNote != null) {
      noteId = widget.baseNote?.id ?? -1;
      if (noteId > 0) {
        IncidentNote incidentNote = widget.baseNote as IncidentNote;
        dateInputController.text =
            incidentNote.fieldAsDateTime(incidentNote.incidentDate)
                .toString();
        dtLastPick = incidentNote.fieldAsDateTime(incidentNote.incidentDate);
        if (incidentNote.comment.isNotEmpty) {
          _consultCommentController.text = incidentNote.comment;
        }
        //btnText = AppLocalizations.of(context)!.updateBtn;
      }
    }
  }

  @override
  void dispose() {
    _incidentNameController.dispose();
    _consultCommentController.dispose();
    dateInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    btnText = AppLocalizations.of(context)!.saveBtn;
    if (noteId > 0) {
      btnText = AppLocalizations.of(context)!.updateBtn;
    }
    DateTime? now = DateTime.now();
    DateTime bef = now.subtract(const Duration(days: 365));
    DateTime aft = now.add(const Duration(days: 365));

    return Form(
        key: _formKey,
        child: ListView(
            shrinkWrap: true,
            //     mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            children:[
              TextFormField(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.nameIncident, filled: false, fillColor: Colors.purple,
                    suffixIcon: const Icon(
                      Icons.search,
                    )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please name the incident';
                  }
                  return null;
                },
                onSaved: _updateDr,
                initialValue: widget.baseNote != null ? (widget.baseNote as IncidentNote).incidentName : null,
              ),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: TextFormField(
                controller: dateInputController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.incidentDate, filled: false, fillColor: Colors.yellow,
                    suffixIcon: const Icon(
                      Icons.date_range,
                    )
                ),
                onTap: () => {
                  showCalendar(context: context, firstDate: bef,
                      lastDate: aft, initialDate: dtLastPick,
                      onSelected: onDateSelected)
                },
              )), ],),
              TextFormField(
                controller: _consultCommentController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.comment, filled: false, fillColor: Colors.purple,
                    suffixIcon: const Icon(
                      Icons.comment,
                    )
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 10),
              Consumer<Notes> (builder: (context, notes, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (noteId > 0) {
                        updateNote(notes);
                      } else {
                        saveNote(notes);
                      }
                    }
                  },
                  child: Text(btnText),
                );
              }
              )
            ]

        ));
  }

  saveNote(Notes notes) {
    notes.saveOrUpdateNote(
        IncidentNote(incidentName: _incidentName, incidentDate:
        dtLastPick.millisecondsSinceEpoch, comment: _consultCommentController.text ?? ''), 1).
    then((value) => {
      showDlgOkCancel(context, 'Note saved', 'The incident has been recorded in '
          'your Healthesy notebook').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not saved', 'Something is not right. The note was not saved').then((value) => false)
    });
  }

  updateNote(Notes notes) {
    notes.saveOrUpdateNote(
        IncidentNote(incidentName: _incidentName, incidentDate:
        dtLastPick.millisecondsSinceEpoch, comment: _consultCommentController.text ?? '', id: noteId), 2).
    then((value) => {
      showDlgOkCancel(context, 'Note saved', 'The incident has been updated in '
          'your Healthesy notebook').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not saved', 'Something is not right. The note was not saved').then((value) => false)
    });
  }

  _updateDr(String? dr) {
    this._incidentName = dr!;
  }

  onDateSelected(DateTime dateTime) {
    setState(() {
      dtLastPick = dateTime;
      dateInputController.text = MaterialLocalizations.of(context).formatCompactDate(dateTime);
    });
  }
}
