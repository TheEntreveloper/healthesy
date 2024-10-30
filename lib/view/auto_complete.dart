import 'package:flutter/material.dart';

class AutocompleteHelper extends StatefulWidget {
  AutocompleteHelper({Key? key, required this.itemList,
    this.decoration, this.validator, this.onSelected, this.onSaved, this.initialValue, this.multiSelect = false}) : super(key: key);

  final List<String> itemList;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final AutocompleteOnSelected<String>? onSelected;
  final FormFieldSetter<String>? onSaved;
  final String? initialValue;
  bool multiSelect = false;

  @override
  State<AutocompleteHelper> createState() => _AutocompleteHelperState();
}

class _AutocompleteHelperState extends State<AutocompleteHelper> {
  TextEditingController? controller;

  String accumVal = '';

  @override
  Widget build(BuildContext context) {
    int nlines = 1;
    if (widget.multiSelect) {
      nlines = 3;
    }
    return Autocomplete<String>(
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {

        controller = textEditingController;
        if (widget.initialValue != null) {
          controller?.text = widget.initialValue!;
        }

        return TextFormField(
          controller: textEditingController,
          decoration: widget.decoration,
          validator: widget.validator,
          focusNode: focusNode,
          minLines: nlines,
          maxLines: nlines,
          onFieldSubmitted: (String value) {
            onFieldSubmitted();
            if (widget.onSelected != null) {
              widget.onSelected!(value);
            }
          },
          onChanged: (value) {
            if (value.length < accumVal.length) {
              accumVal = value;
            }
          },
          onSaved: widget.onSaved,
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return widget.itemList.where((String option) {
          if (widget.multiSelect && textEditingValue.text.contains(",")) {
            int last = textEditingValue.text.lastIndexOf(',');
            String lastWord = textEditingValue.text.substring(last + 1).trim();
            return option.toLowerCase().contains(lastWord);
          }
          return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selection) {
        debugPrint('You just selected $selection');
        if (widget.multiSelect) {
          accumVal += selection + ", ";
          setState(() {
            controller?.text = accumVal;
            controller?.selection = TextSelection.fromPosition(
                TextPosition(offset: accumVal.length));
          });
        }
        if (widget.onSelected != null) {
          widget.onSelected!(selection);
        }
      },
      optionsMaxHeight: 300,
    );
  }
}
