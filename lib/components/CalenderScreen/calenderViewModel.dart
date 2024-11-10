import 'package:dream_tech_flutter/service/NavigationService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../commonComponents/ImageFile.dart';
import '../../commonComponents/TextConstraints.dart';
import '../../model/DreamModel.dart';
import '../../service/APIService.dart';

class CalenderViewModel extends GetxController {
  final APIService apiService = APIService.instance;
  final NavigationService navigationService = NavigationService();
  final Rx<DreamModel> dreamModel = DreamModel().obs;
  final RxMap<String, dynamic> latestDreams = <String, dynamic>{}.obs;
  var currentDate = DateTime.now().obs;

  void updateMonth(int monthDelta) {
    currentDate.value = DateTime(currentDate.value.year, currentDate.value.month + monthDelta, 1);
    fetchDreams(currentDate.value.year, currentDate.value.month);
  }

  Future<void> fetchDreams(int year, int month) async {
    try {
      final dreams = await apiService.getDreams(year, month);
      dreams.sort((a, b) {
        final dateA = DateTime.parse(a['created_at']);
        final dateB = DateTime.parse(b['created_at']);
        return dateA.compareTo(dateB);
      });
      updateDreamTypes(dreams);
    } catch (e) {
      print('Error fetching dreams: $e');
    }
  }

  String? getEmojiForDreamTypes(String day) {
    final dream = latestDreams[day];
    if (dream == null) {
      return null;
    }
    String dreamType = dream['dream_type'];
    switch (dreamType) {
      case 'true':
        return ImageFile.trueFace;
      case 'false':
        return ImageFile.falseFace;
      case 'good':
        return ImageFile.goodFace;
      case 'bad':
        return ImageFile.badFace;
      case 'premonition':
        return ImageFile.premonitionFace;
      case 'warning':
        return ImageFile.warningFace;
      case 'wishful':
        return ImageFile.wishfulFace;
      case "anxiety":
        return ImageFile.anxietyFace;
      default:
        return null;
    }
  }

  void updateDreamTypes(List<dynamic> dreams) {
    try {
      latestDreams.clear();

      for (var dream in dreams) {
        final createdAt = DateTime.parse(dream['created_at']);
        final date = DateFormat('MM/dd').format(createdAt);
        if (!latestDreams.containsKey(date)) {
          latestDreams[date] = dream;
        }
      }
    } catch (e) {
      print("error:$e");
    }
  }

  Future<void> onClickItem(BuildContext context,String day) async {
    try {
      final dayItem = latestDreams[day];
      if (dayItem == null) {
        throw Exception(TextConstraints.notExistData);
      }

      final requiredKeys = [
        'title',
        'content',
        'created_at',
        'gpt_response',
        'dream_type',
        'quality',
        'sleep_time',
        'image_url',
        'id'
      ];

      for (final key in requiredKeys) {
        if (!dayItem.containsKey(key) || dayItem[key] == null) {
          throw Exception('必要なデータ「$key」が見つかりません');
        }
      }

      String originalContent = dayItem['content'] as String;
      List<String> contentList = originalContent
          .split('\n')
          .toList();

      dreamModel.update((dream) {
        if (dream != null) {
          try {
            dream.title = dayItem['title'] as String;
            dream.content = contentList;
            dream.createAt = dayItem['created_at'] as String;
            dream.gptTitle = dayItem['title'] as String;
            dream.gptContent = dayItem['gpt_response'] as String;
            dream.type = dayItem['dream_type'] as String;
            dream.quality = dayItem['quality'] as String;
            dream.sleepTime = dayItem['sleep_time'] as String;
            dream.dreamImageURL = dayItem['image_url'] as String;
          } catch (e) {
            throw Exception('${TextConstraints.failedDataType}: $e');
          }
        } else {
          throw Exception(TextConstraints.failedToInitializationModel);
        }
      });

      navigationService.navigateToDreamDiary(
          context,
          dreamModel.value,
          dayItem['id']
      );

    } catch (e) {
      print('Error in onClickItem: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${TextConstraints.failedToAcquireData}: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: TextConstraints.closeText,
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  Color getTextColor(DateTime day, bool isOutside) {
    if (isOutside) return Colors.grey;
    if (day.weekday == DateTime.saturday) return Colors.blue;
    if (day.weekday == DateTime.sunday) return Colors.red;
    return Colors.black;
  }
}