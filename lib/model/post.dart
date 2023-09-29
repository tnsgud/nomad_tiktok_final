import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String content, emoji;
  DateTime createTime;

  Post({
    this.id,
    required this.content,
    required this.emoji,
    required this.createTime,
  });

  Post.formJSON(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        emoji = json['emoji'],
        createTime = (json['createTime'] as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    return {'content': content, 'emoji': emoji, 'createTime': createTime};
  }
}
