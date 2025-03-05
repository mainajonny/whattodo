import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/constants.dart';
import '../data/fire_store.dart';
import '../model/notes_model.dart';
import '../utils/controllers/note_controller.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key, this.note});

  final Note? note;

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  var notes = Get.put(NoteController());

  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  PriorityLevel _selectedPriority = PriorityLevel.low;
  DateTime now = DateTime.now();
  DateTime? dueDate;
  String? priority;
  int indexx = 0;

  @override
  void initState() {
    super.initState();
    dueDate = now;
    priority = _selectedPriority.toString().split('.').last;

    if (notes.isEdit.value) {
      dueDate = DateTime.parse(widget.note!.due);
      priority = widget.note!.priority;
      title = TextEditingController(text: widget.note!.title);
      subtitle = TextEditingController(text: widget.note!.subtitle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          '${notes.isEdit.value ? 'Edit' : "Add"} Task',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: customMustard,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              titleWidget(),
              SizedBox(height: 20),
              subtiteWidget(),
              SizedBox(height: 20),
              priorityWidget(),
              SizedBox(height: 20),
              dueDateWidget(),
              SizedBox(height: 20),
              imagesWidget(),
              SizedBox(height: 20),
              buttonWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buttonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: Size(160, 45),
          ),
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: customMustard,
            minimumSize: Size(160, 45),
          ),
          onPressed: () {
            notes.isEdit.value
                ? FirestoreDatasource().updateNote(
                  widget.note!.id,
                  indexx,
                  dueDate.toString(),
                  priority!,
                  title.text,
                  subtitle.text,
                )
                : FirestoreDatasource().addNote(
                  subtitle.text,
                  title.text,
                  indexx,
                  dueDate.toString(),
                  priority!,
                );

            Navigator.pop(context);
          },
          child: Text(
            '${notes.isEdit.value ? 'Save' : "Add"} task',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  SizedBox imagesWidget() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => setState(() => indexx = index),
            child: Padding(
              padding: EdgeInsets.only(left: index == 0 ? 7 : 0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: indexx == index ? 2 : 1,
                    color: indexx == index ? customMustard : Colors.grey,
                  ),
                ),
                width: 140,
                margin: EdgeInsets.all(8),
                child: Column(children: [Image.asset('images/$index.png')]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget titleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'title',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: customMustard, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }

  Padding subtiteWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          maxLines: 3,
          controller: subtitle,
          focusNode: _focusNode2,
          style: TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            hintText: 'subtitle',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: customMustard, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }

  Padding priorityWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Priority Level'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                PriorityLevel.values.map((PriorityLevel p) {
                  return Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Radio(
                        value: p,
                        groupValue: _selectedPriority,
                        activeColor: customMustard,
                        onChanged: (PriorityLevel? value) {
                          if (value != null) {
                            setState(() => _selectedPriority = value);
                          }
                          priority = value.toString().split('.').last;
                        },
                      ),
                      Text(
                        p.toString().split('.').last.toUpperCase(),
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Padding dueDateWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          IconButton(
            onPressed:
                () => showDatePicker(
                  context: context,
                  firstDate: now,
                  lastDate: DateTime(now.year + 1),
                  initialDate: dueDate,
                ).then((d) {
                  if (d != null) setState(() => dueDate = d);
                }),

            icon: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.calendar_month, color: customMustard),
                SizedBox(width: 10),
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(text: 'Due Date: '),
                      TextSpan(
                        text: getDateFormat(dueDate.toString()),
                        style: TextStyle(color: customRed(1)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
