import 'package:dream_tech_flutter/commonComponents/showHintDialogWidget.dart';
import 'package:dream_tech_flutter/service/NavigationService.dart';
import 'package:dream_tech_flutter/service/commonService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../commonComponents/ColorConstraints.dart';
import 'calenderViewModel.dart';


class CalenderScreen extends StatelessWidget {
  final Function(int) onItemTapped;

  const CalenderScreen({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: calenderAppBar(),
      body: calenderBody(context),
    );
  }

  PreferredSizeWidget calenderAppBar(){
    final CommonService commonService = CommonService();

    return AppBar(
      leading: IconButton(
          onPressed: () =>onItemTapped(0),
          icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black)
      ),
      title: Text(
        commonService.getFormattedDateTime(),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 28,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.black, height: 1.0),
      )
    );
  }

  Widget calenderBody(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorConstraints.homeScreenColorTop,
            ColorConstraints.homeScreenColorCenter,
            ColorConstraints.homeScreenColorBottom
          ],
        ),
      ),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.03,
              right:MediaQuery.of(context).size.width * 0.03,
              bottom: MediaQuery.of(context).size.height * 0.16
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(
                      Icons.help_outline,
                      size: 30,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      HintDialogWidget.showHintDialog(context: context);
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const CalenderWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CalenderWidget extends StatefulWidget {
   const CalenderWidget({super.key});

  @override
  CalenderWidgetState createState() => CalenderWidgetState();
}

class CalenderWidgetState extends State<CalenderWidget> {
  final CalenderViewModel viewModel = Get.put(CalenderViewModel());
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    viewModel.fetchDreams(_focusedDay.year, _focusedDay.month);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCalendarHeader(),
        _buildTableCalender(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
              });
              viewModel.fetchDreams(_focusedDay.year, _focusedDay.month);
            },
          ),
          Text(
            DateFormat('yyyy年 M月').format(_focusedDay),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
              });
              viewModel.fetchDreams(_focusedDay.year, _focusedDay.month);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableCalender() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2020, 12, 31),
      lastDay: DateTime.utc(2030, 12, 31),
      locale: "ja_JP",
      headerVisible: false,
      daysOfWeekVisible: true,
      daysOfWeekStyle: const DaysOfWeekStyle(
        // 曜日テキストの下部に余白を追加
        weekdayStyle: TextStyle(height: 1),
        weekendStyle: TextStyle(height: 1),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
        viewModel.fetchDreams(focusedDay.year, focusedDay.month);
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return _buildCalendarDayContainer(day, viewModel.navigationService);
        },
        todayBuilder: (context, day, focusedDay) {
          return _buildCalendarDayContainer(
              day,
              viewModel.navigationService,
              isToday: true
          )
          ;
        },
        outsideBuilder: (context, day, focusedDay) {
          return _buildCalendarDayContainer(
              day,
              viewModel.navigationService,
              isOutside: true
          );
        },
      ),
      rowHeight: 65,
    );
  }

  Widget _buildCalendarDayContainer(
      DateTime day,
      NavigationService navigationService,
      {bool isToday = false, bool isOutside = false})
  {
    String stringDay = DateFormat('MM/dd').format(day);
    Color textColor = viewModel.getTextColor(day, isOutside);


    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:Obx(() {
              String? imagePath = viewModel.getEmojiForDreamTypes(stringDay);
              return _buildDayImage(
                  imagePath,
                  stringDay,
                  isToday,
                  isOutside,
                  navigationService
              );
            }),
          ),
          Text(
            "${day.day}",
            style: TextStyle(
              fontSize: 12,
              color: textColor,
              fontWeight: isToday ? FontWeight.w900 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayImage(
      String? imagePath,
      String day,
      bool isToday,
      bool isOutside,
      NavigationService navigationService
      ) {
    if (isOutside) return Container();
    const double imageSize = 40;
    const double containerSize = 35;

    if (imagePath != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            viewModel.onClickItem(context, day);
          },
          customBorder: const CircleBorder(),
          child: Ink(
            width: imageSize,
            height: imageSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      );
    } else if (isToday) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            navigationService.navigateToDescription(context);
          },
          customBorder: const CircleBorder(),
          child: Ink(
            width: containerSize,
            height: containerSize,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.add, size: 20, color: Colors.white)
            ),
          ),
        ),
      );
    } else {
      return Container(
          width: containerSize,
          height: containerSize,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          shape: BoxShape.circle
        ),
      );
    }
  }
}