import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../commonComponents/TextConstraints.dart';
import '../SettingScreen/SettingViewModel.dart';

class LogoutDialog {
  static void logoutDialog(BuildContext context,SettingViewModel viewModel) {

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
}