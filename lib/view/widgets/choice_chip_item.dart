import 'package:flutter/material.dart';

class ChoiceChipItem extends StatefulWidget {
  const ChoiceChipItem({required Key this.wkey, required this.thumbnail,
    required this.title,
    this.subtitle1 = '',
    this.subtitle2 = '', this.onSelected}) : super(key: wkey);

  final Widget thumbnail;
  final String title;
  final String subtitle1;
  final String subtitle2;
  final Key wkey;
  final ValueChanged<bool>? onSelected;

  @override
  State<ChoiceChipItem> createState() => _ChoiceChipItemState();
}

class _ChoiceChipItemState extends State<ChoiceChipItem> {
  bool wselected = false;
  static Key selkey = const Key('');

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.title, style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
      avatar: widget.thumbnail,
      onSelected: (bool selected) {
        setState(() {
          wselected = !wselected;
          selkey = widget.wkey;
          if (widget.onSelected != null) {
            widget.onSelected!(wselected);
          }
        });
      },
      selected: selkey == widget.wkey,
      selectedColor: Theme.of(context).colorScheme.primary,
    );
  }
}
