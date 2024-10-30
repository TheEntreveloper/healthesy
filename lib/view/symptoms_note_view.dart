import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../model/base_note.dart';
import '../model/notes.dart';
import '../model/symptoms_note.dart';
import '../util/file_util.dart';
import '../util/widget_util.dart';
import 'auto_complete.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'image_pick_view.dart';

class SymptomsNoteView extends StatefulWidget {
  BaseNote? baseNote;

  SymptomsNoteView({Key? key, this.baseNote}) : super(key: key);

  @override
  _SymptomsNoteViewState createState() => _SymptomsNoteViewState();
}

class _SymptomsNoteViewState extends State<SymptomsNoteView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _symptomsCommentController;
  DateTime dtLastPick = DateTime.now();
  TextEditingController dateInputController = TextEditingController();
  String _symptoms = '', btnText = '';
  int noteId = -1;
  List<String> symptomsList = [];
  List<XFile> imageFiles = <XFile>[];

  @override
  void initState() {
    super.initState();
    //btnText = AppLocalizations.of(context)!.saveBtn;
    _symptomsCommentController = TextEditingController();
    if (widget.baseNote != null) {
      noteId = widget.baseNote?.id ?? -1;
      if (noteId > 0) {
        SymptomsNote symptomsNote = widget.baseNote as SymptomsNote;
        dateInputController.text =
            symptomsNote.fieldAsDateTime(symptomsNote.dateStarted)
                .toString();
        dtLastPick = symptomsNote.fieldAsDateTime(symptomsNote.dateStarted);
        if (symptomsNote.comment.isNotEmpty) {
          _symptomsCommentController.text = symptomsNote.comment;
        }
        if (symptomsNote.imgPath.isNotEmpty) {
          symptomsNote.imgPath.split(',').forEach((path) {
            imageFiles.add(XFile(path));
          });
        }
       // btnText = AppLocalizations.of(context)!.updateBtn;
      }
    }
    loadSymptoms();
  }

  @override
  void dispose() {
    _symptomsCommentController.dispose();
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

    String symptText = AppLocalizations.of(context)!.symptoms + AppLocalizations.of(context)!.symptExamples;
    return Form(
        key: _formKey,
        child: CustomScrollView(
            shrinkWrap: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            //physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            //     mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            slivers:[
              SliverPadding(
               padding: const EdgeInsets.all(20.0),
               sliver: SliverList(
                 delegate: SliverChildListDelegate(
                   <Widget>[
              AutocompleteHelper(
                decoration: InputDecoration(
                    labelText: symptText, filled: false, fillColor: Colors.purple,
                    suffixIcon: const Icon(
                      Icons.search,
                    )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter symptoms separated by comma';
                  }
                  return null;
                }, itemList: symptomsList,
                onSaved: _setSymptoms,
                initialValue: widget.baseNote != null ? (widget.baseNote as SymptomsNote).symptoms : null,
                multiSelect: true,
              ),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: TextFormField(
                controller: dateInputController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.dateStarted, filled: false, fillColor: Colors.yellow,
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
                controller: _symptomsCommentController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.comment, filled: false, fillColor: Colors.purple,
                    suffixIcon: const Icon(
                      Icons.comment,
                    )
                ),
                maxLines: 5,
              ),
              Padding(padding: const EdgeInsets.only(top: 5.0), child:
              SizedBox(height: 25, child: Text(AppLocalizations.of(context)!.optionalImage, style: appTheme.textTheme.bodyMedium!.copyWith(color: appTheme.hintColor)),)),
              LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double wd = constraints.maxWidth/2, ht = constraints.maxWidth/2;
                    return SizedBox(width: wd, height: ht,
                        child: ImagePickView(title: 'Related Image',
                          onImagePicked: (List<XFile> files) {
                            imageFiles = files;
                          }, imageFileList: imageFiles, width: wd, height: ht,));}),
              const SizedBox(height: 10),
              Consumer<Notes> (builder: (context, notes, child) {
                return
             ElevatedButton(
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
               ),
              const SizedBox(height: 10),
            ])))]

        ));
  }

  Future<String> noteImgPath() async {
    String mcondImgPath = '';
    if (imageFiles.isNotEmpty) {
      String sep = '';
      wf(xfile) async {
        String fpath = xfile.name ?? 'mcond_' + dtLastPick.toString();
        final file = await FileUtil.getAppFileHandle(fpath);
        await file.writeAsBytes(await xfile.readAsBytes());
        mcondImgPath += sep + file.path;sep = ',';
      }
      for (var xfile in imageFiles) {
        await wf(xfile);
      }
    }
    return mcondImgPath;
  }

  saveNote(Notes notes) async {
    String mcondImgPath = await noteImgPath();
    print('Saving note. Diag. date is ${dtLastPick}');
    notes.saveOrUpdateNote(
        SymptomsNote(symptoms: _symptoms, dateStarted:
        dtLastPick.millisecondsSinceEpoch, comment: _symptomsCommentController.text ?? '',imgPath: mcondImgPath), 1).
    then((value) => {
      showDlgOkCancel(context, 'Note saved', 'Your symptoms '
          'have been added to your Healthesy notebook').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not saved', 'Something is not right. The note was not saved').then((value) => false)
    });
  }

  updateNote(Notes notes) async {
    String mcondImgPath = await noteImgPath();
    print('Updating note. Diag. date is ${dtLastPick}');
    notes.saveOrUpdateNote(
        SymptomsNote(symptoms: _symptoms, dateStarted:
        dtLastPick.millisecondsSinceEpoch, comment: _symptomsCommentController.text ?? '',
            imgPath: mcondImgPath, id: noteId), 2).
    then((value) => {
      showDlgOkCancel(context, 'Note updated', 'Your symptoms '
          'have been updated in your Healthesy notebook').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not updated', 'Something is not right. The note was not updated').then((value) => false)
    });
  }

  _setSymptoms(String? symptoms) {
    _symptoms = symptoms!;
  }

  onDateSelected(DateTime dateTime) {
    setState(() {
      dtLastPick = dateTime;
      dateInputController.text = MaterialLocalizations.of(context).formatCompactDate(dateTime);
    });
  }

  loadSymptoms() async {
    if (symptomsList.isNotEmpty) return;
    Locale userLocale = Localizations.localeOf(context);
    String languageCode = userLocale.languageCode;
    String fileName = 'assets/data/sympts.txt';
    if (languageCode == 'es') {
      fileName = 'assets/data/sympts_es.txt';
    } else if (languageCode == 'fr') {
      fileName = 'assets/data/sympts_fr.txt';
    }
    String sympts = await FileUtil.loadAsset(context, fileName);
    List<dynamic> dynList = jsonDecode(sympts);
    for (var element in dynList) {
      symptomsList.add(element);
    }
  }
}
