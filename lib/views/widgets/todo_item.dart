import 'package:flutter/material.dart';
import 'package:notifications_lesson/controllers/todo_controller.dart';
import 'package:notifications_lesson/models/todo.dart';
import 'package:notifications_lesson/views/widgets/add_todo_dialog.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TodoItem extends StatefulWidget {
  Todo todo;
  TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.todo.title),
      subtitle: Text(widget.todo.description),
      leading: Consumer<TodoController>(
        builder: (context, controller, child) {
          return IconButton(
            onPressed: () {
              widget.todo.isCompleted = !widget.todo.isCompleted;
              controller.toggleCheck(widget.todo);
            },
            icon: widget.todo.isCompleted
                ? const Icon(
                    Icons.task_alt_rounded,
                    size: 35,
                  )
                : const Icon(
                    Icons.circle_outlined,
                    size: 35,
                  ),
          );
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AddTodoDialog(
                  isAddDialog: false,
                  todo: widget.todo,
                ),
              );
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed: () {
              Provider.of<TodoController>(context, listen: false)
                  .deleteTodo(widget.todo.id);
            },
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
    );
  }
}
