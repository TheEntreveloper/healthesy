import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/weight.dart';
import '../util/widget_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeightDataForm extends StatefulWidget {
  const WeightDataForm({Key? key}) : super(key: key);

  @override
  _WeightDataFormState createState() => _WeightDataFormState();
}

class _WeightDataFormState extends State<WeightDataForm> {
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> dateInputControllers = [];
  List<DateTime> dtLastPicks = [];
  List<TextEditingController> weightInputControllers = [];

  @override
  void initState() {
    super.initState();
    for (int i=0;i<5;i++) {
      dtLastPicks.add(DateTime.now());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weight Data Form')),
        body: Form(
            key: _formKey,
            //color: appTheme.backgroundColor,
            child:
            CustomScrollView(
                primary: false,
                slivers: <Widget>[
                  SliverPadding(
                      padding: const EdgeInsets.all(5),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(weigthEntryList(5)),
                      )
                  )]
            )
        )
    );
  }

  weigthEntryList(int n) {
    List<Widget> widgets = [];
    widgets.add(const Text('Please enter one or more dates and your weight as recorded on that date'));
    for (int i=0;i<n;i++) {
      widgets.add(weightEntryRow(i));
    }
    widgets.add(
        Consumer<Weight>(builder: (context, weights, child) {
          return ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                saveWeights(weights);
              }
            },
            child: Text(AppLocalizations.of(context)!.saveBtn),
          );
        }
        )
    );
    return widgets;
  }

  saveWeights(Weight weights) {
    List<Map<String, Object>> wtData = [];
    for (int i=0;i<5;i++) {
      if (dateInputControllers[i].text.isNotEmpty && weightInputControllers[i].text.isNotEmpty) {
        wtData.add({'vtype':'wt', 'value':weightInputControllers[i].text, 'qnote': '',
          'currdate': dtLastPicks[i].millisecondsSinceEpoch});
      }
    }
    weights.saveBulk(wtData).
    then((value) => {
    showDlgOkCancel(context, 'Weight data saved', 'Your weight data has '
    'been saved').then((value) => Navigator.maybePop(context))
    }).onError((error, stackTrace) => {
    showDlgOkCancel(context, 'Weight data Not saved', 'Something is not right. The data was not saved').then((value) => false)
    });
  }

  weightEntryRow(int index) {
    DateTime? now = DateTime.now();
    DateTime aft = now.add(const Duration(days: 365));
    dateInputControllers.add(TextEditingController());
    weightInputControllers.add(TextEditingController());

    return Row(children: [Expanded(child: TextFormField(
      controller: dateInputControllers[index],
      decoration: const InputDecoration(
          labelText: 'Date', filled: false, fillColor: Colors.yellow,
          suffixIcon: Icon(
            Icons.date_range,
          )
      ),
      onTap: () => {

        showCalendarWt(context: context, firstDate: DateTime(2000, 1, 1),
            lastDate: aft, initialDate: dtLastPicks[index],
            onSelected: onDateSelected, index: index)
      },
    )),
      Expanded(child: TextFormField(
        controller: weightInputControllers[index],
        decoration: const InputDecoration(
            labelText: 'Weight', filled: false, fillColor: Colors.purple,
            suffixIcon: Icon(
              Icons.assignment_ind_outlined,
            )
        ),
        maxLines: 1,
        keyboardType: TextInputType.number,
      )),
    ],);
  }

  onDateSelected(DateTime dateTime, int index) {
    setState(() {
      dtLastPicks[index] = dateTime;
      dateInputControllers[index].text = MaterialLocalizations.of(context).formatCompactDate(dateTime);
    });
  }

  showCalendarWt({required BuildContext context, required DateTime firstDate,
    required DateTime lastDate, required DateTime initialDate, void Function(DateTime, int)? onSelected, required int index}) {

    DateTime? now = DateTime.now();
    DateTime bef = now.subtract(const Duration(days: 365));
    DateTime aft = now.add(const Duration(days: 365));

    return showDatePicker(
      context: context,
      firstDate: bef,
      lastDate: aft,
      initialDate: initialDate,
    ).then((value) => {
      if (value != null) {
        onSelected!(value, index)
      }
    });
  }

  @override
  void dispose() {

    super.dispose();
  }
}
