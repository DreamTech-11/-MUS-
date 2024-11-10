import 'package:dream_tech_flutter/components/DreamDiaryScreen/dreamDiaryViewModel.dart';
import 'package:dream_tech_flutter/model/DreamModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../components/DescriptionScreen/descriptioinViewModel.dart';
import '../components/DescriptionScreen/descriptionScreen.dart';
import '../components/DreamDiaryScreen/dreamDiaryScreen.dart';
import '../components/HomeScreen/HomeScreen.dart';
import '../components/LoadingScreen/loadingScreen.dart';

class NavigationService {
  void navigateToDreamDiary(BuildContext context,DreamModel dreamModel,int id) {
    Get.delete<DreamDiaryViewModel>();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DreamDiaryScreen(
                dreamModel:dreamModel,
              id: id,
            )
        )
    );
  }

  void navigateToDreamDiaryNoStack(BuildContext context,DreamModel dreamModel) {
    Get.delete<DreamDiaryViewModel>();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DreamDiaryScreen(dreamModel:dreamModel)
        )
    );
  }

  void navigateToDescription(BuildContext context) {
    Get.delete<DescriptionViewModel>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DescriptionScreen(),
      ),
    );
  }

  void navigateToLoading(BuildContext context,DreamModel dreamModel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoadingScreen(dreamModel: dreamModel)
        )
    );
  }

  void navigateToHome(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen()
        )
    );
  }
  
  void navigateToLogin(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}