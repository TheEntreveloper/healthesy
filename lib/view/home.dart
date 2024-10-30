import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../config/app_cfg.dart';
import '../config/theme.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int selectedStatus = 0;
  final myController = TextEditingController();
  // late Animation<Color?> animation;
  // late AnimationController controller;
  Color color1 = Colors.red, color2 = Colors.blue;
  double radian = 0.1;
  double wgMaxWidth = 0.0;

  @override
  void initState() {
    super.initState();
    // controller =
    //     AnimationController(duration: const Duration(seconds: 10), vsync: this);
    // animation = controller
    //     .drive(CurveTween(curve: Curves.easeInOutQuad))//.easeIn))
    //     .drive(ColorTween(begin: Colors.red, end: Colors.blue))
    //   ..addListener(() {
    //   // #enddocregion addListener
    //   setState(() {
    //     radian += 0.1;
    //   });
    //     // #docregion addListener
    //   });
    // // #enddocregion addListener
    // controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    int itons = AppConfig.appSettings['itons'] ?? 0;
    AppConfig.appSettings['itons'] = itons++;
    bool askUDs = AppConfig.appSettings['uds'] ?? true;

    // List<Widget> widgets = dashWidgets(askUDs);
    // List<Widget> widgets2 = [];
    // //Color c = animation.value!;
    // widgets2.add(SizedBox(
    //     height: 150,
    //     child: Row(
    //       children: widgets,
    //     )));

    return Scaffold(
        //appBar: AppBar(title: const Text('Dashboard')),
        body: Opacity(
        opacity: 1.0,
    child:LayoutBuilder(
        builder: (context, constraints) {
          var ratio = constraints.maxWidth/constraints.maxHeight;
          wgMaxWidth = constraints.maxWidth;
          return Container(
            color: appTheme.colorScheme.surface,
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: [Colors.transparent, animation.value!],
            //         tileMode: TileMode.mirror
            //         //transform: GradientRotation(radian)
            //     )),
            child:
                //customList(padding: 10.0, children: widgets2)));
                CustomScrollView(
                    shrinkWrap: false,
                    primary: false,
                    slivers: <Widget>[
                  SliverPadding(
                      padding: const EdgeInsets.all(5),
                      sliver:
                      SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 1.0,
                          crossAxisCount: 2,
                          //childAspectRatio: ratio,
                            //mainAxisExtent: 80,
                          ),
                          //mainAxisExtent: 100,
                          delegate: SliverChildListDelegate(
                              dashWidgets(askUDs, ratio)))
                  ),
                      SliverFillRemaining(
                        child: Container(),
                      ),
                ]));})));
  }

  List<Widget> dashWidgets(bool askUDs,double aspectRatio) {
    List<Widget> widgets = [];
    if (askUDs) {
      widgets.add(clickableCard(Icons.area_chart, AppLocalizations.of(context)!.upsDowns, null, '/udchart', aspectRatio));
    }
    widgets.add(clickableCard(Icons.medical_information, AppLocalizations.of(context)!.healthInfo, null, '/hinfo', aspectRatio));
    widgets.add(clickableCard(Icons.scale, AppLocalizations.of(context)!.weight, null, '/weights', aspectRatio));
    widgets.add(clickableCard(Icons.medical_services, AppLocalizations.of(context)!.medicalServices, null, '/hps', aspectRatio));
    widgets.add(clickableCard(Icons.help, AppLocalizations.of(context)!.help, null, '/help', aspectRatio));
    //widgets.add(clickableCard(Icons.help, 'Steps counter', null, '/steps'));
    //widgets.add(UpsDownsChart(animate: true));
    return widgets;
  }

  Widget clickableCard(IconData? iconData, String title, String? subtitle, String goto, double aspectRatio) {
    return GestureDetector(
      child: mkCard(iconData, title, subtitle, null, aspectRatio),
      onTap: () => {context.go(goto)},
    );
  }

  Widget mkCard(IconData? iconData, String title, String? subtitle,
      List<Widget>? btnWidgets, double aspectRatio) {
    List<Widget> widgets = [];
    double width = wgMaxWidth/2-4, height = width;//(width/aspectRatio)*2;
    widgets.add(
      Expanded(child: SizedBox(width: width, height: height, child:
        DecoratedBox(decoration: ShapeDecoration(
          color: appTheme.colorScheme.secondary,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
      ),
      // ))
      // DecoratedBox(
      //     decoration: BoxDecoration(color: const Color(0xFFc4c5c5), borderRadius: BorderRadius.circular(12)),
          child:
      Column(mainAxisAlignment: MainAxisAlignment.center,children: [
        CircleAvatar(radius: 38, backgroundColor: appTheme.colorScheme.primaryContainer, foregroundColor: appTheme.colorScheme.onPrimaryContainer,child:
        Icon(iconData, size: 36.0,),),
        Text(title, style: Theme.of(context).textTheme.displaySmall!.copyWith(color: appTheme.colorScheme.onPrimaryContainer),),
      ],))))
    //     ListTile(
    //   visualDensity: const VisualDensity(horizontal: -3),
    //   leading: iconData != null ? Icon(iconData) : null,
    //   title: Text(title, style: Theme.of(context).textTheme.headline3,),
    //   subtitle: subtitle != null ? Text(subtitle) : null,
    // )
    );
    if (btnWidgets != null) {
      widgets.add(
          Row(mainAxisAlignment: MainAxisAlignment.end, children: btnWidgets));
    }
    return Center(
      child: Card(
        shadowColor: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widgets,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    //controller.dispose();
    super.dispose();
  }

  viewInfo(int option) {}
}
