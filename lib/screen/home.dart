import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../auth/auth_page.dart';
import '../const/constants.dart';
import '../data/auth_data.dart';
import '../utils/controllers/note_controller.dart';
import '../utils/stream_note.dart';
import 'add_note_screen.dart';
import 'done_notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool show = true;

class _HomeScreenState extends State<HomeScreen> {
  var notes = Get.put(NoteController());
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: backgroundColors,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
          icon: Icon(Icons.menu, color: Colors.white),
        ),
        title: Text('What To Do', style: TextStyle(color: Colors.white)),
        backgroundColor: customMustard,
      ),
      floatingActionButton: Visibility(
        visible: show,
        child: FloatingActionButton(
          onPressed: () {
            notes.isEdit(false);
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => AddScreen()));
          },
          backgroundColor: customMustard,
          child: Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      drawer: _drawer(context),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() => show = true);
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() => show = false);
            }
            return true;
          },
          child: StreamNote(false),
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      backgroundColor: customMustard,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 40),
              menuItem(Icons.add, 'Add task', () {
                notes.isEdit(false);
                scaffoldKey.currentState?.closeDrawer();
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AddScreen()));
              }),
              menuItem(Icons.done_all, 'Completed tasks', () {
                scaffoldKey.currentState?.closeDrawer();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DoneNotesScreen()),
                );
              }),
              SizedBox(height: 50),
              menuItem(Icons.logout, 'Log out', () {
                scaffoldKey.currentState?.closeDrawer();
                AuthenticationRemote().logout().whenComplete(() {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => AuthPage()),
                    (Route<dynamic> route) => false,
                  );
                });
              }),
            ],
          ),
        ),
      ),
    );
  }

  menuItem(icon, title, Function()? action) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: TextStyle(color: Colors.white)),
        onTap: action,
      ),
    );
  }
}
