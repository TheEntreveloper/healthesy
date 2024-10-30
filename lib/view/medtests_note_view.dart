import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../model/base_note.dart';
import '../model/medtests_note.dart';
import '../model/notes.dart';
import '../util/file_util.dart';
import '../util/widget_util.dart';
import 'auto_complete.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'image_pick_view.dart';
import 'medtest_view.dart';

class MedtestsNoteView extends StatefulWidget {
  BaseNote? baseNote;

  MedtestsNoteView({Key? key, this.baseNote}) : super(key: key);

  @override
  _MedtestsNoteViewState createState() => _MedtestsNoteViewState();
}

class _MedtestsNoteViewState extends State<MedtestsNoteView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _medtestsCommentController, _medtestsValueController;
  DateTime dtLastPick = DateTime.now();
  TextEditingController dateInputController = TextEditingController();
  String _medtests = '', btnText = '';
  int noteId = -1;
  List<String> medtestsList = [];
  List<XFile> imageFiles = <XFile>[];
  List<dynamic> testObjList = [];
  var testProps = {};

  @override
  void initState() {
    super.initState();
    //btnText = AppLocalizations.of(context)!.saveBtn;
    loadMedtests();
    _medtestsCommentController = TextEditingController();
    _medtestsValueController = TextEditingController();
    if (widget.baseNote != null) {
      noteId = widget.baseNote?.id ?? -1;
      if (noteId > 0) {
        MedtestsNote medtestsNote = widget.baseNote as MedtestsNote;
        _medtests = medtestsNote.medtests;
        dateInputController.text =
            medtestsNote.fieldAsDateTime(medtestsNote.testDate)
                .toString();
        dtLastPick = medtestsNote.fieldAsDateTime(medtestsNote.testDate);
        _medtestsValueController.text = medtestsNote.testValue;
        if (medtestsNote.comment.isNotEmpty) {
          _medtestsCommentController.text = medtestsNote.comment;
        }
        if (medtestsNote.imgPath.isNotEmpty) {
          medtestsNote.imgPath.split(',').forEach((path) {
            imageFiles.add(XFile(path));
          });
        }
        //btnText = AppLocalizations.of(context)!.updateBtn;
      }
    }
  }

  @override
  void dispose() {
    _medtestsCommentController.dispose();
    _medtestsValueController.dispose();
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
    String medTestsText = AppLocalizations.of(context)!.medtests + AppLocalizations.of(context)!.testsExamples;
    return Form(
        key: _formKey,
        child: CustomScrollView(
            shrinkWrap: true,
            slivers:[
              SliverPadding(
                  padding: const EdgeInsets.all(20.0),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                          <Widget>[
                            AutocompleteHelper(
                              decoration: InputDecoration(
                                  labelText: medTestsText, filled: false, fillColor: Colors.purple,
                                  suffixIcon: const Icon(
                                    Icons.search,
                                  )
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter medtests separated by comma';
                                }
                                return null;
                              }, itemList: medtestsList,
                              onSaved: _setMedtests,
                              onSelected: testSelected,
                              initialValue: widget.baseNote != null ? (widget.baseNote as MedtestsNote).medtests : null,
                            ),
                            _medtests.isNotEmpty && testProps.isNotEmpty ? MedtestView(testSpec: testProps[_medtests],
                              resultValue: (String value) { _medtestsValueController.text = value;
 return null; },
                              initialValue: _medtestsValueController.text,) : const Text(''),
                            const SizedBox(height: 10),
                            Row(children: [Expanded(child: TextFormField(
                              controller: dateInputController,
                              decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.dateTested, filled: false, fillColor: Colors.yellow,
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
                              controller: _medtestsCommentController,
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
        MedtestsNote(medtests: _medtests, testValue: _medtestsValueController.text, testDate:
        dtLastPick.millisecondsSinceEpoch, comment: _medtestsCommentController.text ?? '',imgPath: mcondImgPath), 1).
    then((value) => {
      showDlgOkCancel(context, 'Note saved', 'Your medtests '
          'have been added to your Healthesy notebook').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not saved', 'Something is not right. The note was not saved').then((value) => false)
    });
  }

  updateNote(Notes notes) async {
    String mcondImgPath = await noteImgPath();
    print('Updating note. Diag. date is ${dtLastPick}');
    notes.saveOrUpdateNote(
        MedtestsNote(medtests: _medtests, testValue: _medtestsValueController.text, testDate:
        dtLastPick.millisecondsSinceEpoch, comment: _medtestsCommentController.text ?? '',
            imgPath: mcondImgPath, id: noteId), 2).
    then((value) => {
      showDlgOkCancel(context, 'Note updated', 'Your medtests '
          'have been updated in your Healthesy notebook').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
      showDlgOkCancel(context, 'Note Not updated', 'Something is not right. The note was not updated').then((value) => false)
    });
  }

  _setMedtests(String? medtests) {
    setState(() {
      _medtests = medtests!;
    });

  }

  onDateSelected(DateTime dateTime) {
    setState(() {
      dtLastPick = dateTime;
      dateInputController.text = MaterialLocalizations.of(context).formatCompactDate(dateTime);
    });
  }

  Future<void> loadMedtests() async {
    if (medtestsList.isNotEmpty) return;
    String mtests = await FileUtil.loadAsset(context, 'assets/data/medtests.txt');
    testObjList = jsonDecode(mtests);
    for (var element in testObjList) {
      medtestsList.add(element['test']);
      testProps[element['test']] = element;
    }
    setState(() {});
  }

  void testSelected(String option) {
    setState(() {
      _medtests = option;
    });
  }
}
