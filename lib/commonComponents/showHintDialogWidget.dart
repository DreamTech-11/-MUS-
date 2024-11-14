import 'package:flutter/material.dart';
import 'ColorConstraints.dart';
import 'FontFamily.dart';
import 'ImageFile.dart';
import 'TextConstraints.dart';

class HintDialogWidget extends StatefulWidget {
  const HintDialogWidget({super.key});

  static Future<void> showHintDialog({
    required BuildContext context,
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const HintDialogWidget();
        }
    );
  }

  @override
  State<HintDialogWidget> createState() => _HintDialogWidgetState();
}

class _HintDialogWidgetState extends State<HintDialogWidget> {
  int _currentPage = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: double.maxFinite,
        constraints: const BoxConstraints(
          maxHeight: 500,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogTitleAndCloseButton(context),
            Expanded(
              child: PageView(
                physics: const BouncingScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _dreamTypeDescription(
                            dreamType: TextConstraints.wishfulDream,
                            dreamContext: TextConstraints.wishfulDreamContext,
                            psychologyMeaning: TextConstraints.wishfulPsychologyMeaning,
                            imageFile: ImageFile.wishfulFace,
                            dreamColor: ColorConstraints.wishfulTextColor
                        ),
                        _dreamTypeDescription(
                            dreamType: TextConstraints.premonitionDream,
                            dreamContext: TextConstraints.premonitionDreamContext,
                            psychologyMeaning: TextConstraints.premonitionPsychologyMeaning,
                            imageFile: ImageFile.premonitionFace,
                            dreamColor: ColorConstraints.premonitionTextColor
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _dreamTypeDescription(
                            dreamType: TextConstraints.trueDream,
                            dreamContext: TextConstraints.trueDreamContext,
                            psychologyMeaning: TextConstraints.truePsychologyMeaning,
                            imageFile: ImageFile.trueFace,
                            dreamColor: ColorConstraints.trueTextColor
                        ),
                        _dreamTypeDescription(
                            dreamType: TextConstraints.falseDream,
                            dreamContext: TextConstraints.falseDreamContext,
                            psychologyMeaning: TextConstraints.falsePsychologyMeaning,
                            imageFile: ImageFile.falseFace,
                            dreamColor: ColorConstraints.falseTextColor
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _dreamTypeDescription(
                            dreamType: TextConstraints.goodDream,
                            dreamContext: TextConstraints.goodDreamContext,
                            psychologyMeaning: TextConstraints.goodPsychologyMeaning,
                            imageFile: ImageFile.goodFace,
                            dreamColor: ColorConstraints.goodTextColor
                        ),
                        _dreamTypeDescription(
                            dreamType: TextConstraints.badDream,
                            dreamContext: TextConstraints.badDreamContext,
                            psychologyMeaning: TextConstraints.badPsychologyMeaning,
                            imageFile: ImageFile.badFace,
                            dreamColor: ColorConstraints.badTextColor
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _dreamTypeDescription(
                            dreamType: TextConstraints.waringDream,
                            dreamContext: TextConstraints.warningDreamContext,
                            psychologyMeaning: TextConstraints.warningPsychologyMeaning,
                            imageFile: ImageFile.warningFace,
                            dreamColor: ColorConstraints.waringTextColor
                        ),
                        _dreamTypeDescription(
                            dreamType: TextConstraints.anxietyDream,
                            dreamContext: TextConstraints.anxietyDreamContext,
                            psychologyMeaning: TextConstraints.anxietyPsychologyMeaning,
                            imageFile: ImageFile.anxietyFace,
                            dreamColor: ColorConstraints.anxietyTextColor
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6,top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.grey
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogTitleAndCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 11, left: 14, right: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            TextConstraints.dreamIntroductionDialogTitle,
            style: TextStyle(
                fontSize: 20,
                fontFamily: FontFamily.NotoSansJP,
                fontWeight: FontWeight.w900
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Text(
                        TextConstraints.closeText,
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: FontFamily.NotoSansJP,
                            fontWeight: FontWeight.w600,
                            color: ColorConstraints.closeButtonColor
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Image.asset(
                      ImageFile.closeIcon,
                      width: 14,
                      height: 14,
                      color: ColorConstraints.closeButtonColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dreamTypeDescription({
    required String dreamType,
    required String dreamContext,
    required String psychologyMeaning,
    required String imageFile,
    required Color dreamColor
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 25,left: 8,right: 8,bottom: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
                height: 60,
                imageFile
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Text(
                      dreamType,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontFamily.NotoSansJP,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 1.7
                          ..color = Colors.black,
                      ),
                    ),
                    Text(
                      dreamType,
                      style: TextStyle(
                        color: dreamColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontFamily.NotoSansJP,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  TextConstraints.dreamContextTitle,
                  style: TextStyle(
                      fontFamily: FontFamily.NotoSansJP,
                      fontWeight: FontWeight.w900,
                      fontSize: 13
                  ),
                ),
                Text(
                  dreamContext,
                  style: const TextStyle(
                      fontFamily: FontFamily.NotoSansJP,
                      fontWeight: FontWeight.w500,
                      fontSize: 11
                  ),
                ),
                const Text(
                  TextConstraints.psychologyMeaningTitle,
                  style: TextStyle(
                      fontFamily: FontFamily.NotoSansJP,
                      fontWeight: FontWeight.w900,
                      fontSize: 13
                  ),
                ),
                Text(
                  psychologyMeaning,
                  style: const TextStyle(
                      fontFamily: FontFamily.NotoSansJP,
                      fontWeight: FontWeight.w500,
                      fontSize: 11
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}