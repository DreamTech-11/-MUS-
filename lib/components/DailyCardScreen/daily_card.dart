import 'package:dream_tech_flutter/commonComponents/FontFamily.dart';
import 'package:dream_tech_flutter/commonComponents/ImageFile.dart';
import 'package:dream_tech_flutter/commonComponents/MapConstraints.dart';
import 'package:dream_tech_flutter/components/DailyCardScreen/dailyCardViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../dialog/deleteDialog.dart';

class DailyCard extends StatefulWidget {
  final String days;
  final String type;
  final String quality;
  final String sleepTime;
  final int id;
  final dynamic dayItem;
  final VoidCallback onDelete;

   const DailyCard({
    super.key,
    required this.days,
    required this.type,
    required this.quality,
    required this.sleepTime,
    required this.id,
    required this.dayItem,
    required this.onDelete
  });

  @override
  DailyCardState createState() => DailyCardState();
}

class DailyCardState extends State<DailyCard> {
  late String _days;
  late String _type;
  late String _quality;
  late String _sleepTime;
  late dynamic _dayItem;
  late VoidCallback _onDelete;
  final DailyCardViewModel viewModel = Get.put(DailyCardViewModel());
  final MapConstraints mapConstraints = MapConstraints();

  @override
  void initState() {
    super.initState();
    _days = widget.days;
    _type = widget.type;
    _quality = widget.quality;
    _sleepTime = widget.sleepTime;
    _dayItem = widget.dayItem;
    _onDelete = widget.onDelete;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final maxWidth = constraints.maxWidth;

        return SizedBox(
            width: double.infinity,
            height: 140,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Stack(
                children: [
                  Align(
                      alignment: const Alignment(-1,-1),
                      child:topDailyCard(days: _days,maxWidth: maxWidth)
                  ),
                  Align(
                    alignment: const Alignment(10, 0.7),
                    child: SizedBox(
                      width: maxWidth,
                      height: 100,
                      child: bottomDailyCard(
                          maxWidth: maxWidth,
                          type: _type,
                          quality: _quality,
                          sleepTime: _sleepTime,
                          context: context,
                          dayItem: _dayItem,
                          viewModel: viewModel,
                          mapConstraints: mapConstraints,
                          onDelete: _onDelete
                      )
                    ),
                  )
                ],
              ),
            )
        );
      },
    );
  }
}

Widget topDailyCard({required String days,required double maxWidth}){
  return SizedBox(
    width: 100,
    height: 62,
    child: dailyOnDailyCard(days: days),
  );
}

Widget dailyOnDailyCard({required String days}) {
  return Card(
    color: Colors.white,
    elevation: 3,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Center(
        child: Text(
          days,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
    ),
  );
}

Widget bottomDailyCard({
  required double maxWidth,
  required String type,
  required String quality,
  required String sleepTime,
  required BuildContext context,
  required dynamic dayItem,
  required DailyCardViewModel viewModel,
  required MapConstraints mapConstraints,
  required Function onDelete
}) {
  return SizedBox(
      child: GestureDetector(
        onTap: () {
          viewModel.onClickItem(dayItem, context);
        },
        child: Card(
          elevation: 3,
          color: Colors.white,
          child:Row(
            children: [
              typeImageOnDailyCard(type: type,mapConstraints: mapConstraints),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      typeNameAndEditButtonRow(
                          type: type,
                          context: context,
                          onDelete: onDelete,
                          mapConstraints: mapConstraints
                      ),
                      const SizedBox(height: 6),
                      sleepingTimeAndSleepQuality(
                          sleepTime: sleepTime,
                          quality: quality,
                          mapConstraints: mapConstraints
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      )
  );
}

Widget typeImageOnDailyCard({required String type,required MapConstraints mapConstraints}) {

  return Padding(
    padding: const EdgeInsets.all(11.0),
    child: Image.asset(
      mapConstraints.typeImageMap[type]!,
      width: 70,
      height: 70,
      fit: BoxFit.cover,
    ),
  );
}

Widget typeNameAndEditButtonRow({
  required String type,
  required BuildContext context,
  required Function onDelete,
  required MapConstraints mapConstraints }) {
  return SizedBox(
    width: double.infinity,
    height: 40,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        typeName(type: type,mapConstraints: mapConstraints),
        editButton(context: context,onDelete: onDelete),
      ],
    ),
  );
}

Widget typeName({required String type,required MapConstraints mapConstraints}) {

  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child:  Text(
      mapConstraints.typeMap[type]!,
      style: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.NotoSansJP,
          fontSize: 20,
          color: mapConstraints.typeColorMap[type]!
      ),
    ),
  );
}

Widget editButton({required BuildContext context, required  Function onDelete}) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: IconButton(
      onPressed: () => DeleteDialog.deleteDialog(context,onDelete),
      icon: Image.asset(
        ImageFile.editingIcon,
        width: 20,
        height: 20,
        fit: BoxFit.fill,
      ),
      padding: EdgeInsets.zero,
    ),
  );
}

Widget sleepingTimeAndSleepQuality({
  required String sleepTime,
  required String quality,
  required MapConstraints mapConstraints
}) {

  return SizedBox(
    height: 40,
    child:  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        sleepingTime(sleepTime: sleepTime),
        const SizedBox(width: 26),
        sleepQuality(quality: mapConstraints.qualityMap[quality]!),
      ],
    ),
  );
}

Widget sleepingTime({required String sleepTime}) {
  return Row(
    children: [
      Image.asset(
        ImageFile.sleepTimeIcon,
        width: 20,
        height: 20,
        fit: BoxFit.fill,
      ),
      const SizedBox(width: 10),
      Container(
        height: 24,
        decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(16)
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Center(
              child: Text(
                sleepTime,
                style: const TextStyle(
                  fontFamily: FontFamily.NotoSansJP,
                    fontSize: 13,
                    color: Colors.black
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget sleepQuality({required String quality}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Image.asset(
        ImageFile.sleepQuality,
        width: 20,
        height: 20,
        fit: BoxFit.fill,
      ),
      const SizedBox(width: 10),
      Container(
        width: 54,
        height: 24,
        decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(16)
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Text(
              quality,
              style: const TextStyle(
                  fontFamily: FontFamily.NotoSansJP,
                  fontSize: 13,
                  color: Colors.black
              ),
            ),
          ),
        ),
      ),
    ],
  );
}