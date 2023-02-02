import 'package:get/get.dart';

/// The `LoadingControl` class is a controller that has a boolean property called `loading` that can be
/// used to show or hide a loading indicator
class LoadingControl extends GetxController {
  final _loading = false.obs;
  set loading(bool value) => _loading.value = value;
  bool get loading => _loading.value;
}
