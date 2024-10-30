import 'package:flutter/material.dart';
import 'package:healthesy/model/ups_downs.dart';
import 'package:provider/provider.dart';
import '../../util/widget_util.dart';
import '../widgets/ask_up_dns.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpsDownsChart extends StatefulWidget {
  final bool animate;
  Map<DateTime, String> qnotes = {};

  UpsDownsChart({Key? key, required this.animate}) : super(key: key);

  @override
  State<UpsDownsChart> createState() => _UpsDownsChartState();

  /// Create one series with sample hard coded data.
  List<Series<UDTimeSeries, DateTime>> _prepareData(result) {
    List<UDTimeSeries> data = [];


    int rcount = result.length;
    for (int i=0; i< rcount; i++) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(result[i]['currdate']);
      data.add(UDTimeSeries(dateTime, result[i]['status'], qnote: result[i]['qnote']));
      qnotes[dateTime] = result[i]['qnote'];
    }
    return [
      Series<UDTimeSeries, DateTime>(
        id: 'uds',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (UDTimeSeries uds, _) => uds.time,
        measureFn: (UDTimeSeries uds, _) => uds.value,
        data: data,
        //colorFn: (UDTimeSeries uds, _) => Color.fromHex(code: '#FFEF9A'),
        // areaColorFn: (UDTimeSeries uds, _) => Color(0xAFEF7A),
        // fillColorFn: (UDTimeSeries uds, _) => Color(0xAFEF7A),
        labelAccessorFn: (UDTimeSeries uds, _) {
          String? s = uds.qnote ?? '';
          return s;
        },
        displayName: 'UpsDowns',
      )
    ];
  }
}

class _UpsDownsChartState extends State<UpsDownsChart> {
  List<Series<dynamic, DateTime>>? seriesList;
  DateTime? _time;
  late Map<String, num> _measures;
  final myController = TextEditingController();
  int selectedStatus = 0;
  UpsDowns? upsDownsObj;

  @override
  Widget build(BuildContext context) {
    // If there is a selection, then include the details.
    Text note = const Text('');
    if (_time != null) {
      if (widget.qnotes[_time] != null) {
        note = Text(widget.qnotes[_time]!);
      }
    }
    List<Widget> widgets2 = [];
    widgets2.add(Consumer<UpsDowns> (builder: (context, upsdowns, child) {
      int rcount = upsdowns.result.length;print('$rcount values loaded');
      upsDownsObj = upsdowns;
      print('rcount = $rcount');
      if (rcount == 0) {
        upsdowns.load();
        return const Center(child: Text('No data'));
      } else {
        seriesList = widget._prepareData(upsdowns.result);
        return
          SizedBox(height: 280, child: TimeSeriesChart(seriesList!, animate: widget.animate,
            selectionModels: [
              SelectionModelConfig(
                type: SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
            behaviors: [PanAndZoomBehavior()],));}})
    );
    widgets2.add(note);
    widgets2.add(AskUpDns(onSave: save));

    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.upsDownsGraphTitle)),
        body:
        customList(padding: 10.0, children: widgets2));
  }

  _onSelectionChanged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.time;
      for (var datumPair in selectedDatum) {
        measures[datumPair.series.displayName!] = datumPair.datum.value;
      }
      setState(() {
        _time = time;
        _measures = measures;
      });
    }

  }

  void save(int selectedStatus, String note) {
    // Consumer<UpsDowns> (builder: (context, upsdowns, child)
    // {
      upsDownsObj!.save(selectedStatus, note).then((value) =>
      {
        if (value > 0) {
          showDlgOkCancel(context, 'Status recorded', 'Your status has been successfully recorded').then((value) => Navigator.maybePop(context))
        } else
          {
            showDlgOkCancel(context, 'Status not recorded', 'Something is not right, your status was not recorded').then((value) => Navigator.maybePop(context))
          }
      });
    //   return const Text('');
    // });
  }
}

/// Sample time series data type.
class UDTimeSeries {
  final DateTime time;
  final int value;
  String? qnote;

  UDTimeSeries(this.time, this.value, {this.qnote = ''}) {
    print("$time -> $value");
  }
}
