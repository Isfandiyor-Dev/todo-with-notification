import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notifications_lesson/models/todo.dart';
import 'package:notifications_lesson/services/local_notifications_serives.dart';

class TodoFirebaseService {
  final _todoCollection = FirebaseFirestore.instance.collection("todos");

  Stream<QuerySnapshot> getTodo() {
    return _todoCollection.snapshots();
  }

  Future<void> editProduct(Todo todo) async {
    await _todoCollection.doc(todo.id).update(todo.toJson());
  }

  Future<void> deleteTodo(String id) async {
    await _todoCollection.doc(id).delete();
  }

  Future<void> addTodo(
      String title, String description, Timestamp timestamp) async {
    await _todoCollection.add({
      "title": title,
      "description": description,
      "isCompleted": false,
      "timestamp": Timestamp.fromDate(timestamp.toDate()),
    });

    LocalNotificationService.requestPermissions();
    LocalNotificationService.scheduleNotification(
      title: title,
      body: description,
      scheduledDate: timestamp.toDate(),
    );
  }

  Future<void> toggleCheck(Todo todo) async {
    await _todoCollection.doc(todo.id).update(todo.toJson());
  }
}
