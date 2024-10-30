import 'package:flutter/material.dart';

// Card itemCard({required Item item, bgcolor: Colors.white, VoidCallback? callback}) {
//   return Card(color: bgcolor,child: ListTile(
//     title: Text(item.name, softWrap: true,style: appTheme.textTheme.bodyText1),
//     subtitle: Text(item.unitprice.toStringAsFixed(2)),
//     trailing: TextButton(onPressed: callback,
//       child: const Text('X'),),));
// }

/// use showMessage to get the SnackBar to display
SnackBar warning(String message, SnackBarAction? action) {
  if (action == null) {
    return SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 1500),
    );
  } else {
    return SnackBar(
      content: Text(message),
      duration: const Duration(milliseconds: 5000),
      action: action
    );
  }
}

simpleDlg(String message) {
  return AlertDialog(
    content: Text(message),
  );
}

/// returns a dialog with the given title and message, and an ok and cancel button
getAlertDlg(context, String title, String message) {
  return AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: <Widget>[
      TextButton(
        onPressed: () => Navigator.pop(context, 'Cancel'),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, 'OK'),
        child: const Text('OK'),
      ),
    ],
  );
}

/// shows a dialog with the given title and message, and an ok and cancel button
Future<String?> showDlgOkCancel(context, String title, String message) {
  return showDialog<String>(
      context: context,
      builder: (BuildContext context) => getAlertDlg(context, title, message)
  );
}

showCalendar({required BuildContext context, required DateTime firstDate,
  required DateTime lastDate, required DateTime initialDate, void Function(DateTime)? onSelected}) {

  return showDatePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDate: initialDate,
  ).then((value) => {
    if (value != null) {
      onSelected!(value)
    }
  });
}

customList({required List<Widget> children, double padding  = 20.0}) {
  return CustomScrollView(
      shrinkWrap: true,
      slivers:[
  SliverPadding(
  padding: EdgeInsets.all(padding),
  sliver: SliverList(
  delegate: SliverChildListDelegate(children)))]);
}
