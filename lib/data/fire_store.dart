import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../model/notes_model.dart';

class FirestoreDatasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(String email) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "id": _auth.currentUser!.uid,
        "email": email,
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> addNote(
    String subtitle,
    String title,
    int image,
    String due,
    String priority,
  ) async {
    try {
      var uuid = Uuid().v4();
      DateTime date = DateTime.now();

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .set({
            'id': uuid,
            'subtitle': subtitle,
            'isDone': false,
            'image': image,
            'time': '${date.hour}:${date.minute}',
            'due': due,
            'priority': priority,
            'title': title,
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  List getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList =
          snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Note(
              data['id'],
              data['subtitle'],
              data['time'],
              data['due'],
              data['priority'],
              data['image'],
              data['title'],
              data['isDone'],
            );
          }).toList();
      return notesList;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Stream<QuerySnapshot> stream(bool isDone) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes')
        .where('isDone', isEqualTo: isDone)
        .snapshots();
  }

  Future<bool> isdone(String uuid, bool isDone) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({'isDone': isDone});
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateNote(
    String uuid,
    int image,
    String due,
    String priority,
    String title,
    String subtitle,
  ) async {
    try {
      DateTime date = DateTime.now();

      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({
            'time': '${date.hour}:${date.minute}',
            'due': due,
            'priority': priority,
            'subtitle': subtitle,
            'title': title,
            'image': image,
          });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteNote(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
