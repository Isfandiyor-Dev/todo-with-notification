import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notifications_lesson/services/todo_firebase_service.dart';
import 'package:notifications_lesson/models/todo.dart';

class TodoController extends ChangeNotifier {
  final TodoFirebaseService todoFirebaseService = TodoFirebaseService();

  Stream<QuerySnapshot> getTodoStream() {
    return todoFirebaseService.getTodo();
  }

  Future<void> addTodo(
      String title, String description, Timestamp timestamp) async {
    await todoFirebaseService.addTodo(title, description, timestamp);
    notifyListeners();
  }

  Future<void> editTodo(
       Todo todo) async {
    await todoFirebaseService.editProduct(todo);
    notifyListeners();
  }
  Future<void> toggleCheck(Todo todo) async {
    await todoFirebaseService.editProduct(todo);
    notifyListeners();
  }

  Future<void> deleteTodo(String id) async {
    await todoFirebaseService.deleteTodo(id);
    notifyListeners();
  }
}
