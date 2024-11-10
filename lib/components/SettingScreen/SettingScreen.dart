import 'package:dream_tech_flutter/commonComponents/TextConstraints.dart';
import 'package:dream_tech_flutter/components/SettingScreen/SettingViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      appBar: AppBar(
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
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: (){
                    viewModel.navigateContactForm();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.contact_support_rounded,
                          size: 30,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            TextConstraints.contactFormText,
                            style: TextStyle(
                                fontFamily: FontFamily.NotoSansJP,
                                fontWeight: FontWeight.w400,
                                fontSize: 17
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
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

              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: (){
                    logOutDialog(context,viewModel);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22,vertical: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 30,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            TextConstraints.logout,
                            style: TextStyle(
                                fontFamily: FontFamily.NotoSansJP,
                                fontWeight: FontWeight.w400,
                                fontSize: 17
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded)
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

void logOutDialog(BuildContext context,SettingViewModel viewModel) {

  showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text(TextConstraints.logout),
          content: const Text(TextConstraints.confirmLogout),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              child: const  Text(
                TextConstraints.cancel,
                style: TextStyle(
                    color: Colors.blue
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text(
                TextConstraints.confirm,
                style: TextStyle(
                    color: Colors.red
                ),
              ),
              onPressed: () {
                viewModel.signOut(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
  );
}