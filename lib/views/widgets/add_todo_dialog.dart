import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifications_lesson/controllers/todo_controller.dart';
import 'package:notifications_lesson/models/todo.dart';
import 'package:notifications_lesson/views/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddTodoDialog extends StatefulWidget {
  bool isAddDialog;
  Todo? todo;
  AddTodoDialog({super.key, this.isAddDialog = true, this.todo});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2001),
      lastDate: DateTime(2100),
    ).then((newDateTime) {
      if (newDateTime != null) {
        selectedDate = newDateTime;
        setState(() {});
      }
    });
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: selectedTime,
    ).then((newTime) {
      if (newTime != null) {
        selectedTime = newTime;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Text(widget.isAddDialog ? "Add Todo" : "Edit Todo"),
      ),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            MyTextField(
              labelText: "Title",
              validation: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter a title";
                }
                return null;
              },
              textEditingController: titleController,
            ),
            const SizedBox(height: 20),
            MyTextField(
              labelText: "Description",
              validation: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter a description";
                }
                return null;
              },
              maxLines: 7,
              textEditingController: descriptionController,
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedDate.toString().split(" ").first,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: _showDatePicker,
                    icon: const Icon(
                      CupertinoIcons.calendar_today,
                      size: 30,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedTime.format(context).toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: _showTimePicker,
                    icon: const Icon(
                      Icons.more_time_rounded,
                      size: 30,
                      color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        const SizedBox(width: 20),
        FilledButton(
          onPressed: () {
            if (widget.isAddDialog) {
              if (formKey.currentState!.validate()) {
                Provider.of<TodoController>(context, listen: false).addTodo(
                  titleController.text,
                  descriptionController.text,
                  Timestamp(
                      selectedDate.second + (selectedTime.minute ~/ 60), 0),
                );
                Navigator.pop(context);
              }
            } else {
              if (formKey.currentState!.validate() && widget.todo != null) {
                widget.todo!.title = titleController.text;
                widget.todo!.description = descriptionController.text;
                widget.todo!.timestamp = Timestamp(
                    selectedDate.second + (selectedTime.minute ~/ 60), 0);

                Provider.of<TodoController>(context, listen: false)
                    .editTodo(widget.todo!);
                Navigator.pop(context);
              }
            }
          },
          child: Text(widget.isAddDialog ? "Add" : "Save"),
        ),
      ],
    );
  }
}
