import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../config/theme.dart';
import '../model/base_note.dart';
import '../model/consultation_note.dart';
import '../model/incident_note.dart';
import '../model/medcond_note.dart';
import '../model/medtests_note.dart';
import '../model/notes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/symptoms_note.dart';

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView>
    with AutomaticKeepAliveClientMixin<NotesView> {
  int notesCount = 25;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Consumer<Notes>(builder: (context, notes, child) {
          notesCount = notes.result.length;
          if (notesCount > 0) {
              return CustomScrollView(slivers: <Widget>[
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            if (index.isOdd) {
                              return const Divider(height: 2, color: Colors.black12,thickness: 2,);
                            }
                            int reIdx = index ~/ 2;
                            final note = notes.result[reIdx];
                            DateTime date = DateTime.now();
                            BaseNote? baseNote = null;
                            switch(note['rectype']) {
                              case 'consult':
                                date = DateTime.fromMillisecondsSinceEpoch(int.parse(notes.result[reIdx]['field2']));
                                baseNote = ConsultationNote.fromMap(note);
                                break;
                              case 'medcond':
                                date = DateTime.fromMillisecondsSinceEpoch(int.parse(notes.result[reIdx]['field3']));
                                baseNote = MedcondNote.fromMap(note);
                                break;
                              case 'incident':
                                date = DateTime.fromMillisecondsSinceEpoch(int.parse(notes.result[reIdx]['field2']));
                                baseNote = IncidentNote.fromMap(note);
                                break;
                              case 'symptoms':
                                date = DateTime.fromMillisecondsSinceEpoch(int.parse(notes.result[reIdx]['field3']));
                                baseNote = SymptomsNote.fromMap(note);
                                break;
                              case 'tests':
                                date = DateTime.fromMillisecondsSinceEpoch(int.parse(notes.result[reIdx]['field3']));
                                baseNote = MedtestsNote.fromMap(note);
                                break;
                            }
                            String dateOnly = MaterialLocalizations.of(context).formatCompactDate(date);

                        return Dismissible(
                                // Each Dismissible must contain a Key. Keys allow Flutter to
                                // uniquely identify widgets.
                                key: Key(note["id"].toString()),
                            // Provide a function that tells the app
                            // what to do after an item has been swiped away.
                            onDismissed: (direction) {
                            // Remove the item from the data source.
                            noteDelete(notes, note["id"], reIdx);

                            // Then show a snackbar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.noteDelMsg)));
                            },
                            // Show a red background as the item is swiped away.
                            background: Container(color: Colors.red, child: Text(AppLocalizations.of(context)!.noteWillDelMsg)),
                            child:ListTile(
                             // leading: Text(notes.result[reIdx]['rectype']),
                          title: Text(notes.result[reIdx]['rectype']),
                          isThreeLine: true,
                          subtitle: Align(alignment: Alignment.topLeft, child: customSubtitle(secondaryText: notes.result[reIdx]['field1'] , tertiaryText: dateOnly)),
                              trailing: const SizedBox(width: 20, child: Align(alignment: Alignment.centerRight, child: Icon(Icons.chevron_right))),
                              onTap: () => {
                                if (baseNote != null) {
                                  noteEdit(baseNote, reIdx)
                                }
                              },
                        ));
                      },
                      semanticIndexCallback: (Widget widget, int localIndex) {
                        if (localIndex.isEven) {
                          return localIndex ~/ 2;
                        }
                        return null;
                      },
                      childCount: notesCount*2,
                    )),

              ]);
          } else {
            notes.load();
            return Center(child: Text(AppLocalizations.of(context)!.noNotesMsg));
          }
        }));
  }

  Widget customSubtitle({String? secondaryText, String? tertiaryText}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(secondaryText!, style: appTheme.textTheme.headlineSmall,),
      Text(tertiaryText!, style: appTheme.textTheme.bodySmall,)
    ],);
  }

  noteEdit(BaseNote note, int index) {
    context.go('/edconsnote', extra: {'note': note});
  }

  noteDelete(Notes notes, int id, int index) async {
    int n = await notes.deleteNote(id);
    if (n > 0) {
      setState(() {
        notes.result.removeAt(index);
      });
    }
  }

  @override
  bool get wantKeepAlive => true;
}
