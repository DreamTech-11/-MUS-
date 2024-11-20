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
  Timer? _progressTimer;


  void animateProgress(double from, double to) {
    final duration = Duration(milliseconds: 4000);
    final curve = Curves.easeInOut;
    final steps = 600;

    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(duration ~/ steps, (timer) {
      final progress = timer.tick / steps;
      if (progress >= 1.0) {
        timer.cancel();
        this.progress.value = to;
        return;
      }

      final curvedProgress = curve.transform(progress);
      this.progress.value = from + (to - from) * curvedProgress;
    });
  }


  Future<void> pushTitleAndContent(BuildContext context,DreamModel dreamModel) async {
    try{
      animateProgress(0.0, 0.1);

      final response = await apiService.gptQuery(
          dreamModel.title,
          dreamModel.content.join('\n'),
          (progress) {
            animateProgress(this.progress.value, progress);
          }
      );

      animateProgress(progress.value, 0.7);

      final String imageURL = await storageService.downloadAndUploadImage(response['image_url']!);

      animateProgress(progress.value, 0.9);

      dreamModel.gptTitle = dreamModel.title;
      dreamModel.gptContent = response['content']!;
      dreamModel.dreamImageURL = imageURL;

      animateProgress(progress.value, 1.0);

      await Future.delayed(Duration(milliseconds: 4000));
      navigationService.navigateToDreamDiaryNoStack(context, dreamModel);
    }catch (e) {
      print('Error creating dream post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TextConstraints.errorGPTResponse)),
      );
      Navigator.pop(context);
    } finally {
      progress.value = 0.0;
    }
  }
}