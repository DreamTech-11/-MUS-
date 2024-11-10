import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> downloadAndUploadImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        print('画像のダウンロードに失敗: ${response.statusCode}');
        return '';
      }

      final tempDir = await getTemporaryDirectory();
      final fileName = 'dalle_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${tempDir.path}/$fileName');

      final originalImage = img.decodeImage(response.bodyBytes);
      if (originalImage == null) {
        print('画像のデコードに失敗');
        return '';
      }

      final lowQualityBytes = img.JpegEncoder(quality: 50).encode(originalImage);
      await file.writeAsBytes(lowQualityBytes);

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('images/$fileName');

        await storageRef.putFile(
            file,
            SettableMetadata(
                contentType: 'image/jpeg',
                customMetadata: {'createdAt': DateTime.now().toIso8601String()}
            )
        );

        final downloadURL = await storageRef.getDownloadURL();
        return downloadURL;
      } finally {
        // 一時ファイルの削除
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      print('エラーが発生: $e');
      return '';
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.refFromURL(path);
      await ref.delete();
    } catch (e) {
      throw Exception('ファイルのアップロードに失敗しました：$e');
    }
  }
}