import 'package:get/get.dart';

class NoteController extends GetxController {
  var notesCount = 0.obs;
  var isEdit = false.obs;
  var searchText = ''.obs;
  var searchList = [].obs;
}
