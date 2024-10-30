import 'package:flutter/material.dart';
import 'package:flutter_html_2/flutter_html_2.dart';

import '../util/widget_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// not in use, contact details provided as a dialog from a sub-menu in main.dart
class ContactView extends StatelessWidget {
  ContactView({Key? key}) : super(key: key);
  String contactData = 'Thank you for your interest in Healthesy. '
      'Your feedback is important to us. The simplest way at the moment '
      'to get in touch with us by e-mail. Please email us at: lifestyle@healthesy.com.<br>';
  final String es_contactData = 'Gracias por su interés en <b>Healthesy</b>. '
      'Su opinión es importante para nosotros. <br>La forma más sencilla en este momento '
      'para ponerse en contacto con nosotros es por correo electrónico. <br>Envíenos un correo electrónico a: <i>lifestyle@healthesy.com</i>.<br>';
  final String fr_contactData = 'Merci de votre intérêt pour <b>Healthesy</b>. '
      'Votre avis est important pour nous. <br>Le moyen le plus simple pour le moment '
      'pour entrer en contact avec nous est par e-mail. <br>Veuillez nous envoyer un e-mail à: <i>lifestyle@healthesy.com</i>.<br>';


  @override
  Widget build(BuildContext context) {
    List<Widget> widgets2 = [];
    Locale userLocale = Localizations.localeOf(context);
    String languageCode = userLocale.languageCode;
    if (languageCode == 'es') {
      contactData = es_contactData;
    } else if (languageCode == 'fr') {
      contactData = fr_contactData;
    }
    widgets2.add(Html(data: contactData));
    String contactHealthesy = "${AppLocalizations.of(context)!.contact} Healthesy";
    return Scaffold(
        appBar: AppBar(title: Text(contactHealthesy)),
        body:
        customList(padding: 10.0, children: widgets2));
  }
}
