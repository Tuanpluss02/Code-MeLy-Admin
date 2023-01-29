import 'package:get/get.dart';

class LoadingControl extends GetxController {
  final _loading = false.obs;
  set loading(bool value) => _loading.value = value;
  bool get loading => _loading.value;
}
