import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MainViewModel extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Rx<User?> _user = Rx<User?>(null);

  User? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(auth.authStateChanges());
  }
}