import 'package:dream_tech_flutter/service/NavigationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingViewModel extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final NavigationService _navigationService = NavigationService();

  Future navigateContactForm() async {
    final Uri url = Uri.parse('https://forms.gle/cxv1KjYLSfPPH1ot6');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> signOut(BuildContext context) async {
    try{
      debugPrint('SettingViewModel Attempting to sign out...');
      await auth.signOut();
      debugPrint('SettingViewModel Sign out successful');

      _navigationService.navigateToLogin(context);
    } catch (e) {
      debugPrint('SettingViewModel Error during sign out: $e');
      rethrow;
    }
  }
}