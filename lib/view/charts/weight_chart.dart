import 'package:community_charts_flutter/community_charts_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/weight.dart';
import '../../util/widget_util.dart';

class WeightChart extends StatefulWidget {
  final bool animate;
  Map<DateTime, String> qnotes = {};

  WeightChart({Key? key, required this.animate}) : super(key: key);

  @override
  _WeightChartState createState() => _WeightChartState();

  /// Create one series with sample hard coded data.
  List<Series<UDTimeSeries, DateTime>> _prepareData(result) {
    List<UDTimeSeries> data = [];


    int rcount = result.length;
    for (int i=0; i< rcount; i++) {
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(result[i]['currdate']);
      data.add(UDTimeSeries(dateTime, result[i]['value'], qnote: result[i]['qnote']));
      qnotes[dateTime] = result[i]['qnote'];
    }
    return [
      Series<UDTimeSeries, DateTime>(
        id: 'uds',
        domainFn: (UDTimeSeries uds, _) => uds.time,
        measureFn: (UDTimeSeries uds, _) => uds.value,
        data: data,
        labelAccessorFn: (UDTimeSeries uds, _) {
          String? s = uds.qnote ?? '';
          return s;
          },
      )
    ];
  }
}

class _WeightChartState extends State<WeightChart> {
  List<Series<dynamic, DateTime>>? seriesList;
  DateTime? _time;
  late Map<String, num> _measures;
  final myController = TextEditingController();
  int selectedStatus = 0;
  Weight? upsDownsObj;

  @override
  Widget build(BuildContext context) {
    //If there is a selection, then include the details.
    Text note = const Text('');
    if (_time != null) {
      if (widget.qnotes[_time] != null) {
        note = Text(widget.qnotes[_time]!);
      }
    }
    List<Widget> widgets2 = [];
    widgets2.add(Consumer<Weight> (builder: (context, weights, child) {
      int rcount = weights.result.length;print('$rcount values loaded');
      upsDownsObj = weights;
      print('rcount = $rcount');
      if (rcount == 0) {
        weights.load();
        return const Center(child: Text('No data'));
      } else {
        seriesList = widget._prepareData(weights.result);
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
    widgets2.add(
        ElevatedButton(
            onPressed: () {
              context.go('/wtdata');
            },
          child: const Text('Enter weight data'),
        )
    );
    //widgets2.add(AskUpDns(onSave: save));

    return Scaffold(
        appBar: AppBar(title: const Text('Weight Chart')),
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
        //measures[datumPair.series.displayName] = datumPair.datum.sales;
      }
      setState(() {
        _time = time;
        //_measures = measures;
      });
    }

  }

  // void save(int selectedStatus) {
  //   // Consumer<UpsDowns> (builder: (context, upsdowns, child)
  //   // {
  //   upsDownsObj!.save(selectedStatus, myController.text).then((value) =>
  //   {
  //     if (value > 0) {
  //       alertHelper(context, 'Status recorded',
  //           'Your status has been successfully recorded'),
  //       print('status saved with value ${value}'),
  //
  //     } else
  //       {
  //         alertHelper(context, 'Status not recorded',
  //             'Something is not right, your status was not recorded')
  //       }
  //   });
  //   //   return const Text('');
  //   // });
  // }
}

/// Sample time series data type.
class UDTimeSeries {
  final DateTime time;
  final double value;
  String? qnote;

  UDTimeSeries(this.time, this.value, {this.qnote = ''}) {
    print("$time -> $value");
  }
}