import 'package:dream_tech_flutter/commonComponents/MapConstraints.dart';
import 'package:dream_tech_flutter/commonComponents/TextConstraints.dart';
import 'package:dream_tech_flutter/components/DreamDiaryScreen/dreamDiaryViewModel.dart';
import 'package:dream_tech_flutter/components/DreamDiaryScreen/socialShareManager.dart';
import 'package:dream_tech_flutter/model/DreamModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../commonComponents/ColorConstraints.dart';
import '../../commonComponents/FontFamily.dart';
import '../../commonComponents/ImageFile.dart';

class DreamDiaryScreen extends StatelessWidget {
  final DreamModel dreamModel;
  final int? id;
  final GlobalKey _globalKey = GlobalKey();
  late final DreamDiaryViewModel viewModel;

  DreamDiaryScreen({
    super.key,
    required this.dreamModel,
    this.id,
  }) {
    viewModel = Get.put(DreamDiaryViewModel(dreamModel));
  }

  Future<void> shareImage() async {
    try {
      final shareManager = SocialShareManager();
      final screenshot = await shareManager.takeScreenshot(_globalKey);

      if (screenshot != null) {
        await shareManager.share(
          contents: "${dreamModel.createAt}\n${TextConstraints.shareText}",
          screenshot: screenshot,
        );
      }
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dreamDiaryAppBar(viewModel.dreamModel.value),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: ColoredBox(
                color: Colors.white,
                child: Column(
                  children: [
                    Obx(() => titleAndImage(
                        title: viewModel.dreamModel.value.gptTitle,
                        imagePath: viewModel.dreamModel.value.dreamImageURL,
                        dreamContext: viewModel.dreamModel.value.gptContent,
                        updateDreamContent: viewModel.updateDreamContent,
                        context: context
                    )),
                    dailyCardSection(
                        type: viewModel.dreamModel.value.type,
                        time: viewModel.dreamModel.value.sleepTime,
                        quality: viewModel.dreamModel.value.quality
                    ),
                  ],
                ),
              ),
            ),
            saveButton(
              context: context,
              id: id,
              viewModel: viewModel,
              shareImage: shareImage,
              dreamModel: viewModel.dreamModel.value,
            ),
          ],
        ),
      ),
    );
  }
}

PreferredSizeWidget? dreamDiaryAppBar(DreamModel dreamModel) {
  return AppBar(
    title: Text(
      dreamModel.createAt,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 25,
        color: Colors.black,
      ),
    ),
    backgroundColor: Colors.white,
    automaticallyImplyLeading: true,
    centerTitle: true,
    bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.black,
          height: 1.0,
        )
    ),
  );
}

Widget dailyCardSection({
  required String type,
  required String time,
  required String quality
}) {
  final MapConstraints mapConstraints = MapConstraints();

  return Container(
    color: Colors.white,
    width: double.infinity,
    height: 150,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              mapConstraints.typeImageMap[type]!,
              width: 65,
              height: 65,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(width: 25),
           Expanded(
               child: Column(
                 children: [
                   dreamType(type: mapConstraints.typeMap[type]!,typeEN: type),
                   const SizedBox(height: 4),
                   sleepTime(time: time),
                   const SizedBox(height: 8),
                   sleepQuality(quality: mapConstraints.qualityMap[quality]!)
                 ],
               )
           ),
        ],
      ),
    ),
  );
}

Widget typeName({required String assetName}) {
  return SizedBox(
    width: 120,
    child: Row(
      children: [
        Text(
          assetName,
          style: const TextStyle(
              fontSize: 19,
              fontFamily: FontFamily.NotoSansJP,
              fontWeight: FontWeight.w600
          ),
        ),
        const Spacer(),
        const Text(
          "：",
          style: TextStyle(
              fontSize: 19,
              fontFamily: FontFamily.NotoSansJP,
              fontWeight: FontWeight.w600
          ),
        ),
      ],
    ),
  );
}

Widget dreamType({required String type, required String typeEN}) {
  final MapConstraints mapConstraints = MapConstraints();

  return Row(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: typeName(assetName: TextConstraints.dreamType),
      ),
      const Spacer(),
      SizedBox(
        width: 120,
        child: Center(
          child: Text(
            type,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: FontFamily.NotoSansJP,
                fontSize: 28,
                color: mapConstraints.typeColorMap[typeEN]!
            ),
          ),
        ),
      )
    ],
  );
}

Widget sleepTime({required String time}) {
  return Row(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: typeName(assetName: TextConstraints.sleepTime),
      ),
      const Spacer(),
      Container(
        width: 120,
        height: 25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.grey[300]
        ),
        child: Center(
            child: Text(
              time,
              style: const TextStyle(
                  fontSize: 15,
                  fontFamily: FontFamily.NotoSansJP,
                  fontWeight: FontWeight.w500
              ),
            )
        ),
      ),
    ],
  );
}

Widget sleepQuality({required String quality}) {
  return Row(
    children: [
      Align(
        alignment: Alignment.topLeft,
        child: typeName(assetName: TextConstraints.dreamQuality),
      ),
      const Spacer(),
      Container(
        width: 120,
        height: 25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.grey[300]
        ),
        child: Center(
            child: Text(
              quality,
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: FontFamily.NotoSansJP,
                  fontWeight: FontWeight.w700
              ),
            )
        ),
      ),
    ],
  );
}

Widget titleAndImage({
  required String title,
  required String dreamContext,
  required String imagePath,
  required Function(String) updateDreamContent,
  required BuildContext context
}) {
  print(imagePath);
  void showEditBottomSheet() {
    final TextEditingController textController = TextEditingController(text: dreamContext);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom
            ),
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.53,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16,right: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            TextConstraints.editDreamContent,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.NotoSansJP,
                                color: Colors.black
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                updateDreamContent(textController.text);
                                Navigator.pop(context);
                                },
                              child: Text(
                                TextConstraints.saveText,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: FontFamily.NotoSansJP,
                                    color: Colors.lightBlue.withOpacity(0.8)
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: TextField(
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.multiline,
                          controller: textController,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: TextConstraints.hintTextOfDescriptionTitle,
                            contentPadding: EdgeInsets.all(12),
                          ),
                          style: const TextStyle(
                            fontFamily: FontFamily.NotoSansJP,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  return Container(
    width: double.infinity,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  fontFamily: FontFamily.NotoSansJP
              ),
            ),
          ),
          const SizedBox(height: 4),
          Divider(height: 2, color: Colors.grey[350]),
          const SizedBox(height: 13),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress
                      ){
                    if(loadingProgress == null){
                      return child;
                    }
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[400]
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded
                              / loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white
                        ),
                      ),
                    );
                  },
                ),
              )
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(18)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: showEditBottomSheet,
                        icon: Image.asset(
                          ImageFile.editingIcon,
                          width: 20,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14,left: 14,bottom: 15),
                  child: Text(
                    dreamContext,
                    style: const TextStyle(
                        fontFamily: FontFamily.NotoSansJP,
                        fontSize: 14,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget saveButton({
  required int? id,
  required BuildContext context,
  required Function shareImage,
  required DreamDiaryViewModel viewModel,
  required DreamModel dreamModel
}) {
  return Container(
    width: double.infinity,
    height: 100,
    color: Colors.white,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Material(
        color: Colors.transparent,
        child: Ink(
          width: 170,
          height: 50,
          decoration: BoxDecoration(
            color: ColorConstraints.bottomButtonColor,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              id != null
                  ? viewModel.updateData(id,context)
                  : viewModel.saveData(context);
            },
            borderRadius: BorderRadius.circular(24.0),
            child: const Center(
              child: Text(
                TextConstraints.saveText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: FontFamily.NotoSansJP
                ),
              ),
            ),
          ),
        ),
      ),
        Positioned(
          right: 50,
            child: IconButton(
              onPressed: (){
                shareImage();
              },
              icon: const Icon(Icons.share),
            )
        )
      ],
    ),
  );
}