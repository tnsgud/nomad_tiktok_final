import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String content, emoji, color;
  DateTime createTime;

  Post({
    this.id,
    required this.content,
    required this.emoji,
    required this.color,
    required this.createTime,
  });

  Post.formJSON(Map<String, dynamic> json)
      : id = json['id'],
        content = json['content'],
        emoji = json['emoji'],
        color = json['color'],
        createTime = (json['createTime'] as Timestamp).toDate();

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'emoji': emoji,
      'color': color,
      'createTime': createTime
    };
  }
}
