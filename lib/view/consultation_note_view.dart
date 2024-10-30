import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/base_note.dart';
import '../model/health_practitioner.dart';
import '../model/notes.dart';
import '../util/widget_util.dart';
import 'auto_complete.dart';
import '../model/consultation_note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsultationNoteView extends StatefulWidget {
  BaseNote? baseNote;

  ConsultationNoteView({Key? key, this.baseNote}) : super(key: key);

  @override
  _ConsultationNoteViewState createState() => _ConsultationNoteViewState();
}

class _ConsultationNoteViewState extends State<ConsultationNoteView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _drNameController, _consultCommentController;
  DateTime dtLastPick = DateTime.now();
  TextEditingController dateInputController = TextEditingController();
  String _drName = '', btnText = '';
  int noteId = -1;
  List<String> drs = [];

  @override
  void initState() {
    super.initState();
    // unfortunately this cannot be called in init method :-(
    //btnText = AppLocalizations.of(context)!.saveBtn;
    _drNameController = TextEditingController();
    _consultCommentController = TextEditingController();
    if (widget.baseNote != null) {
      noteId = widget.baseNote?.id ?? -1;
      if (noteId > 0) {
        ConsultationNote consultationNote = widget.baseNote as ConsultationNote;
        dateInputController.text =
            consultationNote.fieldAsDateTime(consultationNote.consultationDate)
                .toString();
        dtLastPick = consultationNote.fieldAsDateTime(consultationNote.consultationDate);
        if (consultationNote.comment.isNotEmpty) {
          _consultCommentController.text = consultationNote.comment;
        }
        //btnText = AppLocalizations.of(context)!.updateBtn;
      }
    }
  }

  @override
  void dispose() {
    _drNameController.dispose();
    _consultCommentController.dispose();
    dateInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // nicer in initMethod but not possible after localizations
    btnText = AppLocalizations.of(context)!.saveBtn;
    if (noteId > 0) {
      btnText = AppLocalizations.of(context)!.updateBtn;
    }
    final practitioners = Provider.of<HealthPractitioner>(context, listen: false);
    loadDrs(practitioners);
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
          AutocompleteHelper(
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.drName, filled: false, fillColor: Colors.purple,
                suffixIcon: Icon(
                  Icons.search,
                )
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.drNameMissingText;
              }
              return null;
            }, itemList: drs,
            onSaved: _updateDr,
            initialValue: widget.baseNote != null ? (widget.baseNote as ConsultationNote).drName : null,
          ),
          const SizedBox(height: 10),
          Row(children: [Expanded(child: TextFormField(
            controller: dateInputController,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.consultDate, filled: false, fillColor: Colors.yellow,
                suffixIcon: Icon(
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
                saveDr(practitioners);
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
        ConsultationNote(drName: _drName, consultationDate:
        dtLastPick.millisecondsSinceEpoch, comment: _consultCommentController.text ?? ''), 1).
    then((value) => {
      showDlgOkCancel(context, 'Note saved', 'The consultation details have '
          'been saved').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not saved', 'Something is not right. The note was not saved').then((value) => false)
    });
  }

  updateNote(Notes notes) {
    notes.saveOrUpdateNote(
        ConsultationNote(drName: _drName, consultationDate:
        dtLastPick.millisecondsSinceEpoch, comment: _consultCommentController.text ?? '', id: noteId), 2).
    then((value) => {
      showDlgOkCancel(context, 'Note updated', 'The consultation details have '
          'been updated').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not updated', 'Something is not right. The note was not updated').then((value) => false)
    });
  }

  _updateDr(String? dr) {
    this._drName = dr!;
  }

  onDateSelected(DateTime dateTime) {
    setState(() {
      dtLastPick = dateTime;
      dateInputController.text = MaterialLocalizations.of(context).formatCompactDate(dateTime);
    });
  }

  void saveDr(HealthPractitioner practitioners) async {
    await practitioners.load(drName: _drName);
    List<Map<String, dynamic>> results = practitioners.result;
    if (results.isEmpty) {
      practitioners.persist(hp: _drName);
    }
  }

  loadDrs(HealthPractitioner practitioners) async {
    await practitioners.load();
    List<Map<String, dynamic>> results = practitioners.result;
    if (results.isNotEmpty) {
      for (int i=0;i<results.length;i++) {
        drs.add(results[i]['hp']);
      }
    }
  }
}
