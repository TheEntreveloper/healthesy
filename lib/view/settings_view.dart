import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../config/theme.dart';
import '../model/settings.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    var settings = Provider.of<Settings>(context, listen: true);
    List<Widget> entries = [];
    showThemes(entries,settings);
    entries.add(Container(
      constraints: const BoxConstraints.expand(height: 2.0,),
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
    ));
    entries.add(Divider(
      //height: 2.0,
      thickness: 1.0,
      color: Theme.of(context).highlightColor,
    ));
    //entries.add(showUpDn(settings));

    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              leading: getLeading(),
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: 80.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('App Settings'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
                child: Center(
                  child: Text('Make it yours',
                      style: appTheme.textTheme.titleMedium),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(
                    color: Theme.of(context).dialogBackgroundColor,
                    height: 30.0,
                    child: Center(
                      child: entries[index],
                    ),
                  );
                },
                childCount: entries.length,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50,
            color: appTheme.colorScheme.primary,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton(
                      child: const Text('Go back'),
                      onPressed: () {
                        context.go('/');
                      })
                ],
              ),
            ),
          ),
        ));
  }

  Widget? getLeading() {
    //Navigator.of(context).canPop()
    bool canPop = Navigator.of(context).canPop();
    return canPop ? BackButton() : null;
  }

  showThemes(List<Widget> entries, settings) {
    TextStyle style = TextStyle(
           fontSize: 14,
           fontWeight: FontWeight.bold,
           foreground: Paint()
             ..shader = ui.Gradient.linear(
               const Offset(0, 20),
               const Offset(150, 20),
               <Color>[
                 Colors.red,
                 appTheme.shadowColor,
               ],
             )
         );
    //style;
    entries.add(
        Text('Choose Theme: ', style: style.apply(fontSizeFactor: 2.0)));
    entries.add(
        Row(children: [
          Radio<String>(
            value: 'dark',
            groupValue: settings.appSettings['theme'],
            onChanged: (String? value) {
              setState(() {
                settings.updateSetting('theme', value);
                //settings['theme'] = value;
              });
            },
          ),
          Text('Dark', softWrap: true, style: style),
        ]));
    entries.add(
        Row(children: [
          Radio<String>(
            value: 'light',
            groupValue: settings.appSettings['theme'],
            onChanged: (String? value) {
              setState(() {
                settings.updateSetting('theme', value);
              });
            },
          ),
          Text('Light', softWrap: true, style: style),
        ]));
    entries.add(
        Row(children: [
          Radio<String>(
            value: 'sun',
            groupValue: settings.appSettings['theme'],
            onChanged: (String? value) {
              setState(() {
                settings.updateSetting('theme', value);
              });
            },
          ),
          Text('Sun', softWrap: true, style: style),
        ]));
  }

  showUpDn(settings) {
    bool value = settings.appSettings['uds'] ?? true;
    return Row(children:[Expanded(
        child: ListTile(dense: true, leading: Switch(value: value, onChanged: (value) => {
      setState(() {
        settings.updateSetting('uds', value);
      })
    },
        ), title: const Text('Ask for Ups & Downs'),))]);
  }
}
