import 'package:flutter/material.dart';

import '../config/theme.dart';

class WrappedChips extends StatefulWidget {
  String rfs;
  void Function(Map<String, dynamic>? rf)? rf;

  WrappedChips({Key? key, required this.rfs, this.rf}) : super(key: key);

  @override
  _WrappedChipsState createState() => _WrappedChipsState();
}

class _WrappedChipsState extends State<WrappedChips> {
  Map<String, dynamic> rf = {
    'Alcohol regularly': false,
    'Balanced diet': false,
    'Diabetes': false,
    'Exercise regularly': false,
    'High blood pressure': false,
    'Smoking': false,
    'Stressful job or life': false
  };

  @override
  void initState() {
    super.initState();
    if (widget.rfs.isNotEmpty && widget.rfs.contains(',')) {
      print('WrappedChips. Rfs = ${widget.rfs}');
      var rfList = widget.rfs.split(',');print('rflist lg = ${rfList.length}');
      rf.forEach((key, value) { rf[key] = false; });
      for (var element in rfList) { if (element.isNotEmpty) rf[element] = true; }
      if (widget.rf != null) {
        widget.rf!(rf);
      }
    } else {
      print('rfs not set or does not contain , ${widget.rfs}');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    rf.forEach((key, value) {
      widgets.add(InputChip(
        //avatar: CircleAvatar(backgroundColor: Colors.blue.shade900),
        label: Text(key),
        onSelected: (isSelected) {
          setState(() {
          rf[key] = isSelected;
          if (widget.rf != null) {
            widget.rf!(rf);
          }
          });
        },
        selected: rf[key],
        labelStyle: appTheme.textTheme.titleMedium?.copyWith(fontSize: 14),
      ));
    });
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: widgets,
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

}
