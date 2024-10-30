import 'package:flutter/material.dart';
import 'package:flutter_html_2/flutter_html_2.dart';

Future<String?> alertHelper(BuildContext context, String title, String message) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) =>
        AlertDialog(
          title: Text(title),
          content: Html(data: message),
          actions: _nav(context: context, showCancel: false),
        ),
  );
}

List<Widget>? _nav({required BuildContext context, required bool showCancel,
  void Function()? onPressedFn}) {
  List<Widget> btns = [];
  if (showCancel) {
    btns.add(TextButton(
      onPressed: () => Navigator.pop(context, 'Cancel'),
      child: const Text('Cancel'),
    ));
  }
  if (onPressedFn != null) {
    btns.add(TextButton(
      onPressed: () => {Navigator.pop(context, 'OK'), onPressedFn},
      child: const Text('OK'),
    ));
  } else {
    btns.add(TextButton(
      onPressed: () => Navigator.pop(context, 'OK'),
      child: const Text('OK'),
    ));
  }
  return btns;
}
