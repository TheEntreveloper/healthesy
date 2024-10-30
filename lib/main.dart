import 'package:flutter/material.dart';
import 'package:flutter_html_2/flutter_html_2.dart';
import 'package:go_router/go_router.dart';
import 'package:healthesy/view/charts/ups_downs_chart.dart';
import 'package:healthesy/view/charts/weight_chart.dart';
import 'package:intl/intl.dart';
import 'config/theme.dart';
import 'model/hanlz.dart';
import 'model/health_info.dart';
import 'model/messages.dart';
import 'model/msg_data.dart';
import 'model/notes.dart';
import 'model/ups_downs.dart';
import 'model/weight.dart';
import 'view/contact_view.dart';
// import 'view/charts/ups_downs_chart.dart';
// import 'view/charts/weight_chart.dart';
import 'view/ed_note.dart';
import 'view/health_info_view.dart';
import 'view/health_practitioner_view.dart';
import 'view/health_report_view.dart';
import 'view/help_view.dart';
import 'view/home.dart';
import 'view/hp_list_view.dart';
import 'view/messages_view.dart';
import 'view/new_note.dart';
import 'view/notes_view.dart';
import 'view/settings_view.dart';
import 'view/step_counter.dart';
import 'view/weight_data_form.dart';
import 'package:provider/provider.dart';

import 'config/app_cfg.dart';
import 'model/base_note.dart';
import 'model/health_practitioner.dart';
import 'model/health_practitioner_data.dart';
import 'model/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(HtsyApp());
}

class HtsyApp extends StatelessWidget {
  HtsyApp({Key? key}) : super(key: key);

  /// The title of the app.
  static String title = 'Helping You Stay Healthy';

  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false, create: (context) => Settings()),
        ChangeNotifierProvider(create: (context) => Notes()),
        ChangeNotifierProvider(create: (context) => UpsDowns()),
        ChangeNotifierProvider(create: (context) => HealthInfo()),
        ChangeNotifierProvider(create: (context) => Messages()),
        ChangeNotifierProvider(create: (context) => Hanlz()),
        ChangeNotifierProvider(create: (context) => Weight()),
        ChangeNotifierProvider(create: (context) => HealthPractitioner()),
  ],
      builder: (context, child) { return start(context); }
  );

  Widget start(context) {
    var settings = Provider.of<Settings>(context, listen: true);
    AppConfig.appSettings = settings.appSettings;
    String activeTheme = AppConfig.appSettings['theme'] ?? 'appTheme';
    switch (activeTheme) {
      case 'dark':
        appTheme = darkTheme;
        break;
      case 'light':
        appTheme = lightTheme;
        break;
      case 'sun':
        appTheme = sunTheme;
        break;
      default:
        appTheme = lightTheme;
    }
    return MaterialApp.router(
      // routeInformationParser: _router.routeInformationParser,
      // routerDelegate: _router.routerDelegate,
      routerConfig: _router,
      onGenerateTitle: (context) =>
      Intl.message(title),
      //AppLocalizations.of(context)!.appTitle,
      theme: appTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      //locale: const Locale.fromSubtags(languageCode: 'fr'),
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: "/",
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(child: HtsyHome());
        },
        routes: [  // sub-route, so the back button shows
          GoRoute(
            path: 'settings', // no leading '/' but include when calling this route
            builder: (BuildContext context, GoRouterState state) =>
            const SettingsView(),
          ),
          GoRoute(
            path: 'udchart',
            builder: (BuildContext context, GoRouterState state) =>
            UpsDownsChart(animate: true),
          ),
          GoRoute(
            path: 'weights',
            builder: (BuildContext context, GoRouterState state) =>
                WeightChart(animate: true),
          ),
          GoRoute(
            path: 'wtdata',
            builder: (BuildContext context, GoRouterState state) =>
                const WeightDataForm(),
          ),
          GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) =>
            const Home(),
            routes: [

            ]
          ),
          GoRoute(
            name: 'hinfo',
            path: 'hinfo', // no leading '/' but include when calling this route
            builder: (BuildContext context, GoRouterState state) =>
            const HealthInfoView(),
          ),
          GoRoute(
            name: 'hps',
            path: 'hps', // no leading '/' but include when calling this route
            builder: (BuildContext context, GoRouterState state) =>
            const HpListView(),
              routes: [
                GoRoute(
                  name: 'hpview',
                  path: 'hpview',
                  builder: (context, state) {
                    final params = state.extra! as Map<String, Object>;
                    final hpData = params['hpdata']! as HealthPractitionerData;
                    return HealthPractitionerView(healthPractitionerData: hpData);
                  },
                ),
              ]
          ),
          GoRoute(
            path: 'newnote',
            builder: (BuildContext context, GoRouterState state) =>
            const NewNote(),
          ),
          GoRoute(
            name: 'edconsnote',
            path: 'edconsnote',
            builder: (context, state) {
              final params = state.extra! as Map<String, Object>;
              final note = params['note']! as BaseNote;
              return EdNote(baseNote: note);
            },
          ),
          GoRoute(
            name: 'msgview',
            path: 'msgview',
            builder: (context, state) {
              final params = state.extra! as Map<String, Object>;
              final message = params['message']! as MsgData;
              return HealthReportView(msgData: message);
            },
          ),
          GoRoute(
            name: 'about',
            path: 'about', // no leading '/' but include when calling this route
            builder: (BuildContext context, GoRouterState state) =>
            ContactView(),
          ),
          GoRoute(
            name: 'help',
            path: 'help', // no leading '/' but include when calling this route
            builder: (BuildContext context, GoRouterState state) =>
            const HelpView(),
          ),
          GoRoute(
            name: 'steps',
            path: 'steps', // no leading '/' but include when calling this route
            builder: (BuildContext context, GoRouterState state) =>
            const StepCounter(),
          ),
        ]
      ),

      // GoRoute(
      //   path: '/settings',
      //   builder: (BuildContext context, GoRouterState state) =>
      //   const SettingsView(),
      // ),
    ],
  );
}

enum Menu { settings, about, contact }

/// The screen of the first page.
class HtsyHome extends StatefulWidget {
  /// Creates a [HtsyHome].
  const HtsyHome({Key? key}) : super(key: key);

  @override
  State<HtsyHome> createState() => _HtsyHomeState();
}

class _HtsyHomeState extends State<HtsyHome> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  TextEditingController searchFieldController = TextEditingController();
  int index = 0;
  Widget? searchField, titleWidget;
  IconData iconData = Icons.search;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: index, length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        index = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool askUDs = AppConfig.appSettings['uds'] ?? true;
    List<Widget> widgets = [];
    titleWidget = Text(HtsyApp.title);
    if (searchField != null && index == 1) {
      titleWidget = searchField;
    }
    widgets.add(Home());

    widgets.add(NotesView());
    widgets.add(MessagesView());
    Widget? searchAction;
    List<Widget>? actions = [];
    if (index == 1) {
      searchAction = IconButton(
        icon: Icon(iconData),
        tooltip: 'Filter notes',
        onPressed: () {
          // handle the press

            setState(() {
              if (searchField != null) {
                searchField = null;
                iconData = Icons.search;
              } else {
                iconData = Icons.search_off;
                searchField =
                    Consumer<Notes>(builder: (context, notes, child) {
                      return Padding(
                          padding: const EdgeInsets.only(top: 5, left: 5),
                          child: SizedBox(width: 100.0,
                              height: 20.0,
                              child: TextField(
                                controller: searchFieldController,
                                maxLength: 40,
                                onChanged: (value) =>
                                {
                                  value = '%$value%',
                                  notes.load(
                                      conds: 'rectype like ? or field1 like ?',
                                      condVals: [value, value])
                                },)));
                    });
              }
            });


        },
      );

      actions.add(searchAction);
    } else {

    }
    actions.add(popupMenuAction());

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/logo_graph_only.png', width: 30, height: 30,),
        title: titleWidget,
        elevation: 0.2,
        bottom: PreferredSize(
          preferredSize: _tabBar.preferredSize,
          child: ColoredBox(
            color: appTheme.colorScheme.secondary,
            child: _tabBar,
          ),
        ),
        actions: actions,
        backgroundColor: appTheme.colorScheme.primary,
      ),
      body: TabBarView(
        controller: _tabController,
        children: widgets,
      ),
      floatingActionButton: floatingAction(),
    );
  }

  TabBar get _tabBar => TabBar(
    controller: _tabController,
    //labelColor: TabBarTheme.of(context).labelColor,
    //indicatorColor: Colors.white,
    tabs: <Widget>[
      Tab(icon: const Icon(Icons.home), text: "Home"),
      Tab(
        icon: const Icon(Icons.notes), text: "Notes",
      ),
      Tab(
        icon: const Icon(Icons.info), text: "Info",
      ),
    ],
  );

  popupMenuAction() {
    String contactData = 'Thank you for your interest in <b>Healthesy</b>. '
        'Your feedback is important to us. <br>The simplest way at the moment '
        'to get in touch with us is by e-mail. <br>Please email us at: <i>lifestyle@healthesy.com</i>.<br>';
    const String es_contactData = 'Gracias por su interés en <b>Healthesy</b>. '
        'Su opinión es importante para nosotros. <br>La forma más sencilla en este momento '
        'para ponerse en contacto con nosotros es por correo electrónico. <br>Envíenos un correo electrónico a: <i>lifestyle@healthesy.com</i>.<br>';
    const String fr_contactData = 'Merci de votre intérêt pour <b>Healthesy</b>. '
        'Votre avis est important pour nous. <br>Le moyen le plus simple pour le moment '
        'pour entrer en contact avec nous est par e-mail. <br>Veuillez nous envoyer un e-mail à: <i>lifestyle@healthesy.com</i>.<br>';

    Locale userLocale = Localizations.localeOf(context);
    String? countryCode = userLocale.countryCode;
    String languageCode = userLocale.languageCode;
    if (languageCode == 'es') {
      contactData = es_contactData;
    } else if (languageCode == 'fr') {
      contactData = fr_contactData;
    }
    String about = 'Healthesy is about your health. Its goal is to keep people healthy for longer.'
        'It provides simple tools for anyone to keep track of, and better understand their health.<br>'
        'This App is still work in progress, and new features will be added as they become ready.'
        '<br><i>Your feedback will help us do better next time we update the App, so feel free to let us know '
        'what works and what doesn\'t</i><br>'
        'Thank you for using Healthesy!';
    if (languageCode == 'es') {
      about = "Healthesy se dedica a su salud. Su objetivo es mantener a las personas sanas durante más tiempo."
      "Proporciona herramientas simples para que cualquier persona realice un seguimiento y comprenda mejor su salud.<br>"
          "Esta aplicación todavía está en proceso y se agregarán nuevas funciones a medida que estén listas"
    "<br><i>Tus comentarios nos ayudarán a hacerlo mejor la próxima vez que actualicemos la aplicación, así que no dudes en hacérnoslo saber"
    "lo que funciona y lo que no</i><br>"
    "Gracias por usar Healthesy";
    } else if (languageCode == 'fr') {
      about = "Healthesy concerne votre santé. Son objectif est de garder les gens en bonne santé plus longtemps."
      "Il fournit des outils simples permettant à chacun de suivre et de mieux comprendre sa santé.<br>"
          "Cette application est toujours en cours de développement et de nouvelles fonctionnalités seront ajoutées au fur et à mesure qu'elles seront prêtes."
          "<br><i>Vos commentaires nous aideront à faire mieux la prochaine fois que nous mettrons à jour l'application, alors n'hésitez pas à nous le faire savoir "
    "ce qui marche et ce qui ne marche pas</i><br>"
    "Merci d'avoir utilisé Healthesy";
    }
    return PopupMenuButton<Menu>(
        onSelected: (Menu item) {
          switch (item) {
            case Menu.settings:
              context.go('/settings');
              break;
            case Menu.about:
              showAboutDialog(context: context, applicationName: 'Healthesy',
              children: [Html(data: about
                  )],
              //applicationIcon: ImageIcon(Image('assets/images/ic_launcher.png')
              );
              break;
            case Menu.contact:
              String contactHealthesy = "${AppLocalizations.of(context)!.contact} Healthesy";
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                  AlertDialog(title: Text(contactHealthesy),
                  content: Html(data: contactData),
                actions: <Widget>[
                  // TextButton(
                  //   onPressed: () => Navigator.pop(context, 'Cancel'),
                  //   child: const Text('Cancel'),
                  // ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ));
              break;
          }
        },
        icon: const Icon(Icons.more_vert),
        itemBuilder: (BuildContext context) =>
        <PopupMenuEntry<Menu>>[
          PopupMenuItem<Menu>(
            value: Menu.settings,
            child: Text(AppLocalizations.of(context)!.settings),
          ),
          PopupMenuItem<Menu>(
            value: Menu.about,
            child: Text(AppLocalizations.of(context)!.about),
          ),
          PopupMenuItem<Menu>(
            value: Menu.contact,
            child: Text(AppLocalizations.of(context)!.contact),
          ),
        ]);
  }

  floatingAction() {
    HtsyApp.title = 'Healthesy';
    if (index != 1) return null;
    HtsyApp.title = AppLocalizations.of(context)!.yourHealthNotes;
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: () => context.go('/newnote'),
      tooltip: AppLocalizations.of(context)!.addNoteTip,
      child: const Icon(
        Icons.add_comment,
        color: Colors.white,
      ),
    );
  }
}

