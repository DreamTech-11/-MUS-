import 'package:dream_tech_flutter/FirebaseStorage/StorageService.dart';
import 'package:dream_tech_flutter/commonComponents/ImageFile.dart';
import 'package:dream_tech_flutter/service/APIService.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DreamCardListViewModel extends GetxController {
  final APIService apiService = APIService.instance;
  final StorageService storageService = StorageService();
  final RxList<dynamic> dayList = <dynamic>[].obs;
  final RxBool isLoading = true.obs;
  var currentDate = DateTime.now().obs;


  Future<void> fetchDreams(int year, int month) async {
    try {
      final dreams = await apiService.getDreams(year, month);
      dreams.sort((a, b) {
        final dateA = DateTime.parse(a['created_at']);
        final dateB = DateTime.parse(b['created_at']);
        return dateA.compareTo(dateB);
      });
      isLoading.value = true;
      dayList.assignAll(dreams);
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      print('Error fetching dreams: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDream(int id,String imageURL) async {
    try {
      isLoading.value = true;
      await apiService.deleteDream(id);
      await storageService.deleteFile(imageURL);
      await fetchDreams(currentDate.value.year, currentDate.value.month);
    } catch (e) {
      print('Error deleting dream: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateMonth(int monthDelta) {
    currentDate.value = DateTime(currentDate.value.year, currentDate.value.month + monthDelta, 1);
    fetchDreams(currentDate.value.year, currentDate.value.month);
  }

  String? getEmojiForDreamTypes(List<String>? dreamTypes) {
    if (dreamTypes == null || dreamTypes.isEmpty) return null;
    switch (dreamTypes.first) {
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
}