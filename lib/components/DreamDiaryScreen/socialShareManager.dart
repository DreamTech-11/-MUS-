import 'dart:io';
import 'dart:ui' as ui;
import 'package:dream_tech_flutter/commonComponents/TextConstraints.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SocialShareManager {
  SocialShareManager();

  /// SNSシェア
  Future<void> share({
    required String contents,
    File? screenshot,
  }) async {
    try {
      if (screenshot == null) {
        throw Exception(TextConstraints.cantAcquisition);
      }

      await Share.shareXFiles(
        [XFile(screenshot.path)],
        text: contents,
      );
    } catch (e) {
      debugPrint('Share error: $e');
      rethrow; // エラーを上位で処理できるように再スロー
    }
  }

  /// スクリーンショットをしたい画面をRepaintBoundaryで囲む必要がある
  Future<File?> takeScreenshot(GlobalKey globalKey) async {
    try {
      // UIのレンダリングが確実に完了するまで300ミリ秒待機
      // これがないとレンダリング途中でスクリーンショットを撮ってしまう可能性がある
      await Future.delayed(const Duration(milliseconds: 300));

      // globalKeyを使って、RepaintBoundaryウィジェットのレンダーオブジェクトを取得
      // findRenderObject()でウィジェットの実際のレンダリング情報にアクセス
      final boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception(TextConstraints.cantAcquisitionRenderRepaintBoundary);
      }

      // RepaintBoundaryの内容をイメージとして取得
      final image = await boundary.toImage(pixelRatio: 2.0);
      // 取得した画像をPNGフォーマットのバイトデータに変換
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception(TextConstraints.cantAcquisitionImage);
      }
      // バイトデータをUint8List（バイト配列）に変換
      // これで実際のPNG画像のバイナリデータが得られる
      final pngBytes = byteData.buffer.asUint8List();
      // この場所に一時的にスクリーンショット画像を保存する
      final tempDir = await getTemporaryDirectory();
      // スクリーンショット用のファイルを作成
      final imageFile = await File('${tempDir.path}/screenshot_'
          '${DateTime.now().millisecondsSinceEpoch}.png').create();

      // PNG画像データをファイルに書き込み
      return await imageFile.writeAsBytes(pngBytes);
    } catch (e) {
      debugPrint('Screenshot error: $e');
      return null;
    }
  }
}