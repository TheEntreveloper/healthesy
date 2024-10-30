import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../model/base_note.dart';
import '../model/health_practitioner.dart';
import '../model/medcond_note.dart';
import '../model/notes.dart';
import '../util/file_util.dart';
import '../util/widget_util.dart';
import 'auto_complete.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'image_pick_view.dart';

class MedcondNoteView extends StatefulWidget {
  BaseNote? baseNote;

  MedcondNoteView({Key? key, this.baseNote}) : super(key: key);

  @override
  _MedcondNoteViewState createState() => _MedcondNoteViewState();
}

class _MedcondNoteViewState extends State<MedcondNoteView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _drNameController, _medcondCommentController;
  DateTime dtLastPick = DateTime.now();
  TextEditingController dateInputController = TextEditingController();
  String _drName = '', _diseaseName = '', btnText = '';
  int noteId = -1;
  List<String> diseases = [], drs = [];
  List<XFile> imageFiles = <XFile>[];

  @override
  void initState() {
    super.initState();
    //btnText = AppLocalizations.of(context)!.saveBtn;
    _drNameController = TextEditingController();
    _medcondCommentController = TextEditingController();
    if (widget.baseNote != null) {
      noteId = widget.baseNote?.id ?? -1;
      if (noteId > 0) {
        MedcondNote medcondNote = widget.baseNote as MedcondNote;
        dateInputController.text =
            medcondNote.fieldAsDateTime(medcondNote.dateDiagnosed)
                .toString();
        dtLastPick = medcondNote.fieldAsDateTime(medcondNote.dateDiagnosed);
        if (medcondNote.comment.isNotEmpty) {
          _medcondCommentController.text = medcondNote.comment;
        }
        if (medcondNote.imgPath.isNotEmpty) {
          medcondNote.imgPath.split(',').forEach((path) {
            imageFiles.add(XFile(path));
          });
        }
        //btnText = AppLocalizations.of(context)!.updateBtn;
      }
    }
    loadDiseases();
  }

  @override
  void dispose() {
    _drNameController.dispose();
    _medcondCommentController.dispose();
    dateInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final practitioners = Provider.of<HealthPractitioner>(context, listen: false);
    btnText = AppLocalizations.of(context)!.saveBtn;
    if (noteId > 0) {
      btnText = AppLocalizations.of(context)!.updateBtn;
    }
    loadDrs(practitioners);

    DateTime? now = DateTime.now();
    DateTime bef = now.subtract(const Duration(days: 365));

    return Form(
        key: _formKey,
        child: ListView(
            shrinkWrap: true,
            //     mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            children:[
              AutocompleteHelper(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.medcondText, filled: false, fillColor: Colors.purple,
                    suffixIcon: const Icon(
                      Icons.search,
                    )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name of disease';
                  }
                  return null;
                }, itemList: diseases,
                onSaved: _setDiseaseName,
                initialValue: widget.baseNote != null ? (widget.baseNote as MedcondNote).mcondName : null,
              ),
              const SizedBox(height: 10),
              AutocompleteHelper(
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.diagnosedByText, filled: false, fillColor: Colors.purple,
                    suffixIcon: const Icon(
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
                initialValue: widget.baseNote != null ? (widget.baseNote as MedcondNote).drName : null,
              ),
              const SizedBox(height: 10),
              Row(children: [Expanded(child: TextFormField(
                controller: dateInputController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.dateDiagnosed, filled: false, fillColor: Colors.yellow,
                    suffixIcon: const Icon(
                      Icons.date_range,
                    )
                ),
                onTap: () => {
                  showCalendar(context: context, firstDate: bef,
                      lastDate: DateTime(dtLastPick.year, 12, 31), initialDate: dtLastPick,
                      onSelected: onDateSelected)
                },
              )), ],),
              TextFormField(
                controller: _medcondCommentController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.comment, filled: false, fillColor: Colors.purple,
                    suffixIcon: const Icon(
                      Icons.comment,
                    )
                ),
                maxLines: 5,
              ),
              Padding(padding: EdgeInsets.only(top: 5.0), child:
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
        MedcondNote(mcondName: _diseaseName, drName: _drName, dateDiagnosed:
        dtLastPick.millisecondsSinceEpoch, comment: _medcondCommentController.text ?? '',imgPath: mcondImgPath), 1).
    then((value) => {
      showDlgOkCancel(context, 'Note saved', 'The medical condition '
          'has been added to your Healthesy notebook').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not saved', 'Something is not right. The note was not saved').then((value) => false)
    });
  }

  updateNote(Notes notes) async {
    String mcondImgPath = await noteImgPath();
    print('Updating note. Diag. date is ${dtLastPick}');
    notes.saveOrUpdateNote(
        MedcondNote(mcondName: _diseaseName, drName: _drName, dateDiagnosed:
        dtLastPick.millisecondsSinceEpoch, comment: _medcondCommentController.text ?? '',
            imgPath: mcondImgPath, id: noteId), 2).
    then((value) => {
      showDlgOkCancel(context, 'Note updated', 'The medical condition '
          'has been updated in your Healthesy notebook').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not updated', 'Something is not right. The note was not updated').then((value) => false)
    });
  }

  _setDiseaseName(String? dname) {
    _diseaseName = dname!;
  }

  _updateDr(String? dr) {
    _drName = dr!;
  }

  onDateSelected(DateTime dateTime) {
    setState(() {
      dtLastPick = dateTime;
      dateInputController.text = MaterialLocalizations.of(context).formatCompactDate(dateTime);
    });
  }

  loadDiseases() async {
    if (diseases.isNotEmpty) return;
    String diss = await FileUtil.loadAsset(context, 'assets/data/diseases.txt');
    List<dynamic> dynList = jsonDecode(diss);
    dynList.forEach((element) {
      diseases.add(element);
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
