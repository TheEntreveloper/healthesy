import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.thumbnail,
    required this.title,
     this.subtitle1 = '',
     this.subtitle2 = '',
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle1;
  final String subtitle2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () {

              },
              icon: thumbnail,
            )
          ),
          Expanded(
            flex: 3,
            child: _ItemContent(
              title: title,
              subtitle1: subtitle1,
              subtitle2: subtitle2,
            ),
          ),
          // const Icon(
          //   Icons.more_vert,
          //   size: 16.0,
          // ),
        ],
      ),
    );
  }
}

class _ItemContent extends StatelessWidget {
  const _ItemContent({
    Key? key,
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
  }) : super(key: key);

  final String title;
  final String subtitle1;
  final String subtitle2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getContent(),
      ),
    );
  }
// final ThemeData theme = Theme.of(context);
  _getContent() {
    List<Widget> entries = [];
    entries.add(Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      ),
    ));
    if (subtitle1.isNotEmpty) {
      entries.add(
        const Padding(padding: EdgeInsets.symmetric(vertical: 2.0))
      );
      entries.add(
        Text(
          subtitle1,
          style: const TextStyle(fontSize: 10.0),
        )
      );
    }
    if (subtitle2.isNotEmpty) {
      entries.add(const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)));
      entries.add(Text(
        subtitle2,
        style: const TextStyle(fontSize: 10.0),
      ));
    }
    return entries;
  }
}
