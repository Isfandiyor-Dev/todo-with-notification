import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String id;
  String title;
  String description;
  bool isCompleted;
  Timestamp timestamp;

  Todo(
    this.id,
    this.title,
    this.description,
    this.isCompleted,
    this.timestamp,
  );

  factory Todo.fromJson(QueryDocumentSnapshot query) {
    return Todo(
      query.id,
      query["title"],
      query["description"],
      query["isCompleted"],
      query["timestamp"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isCompleted": isCompleted,
      "timestamp": timestamp,
    };
  }
}
