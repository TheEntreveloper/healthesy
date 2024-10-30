class MsgData {
  int? id = -1;
  int mtype, senderId;
  String title, body;


  MsgData({required this.id, required this.mtype, required this.senderId, required this.title, required this.body});

  MsgData.fromMap(Map<String, dynamic> map): this(
    id: map['id'],
    mtype: map['mtype'],
    senderId: map['senderid'],
    title: map['title'],
    body: map['body'],
  );
}