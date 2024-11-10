import 'dart:async';
import 'package:dream_tech_flutter/model/DreamModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../FirebaseStorage/StorageService.dart';
import '../../commonComponents/TextConstraints.dart';
import '../../service/APIService.dart';
import '../../service/NavigationService.dart';

class LoadingViewModel extends GetxController {
  final NavigationService navigationService = NavigationService();
  final storageService = StorageService();
  final APIService apiService = APIService.instance;
  final RxDouble progress = 0.0.obs;
  Timer? _timer;

  void _startFakeProgress() {
    progress.value = 0.0;
    _timer = Timer.periodic(Duration(milliseconds: 170), (timer) {
      if (progress.value < 0.9) {
        progress.value += 0.005;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> pushTitleAndContent(BuildContext context,DreamModel dreamModel) async {
    try{
      _startFakeProgress();
      final response = await apiService.gptQuery(dreamModel.title, dreamModel.content.join('\n'));
      final String imageURL = await storageService.downloadAndUploadImage(response['image_url']!);
      _timer?.cancel();
      progress.value = 0.9;
      dreamModel.gptTitle = dreamModel.title;
      dreamModel.gptContent = response['content']!;
      dreamModel.dreamImageURL = imageURL;

      progress.value = 1.0;
      await Future.delayed(Duration(milliseconds: 1000));
      navigationService.navigateToDreamDiaryNoStack(context, dreamModel);
    }catch (e) {
      print('Error creating dream post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TextConstraints.errorGPTResponse)),
      );
      Navigator.pop(context);
    } finally {
      _timer?.cancel();
      progress.value = 0.0;
    }
  }
}