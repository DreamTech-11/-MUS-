import 'package:dream_tech_flutter/commonComponents/ColorConstraints.dart';
import 'package:dream_tech_flutter/components/DreamCardListScreen/DreamCardListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../commonComponents/ImageFile.dart';
import '../DailyCardScreen/daily_card.dart';

class dreamCardListScreen extends StatelessWidget {
  final DreamCardListViewModel viewModel = Get.put(DreamCardListViewModel());
  final Function(int) onItemTapped;
  final DateFormat formatter = DateFormat('yyyy/MM');

  dreamCardListScreen({
    Key? key,
    required this.onItemTapped,
  }) : super(key: key) {
    viewModel.fetchDreams(viewModel.currentDate.value.year, viewModel.currentDate.value.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _buildAppBarTitle(),
      backgroundColor: Colors.white,
      centerTitle: true,
      automaticallyImplyLeading: false,
      bottom: _buildAppBarBottomBorder(),
    );
  }

  Widget _buildAppBarTitle() {
    return Obx(() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 34),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavigationButton(Icons.arrow_circle_left_outlined, -1),
              Text(
                formatter.format(viewModel.currentDate.value),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ),
              _buildNavigationButton(Icons.arrow_circle_right_outlined, 1),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            onItemTapped(2);
          },
          child: Image.asset(
            ImageFile.settingIcon,
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(width: 10)
      ],
    ));
  }

  Widget _buildNavigationButton(IconData icon, int monthDelta) {
    return IconButton(
      onPressed: () => viewModel.updateMonth(monthDelta),
      icon: Icon(icon),
    );
  }

  PreferredSize _buildAppBarBottomBorder() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: Colors.black,
        height: 1.0,
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorConstraints.homeScreenColorTop,
            ColorConstraints.homeScreenColorCenter,
            ColorConstraints.homeScreenColorBottom,
          ],
        ),
      ),
      child: Center(
        child: Obx(() {
          if (viewModel.isLoading.value) {
            return const CircularProgressIndicator(color: ColorConstraints.musoColor);
          }
          return _buildDreamList();
        }),
      ),
    );
  }

  Widget _buildDreamList() {
    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
        itemCount: viewModel.dayList.length,
        itemBuilder: (context, index) => _buildDailyCard(viewModel.dayList[index]),
      ),
    );
  }

  Widget _buildDailyCard(Map<String, dynamic> dayItem) {
    final createdAt = DateTime.parse(dayItem['created_at']);
    final formattedDate = DateFormat('MM/dd').format(createdAt);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: DailyCard(
        days: formattedDate,
        sleepTime: dayItem['sleep_time'],
        quality: dayItem["quality"],
        type: dayItem["dream_type"],
        id: dayItem['id'],
        dayItem: dayItem,
        onDelete: () async {
          await viewModel.deleteDream(dayItem['id'],dayItem['image_url']);
        },
      ),
    );
  }
}