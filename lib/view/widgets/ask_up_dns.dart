import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as chmat;

import '../../util/widget_util.dart';
import 'choice_chip_item.dart';

class AskUpDns extends StatefulWidget {
  void Function(int selectedStatus, String note) onSave;

  AskUpDns({Key? key, required this.onSave}) : super(key: key);

  @override
  _AskUpDnsState createState() => _AskUpDnsState();
}

class _AskUpDnsState extends State<AskUpDns> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets2 = [];
    widgets2.addAll(askUpDns());
    return customList(padding: 10.0, children: widgets2);
  }

  List<Widget> askUpDns() {
    List<Widget> widgets = [];
    widgets.add(
        const Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child:
            Center(child: Text('How do you feel right now?',
              style: chmat.TextStyle(fontWeight: FontWeight.bold, ),))));
    widgets.add(SizedBox(height: 50, child:
    Row(
      children: [
        Expanded(child: ChoiceChipItem(
            wkey: const Key('1'),
            thumbnail: const Icon(
              Icons.thumb_up_outlined,
              size: 14.0,
            ),
            title: 'Great!',
            onSelected: (bool selected) {
              setState(() {
                widget.onSave(2, myController.text?? '');
              });
            }
        )),
        Expanded(child: ChoiceChipItem(
            wkey: const Key('2'),
            thumbnail: const Icon(
              Icons.thumb_down_outlined,
              size: 14.0,
            ),
            title: 'Not so good',
            onSelected: (bool selected) {
              setState(() {
                widget.onSave(1, myController.text?? '');
              });
            }
        )),
      ],
    )));
    widgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
        child:TextFormField(maxLines: 2,
          maxLength: 70,
          decoration: const InputDecoration(
            hintText: '(Optional) write why, before pressing a button',
          ),
          controller: myController,
        )));
    return widgets;
  }
}
