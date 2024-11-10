import 'package:dream_tech_flutter/model/DreamModel.dart';
import 'package:dream_tech_flutter/service/NavigationService.dart';
import 'package:dream_tech_flutter/service/commonService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonComponents/TextConstraints.dart';
import '../../service/APIService.dart';

class DreamDiaryViewModel extends GetxController {
  final Rx<DreamModel> dreamModel;
  final APIService apiService = APIService.instance;
  CommonService commonService = CommonService();
  NavigationService navigationService = NavigationService();

  DreamDiaryViewModel(DreamModel dreamModel) : dreamModel = dreamModel.obs;

  void saveData(BuildContext context) {
    commonService.saveData(context, dreamModel.value);
    navigationService.navigateToHome(context);
  }
  void updateData(int id,BuildContext context) async{
    final updatedData = {
      'title': dreamModel.value.title,
      'content': dreamModel.value.content.join('\n'),
      'dream_type': dreamModel.value.type,
      'quality': dreamModel.value.quality,
      'sleep_time': dreamModel.value.sleepTime,
      'gpt_response':dreamModel.value.gptContent,
      'image_url' : dreamModel.value.dreamImageURL
    };
    print(updatedData['content']);
    apiService.updateDream(id, updatedData);
    try {
      await apiService.updateDream(id, updatedData);

      print('Dream update successfully');
      navigationService.navigateToHome(context);
    } catch (e) {
      print('Error update dream Diary: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TextConstraints.errorPostDream)),
      );
    }
  }

  void updateDreamContent(String newContent) {
    dreamModel.update((dream) {
      if (dream != null) {
        dream.gptContent = newContent;
      }
    });
  }
}