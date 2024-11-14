import 'package:dream_tech_flutter/commonComponents/ColorConstraints.dart';
import 'package:dream_tech_flutter/commonComponents/MapConstraints.dart';
import 'package:dream_tech_flutter/components/DescriptionScreen/descriptioinViewModel.dart';
import 'package:dream_tech_flutter/components/dialog/deleteDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../commonComponents/FontFamily.dart';
import '../../commonComponents/TextConstraints.dart';
import '../../commonComponents/showHintDialogWidget.dart';

class DescriptionScreen extends StatelessWidget {
  final DescriptionViewModel viewModel = Get.put(DescriptionViewModel());

  DescriptionScreen({super.key}) {}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: descriptionAppbar(),
      body: GestureDetector(
        onTap:() {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            titleScreen(viewModel: viewModel),
            dreamContent(viewModel: viewModel),
            dreamType(viewModel: viewModel,context: context),
            SleepTime(viewModel: viewModel),
            dreamQuality(viewModel: viewModel),
            createButton(context: context,viewModel: viewModel),
          ],
        ),
      ),
    );
  }
}

PreferredSizeWidget descriptionAppbar() {
  DateTime now = DateTime.now();
  String formattedDateTime = DateFormat('yyyy/MM/dd').format(now);

  return AppBar(
    title: Text(
      formattedDateTime,
      style: const TextStyle(
        fontFamily: FontFamily.NotoSansJP,
        fontWeight: FontWeight.w600,
        fontSize: 25,
        color: Colors.black,
      ),
    ),
    backgroundColor: Colors.white,
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

Widget titleScreen({required DescriptionViewModel viewModel}) {

  return Container(
    width: double.infinity,
    height: 140,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 17),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              TextConstraints.title,
              style: TextStyle(
                  fontFamily: FontFamily.NotoSansJP,
                  fontWeight: FontWeight.w900,
                  fontSize: 22
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Divider(color: Colors.grey, thickness: 1.5, height: 1.5),
          const SizedBox(height:15),
          TextField(
            onChanged: viewModel.setTitle,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0)
              ),
              hintText: TextConstraints.hintTextOfDescriptionTitle,
            ),
          )
        ],
      ),
    ),
  );
}



Widget dreamContent ({required DescriptionViewModel viewModel}){
  return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 17),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      TextConstraints.dreamContent,
                      style: TextStyle(
                          fontFamily: FontFamily.NotoSansJP,
                          fontWeight: FontWeight.w900,
                          fontSize: 22
                      ),
                    )
                ),
                const SizedBox(height: 6),
                const Divider(color: Colors.grey, thickness: 1.5, height: 1.5),
                const SizedBox(height:7),
                Obx(() => LimitedBox(
                  maxHeight: double.infinity,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:viewModel.dreamModel.value.content.length,
                      itemBuilder: (context,index){
                        return ItemizationForm(index: index,viewModel: viewModel);
                      }
                  ),
                )
                )
              ],
            ),
          ),
        );
      }
  );
}

class ItemizationForm extends StatelessWidget {
  final int index;
  final DescriptionViewModel viewModel;
  static const int maxCharacters = 50;

  const ItemizationForm({
    Key? key,
    required this.index,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.black.withOpacity(0.6), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                // 現在のフォーカスを解除
                FocusManager.instance.primaryFocus?.unfocus();
                DeleteDialog.deleteDialog(
                  context,
                      () => viewModel.removeFormContent(index),
                );
              },
              icon: const Icon(Icons.delete),
              color: Colors.grey,
            ),
            Expanded(
              child: TextField(
                  controller: viewModel.getController(index),
                  onChanged: (value) {
                    viewModel.updateFormContent(index, value);
                    if (value.trim().isNotEmpty) {
                      viewModel.addNewForm();
                    }
                  },
                  maxLines: null,
                  maxLength: maxCharacters,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: TextConstraints.hintTextOfDescriptionContent,
                    contentPadding: EdgeInsets.only(top: 8, bottom: 8, right: 12),
                  ),
                  style: const TextStyle(
                      fontSize: 16,
                      fontFamily: FontFamily.NotoSansJP
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget dreamType({
  required DescriptionViewModel viewModel,
  required BuildContext context
}) {
  final MapConstraints mapConstraints = MapConstraints();

  return Container(
    width: double.infinity,
    height: 100,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 17),
          Row(
            children: [
              const Text(
                TextConstraints.dreamType,
                style: TextStyle(
                    fontFamily: FontFamily.NotoSansJP,
                    fontWeight: FontWeight.w900,
                    fontSize: 14
                ),
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  HintDialogWidget.showHintDialog(context: context);
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 4),
                  child: const Icon(
                    Icons.help_outline,
                    size: 22,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mapConstraints.typeMap.length,
                itemBuilder: (context,index){
                  final key = mapConstraints.typeMap.keys.elementAt(index);
                  final value = mapConstraints.typeMap[key]!;

                  return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Obx(() => selectItem(
                          typeColor: mapConstraints.typeLiteColorMap[key],
                          item: value,
                          isSelected: viewModel.dreamModel.value.type == key,
                          onTap: () => viewModel.setType(key)
                      )),
                  );
                }
            ),
          )
        ],
      ),
    ),
  );
}

Widget selectItem({
  required Color? typeColor,
  required String item,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: 60,
        height: 20,
          decoration: BoxDecoration(
              color: isSelected
                  ? typeColor ?? Colors.lightBlue[300]
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(16)
          ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 6.0),
              child: Text(
                item,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget dreamQuality({required DescriptionViewModel viewModel}) {
  final MapConstraints mapConstraints = MapConstraints();

  return Container(
    width: double.infinity,
    height: 75,
    color: Colors.white,
    child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              TextConstraints.dreamQuality,
              style: TextStyle(
                  fontFamily: FontFamily.NotoSansJP,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mapConstraints.qualityMap.length,
                itemBuilder: (context,index){
                  final key = mapConstraints.qualityMap.keys.elementAt(index);
                  final value = mapConstraints.qualityMap[key]!;

                  return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Obx(() => selectItem(
                        typeColor: mapConstraints.qualityTypeColorMap[key],
                        item: value,
                        isSelected: viewModel.dreamModel.value.quality == key,
                        onTap: () => viewModel.setQuality(key)
                      )),
                  );
                }
            ),
          )
        ],
      ),
    ),
  );
}

class SleepTime extends StatelessWidget {
  final DescriptionViewModel viewModel;
  SleepTime({super.key, required this.viewModel});
  TimeOfDay? bedTime;
  TimeOfDay? wakeTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                TextConstraints.sleepTime,
                style: TextStyle(
                    fontFamily: FontFamily.NotoSansJP,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black
                ),
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 40,
                width: 240,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                    color: Colors.black.withOpacity(0.6),
                    width: 1
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    timeSelector(context,true),

                    const Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "~",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )

                    ),

                    timeSelector(context,false)

                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget timeSelector(BuildContext context, bool isBedTime) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => viewModel.onTapTimePicker(context,isBedTime),
        child: Ink(
          decoration: const BoxDecoration(color: Colors.white),
          child: Center(
            child: Obx(() {
              final time = isBedTime ? viewModel.bedTime.value : viewModel.wakeTime.value;
              return Text(
                time?.format(context) ?? (isBedTime ? '0:40' : '9:00'),
                style: TextStyle(
                    color: time == null ? Colors.grey : Colors.black,
                    fontSize: 18
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

Widget createButton({
  required BuildContext context,
  required DescriptionViewModel viewModel ,
}) {
  return Align(
    alignment: Alignment.center,
    child: Container(
      width: double.infinity,
      height: 200,
      color: Colors.white,
      child: Center(
        child: Container(
          width: 170,
          height: 50,
          decoration: BoxDecoration(
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                viewModel.calculateSleepTime(
                    viewModel.bedTime.value,
                    viewModel.wakeTime.value
                );
                viewModel.checkItem(context,viewModel);
              },
              borderRadius: BorderRadius.circular(24.0),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  color: ColorConstraints.bottomTextButtonColor,
                ),
                child: const Center(
                  child: Text(
                    TextConstraints.generationStory,
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
        ),
      ),
    ),
  );
}