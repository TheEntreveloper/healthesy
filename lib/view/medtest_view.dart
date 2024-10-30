import 'package:flutter/material.dart';

class MedtestView extends StatefulWidget {
  final Map<dynamic, dynamic> testSpec;
  final String? Function(String value) resultValue;
  final String? initialValue;

  const MedtestView({Key? key, required this.testSpec, required this.resultValue, this.initialValue, }) : super(key: key);

  @override
  _MedtestViewState createState() => _MedtestViewState();
}

class _MedtestViewState extends State<MedtestView> {
  late TextEditingController _medtestsValueController1, _medtestsValueController2;
  int nInputs = 1;
  String selUnit = '';

  @override
  void initState() {
    super.initState();
    _medtestsValueController1 = TextEditingController();
    _medtestsValueController2 = TextEditingController();
    if (widget.initialValue != null) {
      String vals = widget.initialValue!;
      int idx = widget.initialValue!.lastIndexOf(' ');
      if (idx != -1) {
        selUnit = widget.initialValue!.substring(idx + 1);
        vals = widget.initialValue!.substring(0, idx);
      }
      idx = vals.indexOf('/');
      if (idx != -1) {
        _medtestsValueController1.text = vals.substring(0, idx);
        _medtestsValueController2.text = vals.substring(idx + 1);
      } else {
        _medtestsValueController1.text = vals;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      getUnits(), getInputFields(),
    ],);
  }

  Widget getInputFields() {
    String s = widget.testSpec['testranges'][0]['v1'];
    bool multiVal = s.contains("-");
    List<Widget> widgets = [];
    widgets.add(Expanded(child: TextFormField(
      controller: _medtestsValueController1,
      decoration: const InputDecoration(
          labelText: 'Test result', filled: false, fillColor: Colors.purple,
          suffixIcon: Icon(
            Icons.fact_check_outlined,
          )
      ),
      maxLines: 2,
      onSaved: (String? value) { onSaved('', 1); }
    )));
    if (multiVal) {
      nInputs = 2;
      widgets.add(Expanded(child: TextFormField(
        controller: _medtestsValueController2,
        decoration: const InputDecoration(
            labelText: 'Test result 2nd value', filled: false, fillColor: Colors.purple,
            suffixIcon: Icon(
              Icons.fact_check_outlined,
            )
        ),
        maxLines: 2,
        onSaved: (String? value) { onSaved('', 2); }
      )));
    }
    return Row(children: widgets);
  }

  Widget getUnits() {
    int n = widget.testSpec['units'].length;
    List<DropdownMenuItem<String>> units = [];
    for (int i=0;i<n;i++) {
      units.add(
          DropdownMenuItem(value: widget.testSpec['units'][i],
              child: Text(widget.testSpec['units'][i])),
          );
    }
    return DropdownButtonFormField(
      value: selUnit.isNotEmpty ? selUnit : units[0].value,
      onChanged: (String? value) {
        if (value != null) {
          selUnit = value;
        }
      },
      items: units,
      onSaved: (String? value) {
        if (value != null) {
          selUnit = value;
        }
      },
    );
  }

  FormFieldSetter<String>? onSaved(String newValue, int idx) {
    if (idx == nInputs) {
      String res = _medtestsValueController1.text;
      if (nInputs > 1) {
        res += "/" + _medtestsValueController2.text;
      }
      widget.resultValue('$res $selUnit');
    }
    return null;
  }
}
