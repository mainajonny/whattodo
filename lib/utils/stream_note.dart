import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../const/constants.dart';
import '../data/fire_store.dart';
import 'controllers/note_controller.dart';
import 'task_widgets.dart';

class StreamNote extends StatelessWidget {
  const StreamNote(this.done, {super.key});

  final bool done;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    List<dynamic> searchResults = [];

    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreDatasource().stream(done),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong..');
        }

        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: customMustard),
                  SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    'Fetching your tasks\nPlease wait...',
                  ),
                ],
              ),
            ),
          );
        }

        final noteslist = FirestoreDatasource().getNotes(snapshot);

        return GetBuilder<NoteController>(
          global: true,
          init: NoteController(),
          initState: (state) {},
          builder: (notes) {
            notes.searchText.value.isEmpty
                ? notes.searchList(noteslist)
                : notes.searchList(searchResults);

            notes.notesCount(notes.searchList.length);

            return Column(
              children: [
                SizedBox(height: 20),
                Visibility(
                  visible: !done,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller,
                    textInputAction: TextInputAction.search,
                    onEditingComplete:
                        () => FocusManager.instance.primaryFocus?.unfocus(),
                    onChanged: (searchParam) {
                      notes.searchText(searchParam);

                      searchResults =
                          noteslist
                              .where(
                                (s) => s.title
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchParam.toLowerCase()),
                              )
                              .toList();

                      notes.update();
                    },
                    decoration: searchInputDecoration(
                      context,
                      'Search a task...',
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: notes.notesCount.value,
                  itemBuilder: (context, index) {
                    final note = notes.searchList[index];

                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        FirestoreDatasource()
                            .deleteNote(note.id)
                            .whenComplete(
                              () => Fluttertoast.showToast(
                                msg: '${note.title} deleted successfully!',
                              ),
                            );
                      },
                      child: TaskWidget(note),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
