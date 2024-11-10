import 'package:dream_tech_flutter/commonComponents/ColorConstraints.dart';
import 'package:dream_tech_flutter/service/NavigationService.dart';
import 'package:flutter/material.dart';
import '../../commonComponents/ImageFile.dart';

class HomeBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  HomeBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped
  });

  @override
  State<HomeBottomNavigationBar> createState() => _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  NavigationService navigationService = NavigationService();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 95,
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: double.infinity,
                height: 85,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, -1)
                      )
                    ]
                ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        navigationIconButton(ImageFile.homeIcon,0),
                        navigationIconButton(ImageFile.calenderIcon,1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Material(
              color: ColorConstraints.bottomButtonColor,
              elevation: 4,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  navigationService.navigateToDescription(context);
                },
                child: Container(
                  width: 67,
                  height: 67,
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(
                    ImageFile.createDiary,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget navigationIconButton(String imagePath, int index){
    final isSelected = index == widget.selectedIndex;

    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 50,
        height: 50,
        child: InkWell(
          onTap: () {
            widget.onItemTapped(index);
          },
          borderRadius: BorderRadius.circular(24.0),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              color: Colors.transparent,
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 30,
                height: 30,
                fit: BoxFit.fill,
                color: isSelected
                    ? ColorConstraints.navigationButtonColor
                    : Colors.black
              ),
            ),
          ),
        ),
      ),
    );
  }
}