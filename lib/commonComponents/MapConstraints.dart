import 'package:flutter/material.dart';
import 'ColorConstraints.dart';
import 'ImageFile.dart';
import 'TextConstraints.dart';

class MapConstraints {
  Map<String,String> typeImageMap = {
    'true': ImageFile.trueFace,
    'false': ImageFile.falseFace,
    'good': ImageFile.goodFace,
    'bad': ImageFile.badFace,
    'premonition': ImageFile.premonitionFace,
    'warning': ImageFile.warningFace,
    'wishful': ImageFile.wishfulFace,
    'anxiety': ImageFile.anxietyFace,
  };

  final Map<String, String> typeMap = {
    'true': TextConstraints.trueDream,
    'false': TextConstraints.falseDream,
    'good': TextConstraints.goodDream,
    'bad': TextConstraints.badDream,
    'premonition': TextConstraints.premonitionDream,
    'warning': TextConstraints.waringDream,
    'wishful': TextConstraints.wishfulDream,
    'anxiety': TextConstraints.anxietyDream,
  };

  final Map<String, Color> typeColorMap = {
    'true': Colors.yellow,
    'false': Colors.grey,
    'good': Colors.purpleAccent,
    'bad': Colors.redAccent,
    'premonition': Colors.purple,
    'warning': Colors.deepOrange,
    'wishful': Colors.blueAccent,
    'anxiety': Colors.green,
  };

  final Map<String, Color> typeLiteColorMap = {
    'true': ColorConstraints.trueTextColor,
    'false': ColorConstraints.falseTextColor,
    'good': ColorConstraints.goodTextColor,
    'bad': ColorConstraints.badTextColor,
    'premonition': ColorConstraints.premonitionTextColor,
    'warning': ColorConstraints.waringTextColor,
    'wishful': ColorConstraints.wishfulTextColor,
    'anxiety': ColorConstraints.anxietyTextColor,
  };

  final Map<String, String> qualityMap = {
    'good': TextConstraints.goodQuality,
    'bad': TextConstraints.bodQuality,
    'normal': TextConstraints.normalQuality,
    'light': TextConstraints.lightQuality,
    'shallow': TextConstraints.shadowQuality,
  };

  final Map<String, Color> qualityTypeColorMap = {
    'good': ColorConstraints.deepSleepColor,
    'bad': ColorConstraints.goodSleepColor,
    'normal': ColorConstraints.normalSleepColor,
    'light': ColorConstraints.lightSleepColor,
    'shallow': ColorConstraints.shallowSleepColor,
  };
}