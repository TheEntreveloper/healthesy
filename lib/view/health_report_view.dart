import 'package:flutter/material.dart';
import 'package:flutter_html_2/flutter_html_2.dart';

import '../model/msg_data.dart';
import '../util/widget_util.dart';

class HealthReportView extends StatefulWidget {
  final MsgData msgData;

  const HealthReportView({Key? key, required this.msgData}) : super(key: key);

  @override
  _HealthReportViewState createState() => _HealthReportViewState();
}

class _HealthReportViewState extends State<HealthReportView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets2 = [];
    widgets2.add(Text(widget.msgData.title, textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),));
    widgets2.add(Html(data: widget.msgData.body));
    return Scaffold(
        appBar: AppBar(title: Text(widget.msgData.title)),
        body:
        customList(padding: 10.0, children: widgets2));
  }
}
