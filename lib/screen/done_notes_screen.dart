import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/constants.dart';
import '../utils/controllers/note_controller.dart';
import '../utils/stream_note.dart';

class DoneNotesScreen extends StatelessWidget {
  const DoneNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var note = Get.put(NoteController());
    note.searchText('');

    return Scaffold(
      backgroundColor: backgroundColors,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text('Completed Tasks', style: TextStyle(color: Colors.white)),
        backgroundColor: customMustard,
      ),
      body: SafeArea(child: StreamNote(true)),
    );
  }
}
