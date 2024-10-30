import 'package:flutter/material.dart';
import 'package:healthesy/view/symptoms_note_view.dart';
import 'consultation_note_view.dart';
import 'incident_note_view.dart';
import 'medcond_note_view.dart';
import 'medtests_note_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  String _selectedNoteType = 'consult';
  //String dt = '';

  late final TextEditingController _emailController;
  late final TextEditingController _mcController, _drNameController,
      _mcCommentController, _consultCommentController;
  TextEditingController dateinput = TextEditingController();
  DateTime dtLastPick = DateTime.now();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _mcController = TextEditingController();
    _drNameController = TextEditingController();
    _mcCommentController = TextEditingController();
    _consultCommentController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mcController.dispose();
    _drNameController.dispose();
    _mcCommentController.dispose();
    _consultCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.newNoteTitle)),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.topCenter,
        child: Column(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: getFormControls(),
          ),
      ),
    );
  }

  List<Widget> getFormControls() {
    List<Widget> controls = [];
    controls.add(DropdownButtonFormField(
      value: _selectedNoteType,
      onChanged: (String? value) {
        dtLastPick = DateTime.now();
        setState(() => _selectedNoteType = value!);
      },
      items: dropdownItems,
    ));
    switch (_selectedNoteType) {
      case 'consult':
        //controls.addAll(getConsultationForm());
      controls.add(getConsultForm());
        break;
      case 'medcond':
        controls.add(getMedcondForm());
        break;
      case 'incident':
        controls.add(Expanded(child: IncidentNoteView()));
        break;
      case 'symptoms':
        controls.add(Expanded(child: SymptomsNoteView()));
        break;
      case 'testres':
        controls.add(Expanded(child: MedtestsNoteView()));
        break;
    }
    controls.add(const SizedBox(height: 10));
    return controls;
  }

  Widget getConsultForm() {
    return Expanded(child: ConsultationNoteView());
  }

  Widget getMedcondForm() {
    return Expanded(child: MedcondNoteView());
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(value: "consult", child: Text(AppLocalizations.of(context)!.consultNoteText)),
      DropdownMenuItem(value: "medcond", child: Text(AppLocalizations.of(context)!.medcondNoteText)),
      DropdownMenuItem(value: "incident", child: Text(AppLocalizations.of(context)!.incidentNoteText)),
      DropdownMenuItem(value: "symptoms", child: Text(AppLocalizations.of(context)!.symptomsNoteText)),
      DropdownMenuItem(value: "testres", child: Text(AppLocalizations.of(context)!.testNoteText)),
    ];
    return menuItems;
  }

  showCalendar(DateTime firstDate, DateTime lastDate) {
    var dtc = dateinput.text.split('/');
    DateTime fdtc = DateTime.now();
    if (dtc.length > 1) {
      fdtc = DateTime.parse(dtc[2] + dtc[0] + dtc[1]);
    }
    return showDatePicker(
      context: context,
      firstDate: DateTime(2000, 1, 1),
      lastDate: DateTime(2022, 12, 31),
      initialDate: dtLastPick,
    ).then((value) => {
      if (value != null) {
        setState(() {
          dtLastPick = value;
          dateinput.text = MaterialLocalizations.of(context).formatCompactDate(value);
        })
      }
    });
  }

  _updateDr(String dr) {

  }
}
