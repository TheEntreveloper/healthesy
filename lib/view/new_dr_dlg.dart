import 'package:flutter/material.dart';

newDrDlg(context, GlobalKey  _formKey, List<TextEditingController> controllers) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: const Text('Add new Doctor'),
            content: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(shrinkWrap: true,
                  //     mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  TextFormField(
                  controller: controllers[0],
                  decoration: const InputDecoration(
                      labelText: 'Dr\'s. name',
                      filled: false,
                      fillColor: Colors.yellow,
                      suffixIcon: Icon(
                        Icons.person,
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Dr\'s name';
                    }
                    return null;
                  },
                  onTap: () => {},
                ),
                TextFormField(
                  controller: controllers[1],
                  decoration: const InputDecoration(
                      labelText: 'Practice number (optional)',
                      filled: false,
                      fillColor: Colors.yellow,
                      suffixIcon: Icon(
                        Icons.info,
                      )),
                  onTap: () => {},
                ),
                ElevatedButton(
                onPressed: () {
                // if (_formKey.currentState!.validate()) {
                // _formKey.currentState!.save();
                // }
                },
                child: const Text('Update'),
                )
                  ])),
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
}