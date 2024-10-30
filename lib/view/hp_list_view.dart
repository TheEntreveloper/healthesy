import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/health_practitioner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/health_practitioner_data.dart';

class HpListView extends StatefulWidget {
  const HpListView({Key? key}) : super(key: key);

  @override
  State<HpListView> createState() => _HpListViewState();
}

class _HpListViewState extends State<HpListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.medicalServices)),
        body:  Container(
        alignment: Alignment.topCenter,
        child: Consumer<HealthPractitioner>(builder: (context, practitioners, child) {
          int hpCount = practitioners.result.length;
          if (hpCount > 0) {
            return CustomScrollView(slivers: <Widget>[
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (index.isOdd) {
                        return const Divider(
                          height: 2,
                          color: Colors.black12,
                          thickness: 2,
                        );
                      }
                      int reIdx = index ~/ 2;
                      final hpRecord = practitioners.result[reIdx];
                      DateTime date = DateTime.fromMillisecondsSinceEpoch(
                          hpRecord['regdate']);
                      String dateOnly =
                      MaterialLocalizations.of(context).formatCompactDate(date);
                      String titlePart = hpRecord['hp'];
                      if (titlePart.length > 50) {
                        titlePart = '${titlePart.substring(0, 47)}...';
                      }

                      return Dismissible(
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                          key: Key(hpRecord["id"].toString()),
                          // Provide a function that tells the app
                          // what to do after an item has been swiped away.
                          onDismissed: (direction) {
                            // Remove the item from the data source.
                            hpDelete(practitioners, hpRecord["id"], reIdx);

                            // Then show a snackbar.
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Practitioner deleted')));
                          },
                          // Show a red background as the item is swiped away.
                          background: Container(
                              color: Colors.red,
                              child: const Text('Practitioner will be deleted')),
                          child: ListTile(
                            // leading:
                            // Text('${MessageType.values[hpRecord['mtype']].name}'),
                            title: Text(titlePart),
                            subtitle: Text(dateOnly),
                            onTap: () => {
                              viewHP(HealthPractitionerData.fromMap(hpRecord))
                            },
                          ));
                    },
                    semanticIndexCallback: (Widget widget, int localIndex) {
                      if (localIndex.isEven) {
                        return localIndex ~/ 2;
                      }
                      return null;
                    },
                    childCount: hpCount * 2,
                  ))
            ]);
          } else {
            practitioners.load();
            return const Center(child: Text('No medical services added yet', style: TextStyle(fontSize: 14.0)));
          }
        })),
      floatingActionButton: floatingAction(),
    );
  }

  viewHP(HealthPractitionerData hpData) {
    context.go('/hps/hpview', extra: {'hpdata': hpData});
  }

  hpDelete(practitioners, int id, int index) async {
    int n = await practitioners.delete(id);
    if (n > 0) {
      setState(() {
        practitioners.result.removeAt(index);
      });
    }
  }

  floatingAction() {
    HealthPractitionerData hpData = HealthPractitionerData(null, '');
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: () => context.go('/hps/hpview', extra: {'hpdata': hpData}),
      tooltip: 'Add Medical Service',
      child: const Icon(
        Icons.medical_services,
        color: Colors.white,
      ),
    );
  }
}
