import 'package:dream_tech_flutter/model/DreamModel.dart';
import 'package:dream_tech_flutter/service/NavigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../commonComponents/TextConstraints.dart';
import '../components/HomeScreen/HomeScreen.dart';
import 'APIService.dart';

class CommonService {
  final APIService apiService = APIService.instance;
  final NavigationService navigationService = NavigationService();

  Future<void> saveData(BuildContext context,DreamModel dreamModel) async {
    final data = {
      'title': dreamModel.title,
      'content': dreamModel.content.join('\n'),
      'dream_type': dreamModel.type,
      'quality': dreamModel.quality,
      'sleep_time': dreamModel.sleepTime,
      'gpt_response':dreamModel.gptContent,
      'image_url' : dreamModel.dreamImageURL
    };

    try {
      await apiService.createDreamPost(data);
      print('Dream post created successfully');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen()
          )
      );
    } catch (e) {
      print('Error creating dream post: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TextConstraints.errorPostDream)),
      );
    }
  }

  String calculateSleepTime(TimeOfDay? bedTime, TimeOfDay? wakeTime) {
    if (bedTime == null || wakeTime == null) return "";

    final now = DateTime.now();
    final bed = DateTime(now.year, now.month, now.day, bedTime.hour, bedTime.minute);
    var wake = DateTime(now.year, now.month, now.day, wakeTime.hour, wakeTime.minute);

    if (wake.isBefore(bed)) {
      wake = wake.add(const Duration(days: 1));
    }
    var sleepDuration = wake.difference(bed);
    final hours = sleepDuration.inHours;
    final minutes = sleepDuration.inMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours時間$minutes分';
    } else if (hours > 0) {
      return '$hours時間';
    } else {
      return '$minutes分';
    }
  }

  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    return DateFormat('yyyy/MM').format(now);
  }
}