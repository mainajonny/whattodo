import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../const/constants.dart';
import '../data/fire_store.dart';
import '../model/notes_model.dart';
import '../screen/add_note_screen.dart';
import 'controllers/note_controller.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget(this.note, {super.key});

  final Note note;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  var notes = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    bool isDone = widget.note.isDone;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        onTap: () {
          notes.isEdit(true);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddScreen(note: widget.note),
            ),
          );
        },
        leading: img(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.note.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Checkbox(
              activeColor: customMustard,
              value: isDone,
              onChanged: (value) {
                setState(() => isDone = !isDone);
                FirestoreDatasource().isdone(widget.note.id, isDone).whenComplete(
                  () {
                    Fluttertoast.showToast(
                      msg:
                          'Task marked as ${isDone ? 'Complete' : 'Incomplete'}',
                    );
                  },
                );
              },
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.subtitle,
              style: TextStyle(fontSize: 15, color: Colors.blueGrey),
            ),
            editTime(),
          ],
        ),
      ),
    );
  }

  Widget editTime() {
    String priority = widget.note.priority;

    Color? kColor;
    switch (priority) {
      case 'low':
        kColor = Colors.green;
      case 'medium':
        kColor = Colors.orange;
      case 'high':
        kColor = customRed(1);
      default:
        kColor = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(text: 'Due on: '),
                TextSpan(
                  text: '${getDateFormat(widget.note.due)}\n',
                  style: TextStyle(color: customMustard),
                ),
                TextSpan(text: 'Priority: '),
                TextSpan(text: priority, style: TextStyle(color: kColor)),
              ],
            ),
          ),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  notes.isEdit(true);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddScreen(note: widget.note),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(225, 173, 1, 0.2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit_document, size: 15),
                        SizedBox(width: 5),
                        Text(
                          'edit',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Visibility(
                visible: widget.note.isDone,
                child: GestureDetector(
                  onTap:
                      () => FirestoreDatasource()
                          .deleteNote(widget.note.id)
                          .whenComplete(
                            () => Fluttertoast.showToast(
                              msg: '${widget.note.title} deleted successfully!',
                            ),
                          ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: customRed(0.2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.delete, size: 15, color: customRed(1)),
                          SizedBox(width: 5),
                          Text(
                            'delete',
                            style: TextStyle(
                              fontSize: 12,
                              color: customRed(1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget img() {
    return Image.asset(
      'images/${widget.note.image}.png',
      fit: BoxFit.cover,
      height: 100,
      width: 70,
    );
  }
}
