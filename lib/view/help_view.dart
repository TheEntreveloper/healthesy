import 'package:flutter/material.dart';
import 'package:flutter_html_2/flutter_html_2.dart';

import '../util/widget_util.dart';

class HelpView extends StatelessWidget {
  final String helpData = ' <b>Healthesy</b> is easy to use.<br>'
      'This version does not require any sign-up/login, and '
      'does not intentionally send any personal data from your mobile device.<br>'
      'It is still work in progress and more advanced features are under development, '
      'but we hope it is a little bit useful already.<br>'
      'The App shows a tab bar with 3 tabs, and once started, lands on the <b>Home</b> tab, which provides a '
      'simple Dashboard with 5 options: Ups&Downs, Health info, Weight, Medical Services and Help.<br>'
      '<h3>Home tab >> Ups&Downs</h3><br>'
      'This helps you track your ups and downs or physical and emotional state on a '
      'given day. You can add a short comment to state what you believe is the reason.<br>'
      'Other than showing you a simple graph of your data, it does not do anything '
      'with it at the moment.<br>'
      '<i>Notice that this functionality is optional, you can disable it, if you wish, '
      'on the App Settings</i>.<br>'
      '<h3>Home tab >> Health info</h3><br>'
      'This is a form for you to enter certain relevant data, such as your height, weight, '
      'gender, age range and a selection of factors which can impact your health '
      '(smoking, diet, exercise, etc)<br>'
      'The App will use this data, in your device, to create a simple report.<br>'
      'A new report is created every time you update this form. These reports can be seen in the Comms tab.<br>'
      '<h3>Home tab >> Weight</h3><br>'
      'This is a simple weight tracker. You can enter a few weights and the matching '
      'dates in a table provided, and you can see a chart of the data. Nothing else is '
      'done with that data for now.<br>'
      '<h3>Home tab >> Medical Services</h3><br>'
      'Here you can keep records of the medical services you use or consider important (Doctors, hospitals, emergency services, etc)'
      '<h3>Home tab >> Help</h3><br>'
      'This is the most complicated option :-). You press on it, and you see this long screen '
      'telling you what you can see by yourself anyway.<br>'
      '<h3>Notes tab</h3><br>'
      'Press on the floating round button to start creating health notes, ie, '
      'personal notes about your health.<br>'
      'There are 5 kind of notes available: Consultation details, Medical condition, '
      'Stressful event, Symptoms, and Test Results.<br>'
      'Take a look at the specific fields for each and choose the most appropriate for '
      'the data you would like to record. A few of them allow you to also add an image to the '
      'note, which can be either from your Gallery or from the Camera.<br>'
      'When creating a Symptoms note (to record previous or current symptoms), a '
      'keyboard and a list of possible symptoms will display.<br> You can dismiss '
      'them by dragging up or down slightly, on an empty space to the left or right, '
      'of the note you are creating.<br>'
      'Notes you create will display on a list on the Notes tab. <br>'
      'Swipe away (left or right) on a particular note, if you wish to delete it.<br>'
      '<h3>Comms tab</h3><br>'
      'This tab is for communications sent to you. For instance, as mentioned '
      'before, reports created when you update your Health info, will show here.<br>'
      'You can swipe away individual messages that you wish to delete.<br>'
      'None of these reports or messages constitute medical advice, and do not replace your doctor.<br>'
      'You must always confirm with your doctor if it would be appropriate for you to '
      'implement, apply, or try anything you read here.<br>'
      '<h3>Settings</h3><br>'
      'You can access the Settings on the menu available at the top right of the App.<br>'
      'The Settings at the moment allow you to enable/disable the Ups & Downs functionality, '
      'as well as to switch from one ugly theme to a less ugly theme, depending on taste :-).<br>'
      'Finally, from that same menu you can access our About and Contact pages.<br>'
      'Give it a spin, and let us know what works, what does not, and what new features '
      'would make it more useful to you.<br>';

  final String es_helpData = ' <b>Healthesy</b> es fácil de usar.<br>'
      'Esta versión no requiere ningún registro/inicio de sesión, y '
      'no envía intencionalmente ningún dato personal desde su dispositivo móvil.<br>'
      'Todavía es un trabajo en progreso y se están desarrollando funciones más avanzadas,'
      'pero esperamos que ya sea un poco útil.<br>'
      'La aplicación muestra una barra de pestañas con 3 pestañas y, una vez iniciada, aterriza en la pestaña <b>Inicio</b>, que proporciona un '
      'Tablero simple con 5 opciones: Altibajos, Información de salud, Peso, Servicios médicos y Ayuda.<br>'
      '<h3>Pestaña Inicio >> Altibajos</h3><br>'
      'Esto te ayuda a registrar tus altibajos o tu estado físico y emocional en un '
      'día dado. Puede agregar un breve comentario para indicar cuál cree que es el motivo.<br>'
      'Además de mostrarle un gráfico simple de sus datos, no hace nada'
      'con él en este momento.<br>'
      '<i>Observe que esta funcionalidad es opcional, puede desactivarla, si lo desea, '
      'en la configuración de la aplicación</i>.<br>'
      '<h3>Pestaña Inicio >> Información de salud</h3><br>'
      'Este es un formulario para que ingrese ciertos datos relevantes, como su altura, peso, '
      'género, rango de edad y una selección de factores que pueden afectar su salud'
      '(fumar, dieta, ejercicio, etc.)<br>'
      'La aplicación utilizará estos datos, en su dispositivo, para crear un informe simple.<br>'
      'Se crea un nuevo informe cada vez que actualiza este formulario. Estos informes se pueden ver en la pestaña Comunicaciones.<br>'
      '<h3>Pestaña Inicio >> Peso</h3><br>'
      'Este es un simple rastreador de peso. Puede ingresar algunos pesos y el correspondiente '
      'fechas en una tabla provista, y puede ver un gráfico de los datos. Nada más es'
      'Terminé con esos datos por ahora.<br>'
      '<h3>Pestaña Inicio >> Servicios Médicos</h3><br>'
      'Aquí puede llevar registros de los servicios médicos que utiliza o considera importantes (Médicos, hospitales, servicios de emergencia, etc)'
      '<h3>pestaña Inicio >> Ayuda</h3><br>'
      'Esta es la opción más complicada :-). Presionas sobre él, y ves esta pantalla larga'
      'diciéndote lo que puedes ver por ti mismo de todos modos.<br>'
      '<h3>pestaña Notas</h3><br>'
      'Presione el botón redondo flotante para comenzar a crear notas de salud, es decir, '
      'notas personales sobre su salud.<br>'
      'Hay 5 tipos de notas disponibles: Detalles de la consulta, Condición médica, '
      'Evento estresante, síntomas y resultados de la prueba.<br>'
      'Echa un vistazo a los campos específicos de cada uno y elige el más adecuado para '
      'los datos que le gustaría registrar. Algunos de ellos le permiten agregar también una imagen al '
      'nota, que puede ser de tu galería o de la cámara.<br>'
      'Al crear una nota de Síntomas (para registrar síntomas anteriores o actuales), aparecerá el teclado y una '
      'lista de posibles síntomas.<br> Luego de seleccionar algun, puede cerrar la lista '
  'arrastrándo el cursor hacia arriba o hacia abajo ligeramente, en un espacio vacío a la izquierda o a la derecha'
  'de la nota que está creando.<br>'
  'Las notas que cree, se mostrarán en una lista en la pestaña Notas. <br>'
  'Deslice el dedo (hacia la izquierda o hacia la derecha) en una nota en particular, si desea eliminarla.<br>'
  '<h3>Pestaña de comunicaciones</h3><br>'
  'Esta pestaña es para las comunicaciones que le enviamos. Por ejemplo, como se mencionó '
  'antes, los informes creados cuando actualice su información de salud, se mostrarán aquí.<br>'
  'Puede deslizar los mensajes individuales que desea eliminar.<br>'
  'Ninguno de estos informes o mensajes constituye un consejo médico y no reemplaza a su médico.<br>'
  'Siempre debe confirmar con su médico si sería adecuado para usted'
  'implemente, aplique o pruebe cualquier cosa que lea aquí.<br>'
  '<h3>Configuración</h3><br>'
  'Puede acceder a la Configuración en el menú disponible en la parte superior derecha de la aplicación.<br>'
  'La configuración en este momento le permite habilitar/deshabilitar la funcionalidad Ups & Downs, '
  'así como cambiar de un tema feo a un tema menos feo, según el gusto :-).<br>'
  'Finalmente, desde ese mismo menú puede acceder a nuestras páginas Acerca de y Contacto.<br>'
  'Pruébelo y díganos qué funciona, qué no y qué nuevas características'
  'lo haría más útil para usted.<br>';
  final String fr_helpData = " <b>Healthesy</b> est facile à utiliser.<br>"
      "Cette version ne nécessite aucune inscription/connexion, et "
      "n'envoie intentionnellement aucune donnée personnelle depuis votre appareil mobile.<br>"
      "C'est toujours en cours de développement et des fonctionnalités plus avancées sont en cours de développement,"
  "mais nous espérons que c'est déjà un peu utile.<br>"
  "L'application affiche une barre d'onglets avec 3 onglets et, une fois démarrée, atterrit sur l'onglet <b>Accueil</b>, qui fournit un "
  "Tableau de bord simple avec 5 options : hauts et bas, informations sur la santé, poids, services médicaux et aide.<br>"
  "<h3>Onglet Accueil > Hauts et bas</h3><br>"
  "Cela vous aide à suivre vos hauts et vos bas ou votre état physique et émotionnel sur un "
  "un jour donné. Vous pouvez ajouter un court commentaire pour indiquer ce que vous pensez être la raison.<br>"
  " À part vous montrer un simple graphique de vos données, cela ne fait rien "
  "avec elle en ce moment.<br>"
  "<i>Notez que cette fonctionnalité est facultative, vous pouvez la désactiver, si vous le souhaitez, "
  "dans les paramètres de l'application</i>.<br>"
  "<h3>Onglet Accueil >> Infos santé</h3><br>"
  "Il s'agit d'un formulaire vous permettant de saisir certaines données pertinentes, telles que votre taille, votre poids, "
  "le sexe, la tranche d'âge et une sélection de facteurs qui peuvent avoir un impact sur votre santé"
  "(tabagisme, régime, exercice, etc.)<br>"
  "L'application utilisera ces données, dans votre appareil, pour créer un rapport simple.<br>"
  "Un nouveau rapport est créé chaque fois que vous mettez à jour ce formulaire. Ces rapports peuvent être consultés dans l'onglet Comms.<br>"
  "<h3>Onglet Accueil >> Poids</h3><br>"
  "Il s'agit d'un suivi de poids simple. Vous pouvez entrer quelques poids et la correspondance"
  "dates dans un tableau fourni, et vous pouvez voir un graphique des données. Rien d'autre n'est "
  "Fini avec ces données pour l'instant.<br>"
  "<h3>Onglet Accueil >> Services médicaux</h3><br>"
  "Ici, vous pouvez enregistrer les services médicaux que vous utilisez ou que vous considérez comme importants (médecins, hôpitaux, services d'urgence, etc.)"
  "<h3> Onglet Accueil >> Aide</h3><br>"
  "C'est l'option la plus compliquée :-). Vous appuyez dessus, et vous voyez ce long écran "
  "vous dire ce que vous pouvez voir par vous-même de toute façon.<br>"
  "<h3>Onglet Notes</h3><br>"
  "Appuyez sur le bouton rond flottant pour commencer à créer des notes de santé, c'est-à-dire "
  "des notes personnelles sur votre santé.<br>"
  "Il y a 5 types de notes disponibles: détails de la consultation, état de santé, "
  "Événement stressant, symptômes et résultats de test.<br>"
  "Regardez les champs spécifiques pour chacun et choisissez le plus approprié pour "
  "les données que vous souhaitez enregistrer. Certaines d'entre elles vous permettent également d'ajouter une image au "
  "note, qui peut provenir de votre galerie ou de l'appareil photo.<br>"
  "Lors de la création d'une note Symptômes (pour enregistrer les symptômes précédents ou actuels), un "
  "le clavier et une liste des symptômes possibles s'afficheront.<br> Vous pouvez ignorer "
  "les en faisant glisser légèrement vers le haut ou vers le bas, sur un espace vide à gauche ou à droite, "
  "de la note que vous créez.<br>"
  "Les notes que vous créez s'afficheront dans une liste dans l'onglet Notes. <br>"
  "Balayer (gauche ou droite) sur une note particulière, si vous souhaitez la supprimer.<br>"
  "<h3>Onglet Communications</h3><br>"
  "Cet onglet est pour les communications qui vous sont envoyées. Par exemple, comme mentionné "
  "Avant, les rapports créés lorsque vous mettez à jour vos informations de santé s'afficheront ici.<br>"
  "Vous pouvez balayer les messages individuels que vous souhaitez supprimer.<br>"
  "Aucun de ces rapports ou messages ne constitue un avis médical, et ne remplace en aucun cas votre médecin.<br>"
  "Vous devez toujours confirmer avec votre médecin s'il serait approprié pour vous de "
  "implémentez, appliquez ou essayez tout ce que vous lisez ici.<br>"
  "<h3>Paramètres</h3><br>"
  "Vous pouvez accéder aux paramètres dans le menu disponible en haut à droite de l'application.<br>"
  "Les paramètres vous permettent actuellement d'activer/désactiver la fonctionnalité Ups & Downs, "
  "ainsi que de passer d'un thème moche à un thème moins moche, selon les goûts :-).<br>"
  "Enfin, à partir de ce même menu, vous pouvez accéder à nos pages À propos et Contact.<br>"
  "Essayez-le et faites-nous savoir ce qui fonctionne, ce qui ne fonctionne pas et quelles nouvelles fonctionnalités"
  "le rendrait plus utile pour vous.<br>";

  const HelpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets2 = [];
    String data = helpData;
    Locale userLocale = Localizations.localeOf(context);
    String languageCode = userLocale.languageCode;
    if (languageCode == 'es') {
      data = es_helpData;
    } else if (languageCode == 'fr') {
      data = fr_helpData;
    }
    widgets2.add(Html(data: data));
    return Scaffold(
        appBar: AppBar(title: const Text("Healthesy Help")),
        body:
        customList(padding: 10.0, children: widgets2));
  }
}
