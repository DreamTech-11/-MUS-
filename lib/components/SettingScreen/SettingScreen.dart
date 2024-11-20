import 'package:dream_tech_flutter/commonComponents/TextConstraints.dart';
import 'package:dream_tech_flutter/components/SettingScreen/SettingViewModel.dart';
import 'package:dream_tech_flutter/components/dialog/deleteAccountConfirmDialog.dart';
import 'package:dream_tech_flutter/components/dialog/logoutDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../commonComponents/FontFamily.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  final Function(int) onItemTapped;
  final SettingViewModel viewModel = Get.put(SettingViewModel());
  SettingScreen({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: settingScreenAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              settingScreenItems(
                  onTapItem: () => viewModel.navigateContactForm(),
                  itemIcon: const Icon(
                    Icons.contact_support_rounded,
                    size: 30,
                    color: Colors.grey,
                  ),
                  itemText: TextConstraints.contactFormText
              ),
              settingScreenItems(
                  onTapItem: () => LogoutDialog.logoutDialog(context,viewModel),
                  itemIcon: const Icon(
                    Icons.logout_rounded,
                    size: 30,
                    color: Colors.grey,
                  ),
                  itemText: TextConstraints.logout
              ),
              settingScreenItems(
                  onTapItem: (){
                    DeleteAccountDialog.showDeleteAccountConfirmDialog(
                        context: context,
                        viewModel: viewModel
                    );
                  },
                  itemIcon: const Icon(
                    Icons.no_accounts,
                    size: 30,
                    color: Colors.grey,
                  ),
                  itemText: TextConstraints.deleteAccountConfirmDialogTitleText,
                textColor: CupertinoColors.destructiveRed
              )
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget settingScreenAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () =>onItemTapped(0),
          icon: const Icon(Icons.arrow_back_ios_new)
      ),
      title: const Text(
        TextConstraints.setting,
        style: TextStyle(
          fontFamily: FontFamily.NotoSansJP,
          fontWeight: FontWeight.w600,
          fontSize: 22,
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

  Widget settingScreenItems({
    required Function() onTapItem,
    required Icon itemIcon,
    required String itemText,
    Color textColor = Colors.black,
  }) {
    return Column(
      children: [
        Material(
            color: Colors.white,
            child: InkWell(
              onTap: (){
                onTapItem();
              },
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    itemIcon,
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        itemText,
                        style: TextStyle(
                            fontFamily: FontFamily.NotoSansJP,
                            fontWeight: FontWeight.w400,
                            fontSize: 17,
                            color: textColor
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            )
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 2,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}