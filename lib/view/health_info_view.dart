import 'package:flutter/material.dart';
import 'package:healthesy/view/wrapped_chips.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/hanlz.dart';
import '../model/health_info.dart';

class HealthInfoView extends StatefulWidget {
  const HealthInfoView({Key? key}) : super(key: key);

  @override
  _HealthInfoViewState createState() => _HealthInfoViewState();
}

class _HealthInfoViewState extends State<HealthInfoView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController heightEdController, weightEdController;
  Map<String, dynamic>? rf = {};
  /// temp store values till user submit form
  int? ht,wt;
  String? gd, ag;
  bool loadAttempted = false;

  @override
  void initState() {
    super.initState();
    heightEdController = TextEditingController();
    weightEdController = TextEditingController();
    gd = 'F';
    ag = '4';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.healthInfo)),
        body: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.topCenter,
            child: Consumer<HealthInfo>(builder: (context, healthInfo, child) {
              String rfs = '';
              if (healthInfo.result.length > 0 && healthInfo.result[0]['id'] != -1) {
                gd = healthInfo.result[0]['gender'] ?? 'F';
                ag = healthInfo.result[0]['ager'] ?? '4';
                heightEdController.text =
                healthInfo.result[0]['ht'].toString();
                weightEdController.text =
                healthInfo.result[0]['wt'].toString();
                rfs = healthInfo.result[0]['rf1'] ?? '';
              } else if (!loadAttempted) {
                healthInfo.load();
                loadAttempted = true;
                return const CircularProgressIndicator();
              }

              return Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(shrinkWrap: true,
                      //     mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: heightEdController,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.heightLabel,
                              filled: false,
                              fillColor: Colors.yellow,
                              suffixIcon: const Icon(
                                Icons.height,
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.heightMissingMsg;
                            }
                            if (value.contains('.') || value.contains(',')) {
                              return AppLocalizations.of(context)!.nodecimals;
                            }
                            return null;
                          },
                          onTap: () => {},
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: weightEdController,
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.weightLabel,
                              filled: false,
                              fillColor: Colors.yellow,
                              suffixIcon: const Icon(
                                Icons.assignment_ind_outlined,
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.weightMissingMsg;
                            }
                            if (value.contains('.')) {
                              return 'No decimals';
                            }
                            return null;
                          },
                          onTap: () => {},
                          keyboardType: TextInputType.number,
                        ),
                        DropdownButtonFormField<String>(
                          value: gd,
                          items: const [
                            DropdownMenuItem(
                              child: Text('F'),
                              value: 'F',
                            ),
                            DropdownMenuItem(
                              child: Text('M'),
                              value: 'M',
                            ),
                            DropdownMenuItem(
                              child: Text('Other'),
                              value: 'O',
                            )
                          ],
                          onChanged: (String? value) { gd = value; },
                          decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.gender,
                              helperText:
                              AppLocalizations.of(context)!.healthImpactMsg),
                        ),
                        DropdownButtonFormField<String>(
                          value: ag,
                          items: const [
                            DropdownMenuItem(
                              child: Text('0-10'),
                              value: '1',
                            ),
                            DropdownMenuItem(
                              child: Text('11-20'),
                              value: '2',
                            ),
                            DropdownMenuItem(
                              child: Text('21-30'),
                              value: '3',
                            ),
                            DropdownMenuItem(
                              child: Text('31-44'),
                              value: '4',
                            ),
                            DropdownMenuItem(
                              child: Text('45-55'),
                              value: '5',
                            ),
                            DropdownMenuItem(
                              child: Text('56-65'),
                              value: '6',
                            ),
                            DropdownMenuItem(
                              child: Text('66+'),
                              value: '7',
                            )
                          ],
                          onChanged: (String? value) { ag = value; },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.ageRange,
                          ),
                        ),
                        Container(
                          child: Text(AppLocalizations.of(context)!.healthFactors),
                          padding: const EdgeInsets.all(8.0),
                        ),
                        WrappedChips(rfs: rfs, rf: (Map<String, dynamic>? rf) {
                          this.rf = rf;
                        }),
                        const SizedBox(height: 10),
                        Consumer<Hanlz> (builder: (context, hanlz, child) {
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if (healthInfo.result.length == 0 || healthInfo.result[0]['id'] == -1) {
                                healthInfo.save(int.parse(heightEdController.text),
                                  int.parse(weightEdController.text), gd!, ag!,healthInfo.rfFromMap(rf!)).then((value) => {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.healthDataSvMsg))),
                                    hanlz.chkHInfo(healthInfo, context)
                                });
                              } else {
                                healthInfo.update(int.parse(heightEdController.text),
                                    int.parse(weightEdController.text), gd!, ag!,healthInfo.rfFromMap(rf!)).then((value) => {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.healthDataUpdMsg))),
                                    hanlz.chkHInfo(healthInfo, context)
                                });
                              }
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.updateBtn),
                        );})
                      ]));
            })));
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    heightEdController.dispose();
    weightEdController.dispose();
    super.dispose();
  }

}
