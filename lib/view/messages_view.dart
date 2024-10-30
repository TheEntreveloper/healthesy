import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/message_type.dart';
import '../model/messages.dart';
import '../model/msg_data.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({Key? key}) : super(key: key);

  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Consumer<Messages>(builder: (context, messages, child) {
          int msgCount = messages.result.length;
          if (msgCount > 0) {
            return CustomScrollView(slivers: <Widget>[
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index.isOdd) {
                    return const Divider(
                      height: 2,
                      color: Colors.black12,
                      thickness: 2,
                    );
                  }
                  int reIdx = index ~/ 2;
                  final msg = messages.result[reIdx];
                  DateTime date = DateTime.fromMillisecondsSinceEpoch(
                      msg['created']);
                  String dateOnly =
                      MaterialLocalizations.of(context).formatCompactDate(date);
                  String titlePart = msg['title'];
                  if (titlePart.length > 50) {
                    titlePart = '${titlePart.substring(0, 47)}...';
                  }

                  return Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify widgets.
                      key: Key(msg["id"].toString()),
                      // Provide a function that tells the app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        // Remove the item from the data source.
                        msgDelete(messages, msg["id"], reIdx);

                        // Then show a snackbar.
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Message deleted')));
                      },
                      // Show a red background as the item is swiped away.
                      background: Container(
                          color: Colors.red,
                          child: const Text('Message will be deleted')),
                      child: ListTile(
                        leading:
                            Text('${MessageType.values[msg['mtype']].name}'),
                        title: Text(titlePart),
                        subtitle: Text(dateOnly),
                        onTap: () => {
                          viewMsg(MsgData.fromMap(msg))
                        },
                      ));
                },
                semanticIndexCallback: (Widget widget, int localIndex) {
                  if (localIndex.isEven) {
                    return localIndex ~/ 2;
                  }
                  return null;
                },
                childCount: msgCount * 2,
              ))
            ]);
          } else {
            messages.load();
            return const Center(child: Text('No messages yet'));
          }
        }));
  }

  viewMsg(MsgData msgData) {
    context.go('/msgview', extra: {'message': msgData});
  }

  msgDelete(messages, int id, int index) async {
    int n = await messages.delete(id);
    if (n > 0) {
      setState(() {
        messages.result.removeAt(index);
      });
    }
  }
}
