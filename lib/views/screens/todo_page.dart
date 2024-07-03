import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notifications_lesson/controllers/todo_controller.dart';
import 'package:notifications_lesson/models/todo.dart';
import 'package:notifications_lesson/views/widgets/add_todo_dialog.dart';
import 'package:notifications_lesson/views/widgets/todo_item.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AddTodoDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream:
            Provider.of<TodoController>(context).todoFirebaseService.getTodo(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error occurred"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Malumot yo'q"),
            );
          }
          final todos = snapshot.data!.docs;
          print(todos);

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (BuildContext context, int index) {
              Todo todo = Todo.fromJson(todos[index]);
              return TodoItem(todo: todo);
            },
          );
        },
      ),
    );
  }
}
