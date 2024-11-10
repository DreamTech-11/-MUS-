import 'package:dream_tech_flutter/commonComponents/TextConstraints.dart';
import 'package:dream_tech_flutter/service/NavigationService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/DreamModel.dart';

class DailyCardViewModel extends GetxController{
  final Rx<DreamModel> dreamModel = DreamModel().obs;
  final NavigationService navigationService = NavigationService();

  Future<void> onClickItem(dynamic dayItem, BuildContext context) async {
    try {
      if (dayItem == null) {
        throw Exception(TextConstraints.notExistData);
      }

      // 必要なキーの存在チェック
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

      print(contentList);
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

      // エラーをユーザーに通知
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
}