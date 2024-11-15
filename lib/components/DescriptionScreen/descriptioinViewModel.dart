import 'package:dream_tech_flutter/model/DreamModel.dart';
import 'package:dream_tech_flutter/service/APIService.dart';
import 'package:dream_tech_flutter/service/NavigationService.dart';
import 'package:dream_tech_flutter/service/commonService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonComponents/TextConstraints.dart';

class DescriptionViewModel extends GetxController {
  final APIService apiService = APIService.instance;
  final CommonService commonService = CommonService();
  final NavigationService navigationService = NavigationService();
  final Rx<DreamModel> dreamModel = DreamModel().obs;
  final Rx<TimeOfDay?> bedTime = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> wakeTime = Rx<TimeOfDay?>(null);
  final Map<int, TextEditingController> controllers = {};


  @override
  void onClose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    controllers.clear();
    super.onClose();
  }

  void setTitle(String title) => dreamModel.update((val) => val!.title = title);
  void setType(String type) => dreamModel.update((val) => val!.type = type);
  void setQuality(String quality) => dreamModel.update((val) => val!.quality = quality);
  void setSleepTime(String times) => dreamModel.update((val) => val!.sleepTime = times);
  void setBedTime(TimeOfDay time) => bedTime.value = time;
  void setWakeTime(TimeOfDay time) => wakeTime.value = time;
  void addNewForm() {
    if (dreamModel.value.content.length < 6 &&
        !dreamModel.value.content.contains("")) {
      dreamModel.update((val) => val!.content.add(""));
    }
  }
  void updateFormContent(int index, String content) {
    dreamModel.update((val) => val!.content[index] = content);
  }
  void removeFormContent(int index){
    if(dreamModel.value.content.length != 1){
      controllers[index]?.dispose();
      controllers.remove(index);
      dreamModel.update((val) => val!.content.removeAt(index));

      final Map<int, TextEditingController> newControllers = {};
      for (int i = 0; i < dreamModel.value.content.length; i++) {
        if (i >= index) {
          if (controllers.containsKey(i + 1)) {
            newControllers[i] = controllers[i + 1]!;
          }
        } else {
          newControllers[i] = controllers[i]!;
        }
      }
      controllers.clear();
      controllers.addAll(newControllers);
    }
  }
  void calculateSleepTime(TimeOfDay? bedTime,TimeOfDay? wakeTime,){
    final String sleepTime = commonService.calculateSleepTime(bedTime, wakeTime);
    setSleepTime(sleepTime);
  }

  TextEditingController getController(int index) {
    if (!controllers.containsKey(index)) {
      controllers[index] = TextEditingController(
          text: dreamModel.value.content[index]
      );
    }
    return controllers[index]!;
  }

  Future<void> onTapTimePicker(BuildContext context,bool isBedTime) async{
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: isBedTime
            ? bedTime.value ?? TimeOfDay.now()
            : wakeTime.value ?? TimeOfDay.now()
    );
    if(picked != null){
      if(isBedTime){
        setBedTime(picked);
      }else{
        setWakeTime(picked);
      }
    }
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void checkItem(BuildContext context,DescriptionViewModel viewModel)  {
    if (dreamModel.value.title.isEmpty ||
        dreamModel.value.content.join('\n').isEmpty ||
        dreamModel.value.type.isEmpty ||
        dreamModel.value.quality.isEmpty ||
        dreamModel.value.sleepTime.isEmpty
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TextConstraints.omissionInAnEntry)),
      );
      return;
    }

    navigationService.navigateToLoading(context, dreamModel.value);
  }
}