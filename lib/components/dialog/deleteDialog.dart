import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../commonComponents/TextConstraints.dart';

class DeleteDialog {
  static void deleteDialog(BuildContext context,Function onDelete) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text(TextConstraints.deleteTitle),
        content: const Text(TextConstraints.deleteSubTitle),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            child: const Text(
              TextConstraints.cancel,
              style: TextStyle(
                  color: Colors.blue
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              onDelete();
              Navigator.pop(context);
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: const Text(
              TextConstraints.confirm,
              style: TextStyle(
                  color: Colors.red
              ),
            ),
          ),
        ],
      ),
    );
  }
}