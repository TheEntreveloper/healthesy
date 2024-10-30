import 'package:flutter/material.dart';

class DateChooser extends StatefulWidget {
  const DateChooser({Key? key}) : super(key: key);

  @override
  _DateChooserState createState() => _DateChooserState();
}

class _DateChooserState extends State<DateChooser> {
  String dt = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          ElevatedButton(
            onPressed: () {
              showDatePicker(
                context: context,
                firstDate: DateTime(2000, 1, 1),
                lastDate: DateTime(2022, 12, 31),
                initialDate: DateTime.now(),
              ).then((value) => {
                if (value != null) {
                  setState(() => dt = value.toString())
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                            Text(
                              dt,
                            ),
                            const Icon(
                              Icons.date_range,
                              size: 18.0,
                              color: Colors.teal,
                            ),
                          ],
                        ),
                      ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Theme.of(context).textTheme.bodyMedium!.backgroundColor!),
              foregroundColor: WidgetStateProperty.all<Color>(Theme.of(context).textTheme.bodyMedium!.color!),
            )), //ButtonStyle(backgroundColor: Theme.of(context).colorScheme.background),
          ]));
  }
}
