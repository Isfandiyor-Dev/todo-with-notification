import 'package:flutter/material.dart';
import 'package:notifications_lesson/views/screens/pomodoro_page.dart';
import 'package:notifications_lesson/views/screens/todo_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> pages = [
    const TodoScreen(),
    const PomodoroPage(),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        toolbarHeight: 90,
        title: Text(
          "UpTodo",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        child: GNav(
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.lightGreen.shade900,
          gap: 8,
          iconSize: 30,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          onTabChange: (value) {
            currentPage = value;
            setState(() {});
          },
          tabs: const [
            GButton(
              icon: Icons.task_alt_rounded,
              text: "Todo",
            ),
            GButton(
              icon: Icons.timer,
              text: "Pomodoro",
            )
          ],
        ),
      ),
      body: pages[currentPage],
    );
  }
}
// if (!LocalNotificationsSerive.notificationsEnabled)
//   const Text(
//     "Siz xabarnomaga ruxsat bermadingiz shu sabab sizga xabarnomalar kemaydi",
//     textAlign: TextAlign.center,
//   ),
// FilledButton.tonal(
//   onPressed: () {
//     LocalNotificationsSerive.showNotification();
//   },
//   child: const Text("Notification"),
// ),
