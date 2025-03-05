import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;

  var regIsLoading = false.obs;
  var regHasError = false.obs;
  var regErrorMsg = ''.obs;
}
