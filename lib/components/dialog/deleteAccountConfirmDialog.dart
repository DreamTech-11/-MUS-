import 'package:dream_tech_flutter/components/dialog/deleteDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../commonComponents/FontFamily.dart';
import '../../commonComponents/TextConstraints.dart';
import '../SettingScreen/SettingViewModel.dart';

class DeleteAccountDialog {
  static Future<void> showDeleteAccountConfirmDialog ({
    required BuildContext context,
    required SettingViewModel viewModel,
  }) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => DeleteAccountConfirmDialog(
        viewModel: viewModel,
      ),
    );
  }
}

class DeleteAccountConfirmDialog extends StatelessWidget {
  final SettingViewModel viewModel;
  final TextEditingController _emailController = TextEditingController();
  final ValueNotifier<bool> _hasError = ValueNotifier<bool>(false);

  DeleteAccountConfirmDialog({
    super.key,
    required this.viewModel
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGroupedBackground,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _deleteConfirmDialogTitleAndContent(),
                    _buildDeleteDialogTextFiled(),
                  ],
                ),
              ),
            ),
            _buildDeleteDialogBottomActionButton(context: context),
          ],
        ),
      ),
    );
  }

  Widget _deleteConfirmDialogTitleAndContent() {
    return const Column(
      children: [
        SizedBox(height: 20),
        Text(
          TextConstraints.deleteAccountConfirmDialogTitleText,
          style: TextStyle(
            fontFamily: FontFamily.NotoSansJP,
            fontSize: 20,
            color: CupertinoColors.destructiveRed,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            TextConstraints.deleteAccountConfirmDialogContentText,
            style: TextStyle(
              fontFamily: FontFamily.NotoSansJP,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Text(
          TextConstraints.deleteAccountConfirmDialogCautionText,
          style: TextStyle(
            fontFamily: FontFamily.NotoSansJP,
            fontWeight: FontWeight.w300,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDeleteDialogTextFiled() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  TextConstraints.deleteAccountConfirmDialogCurrentMail,
                  style: TextStyle(
                    fontFamily: FontFamily.NotoSansJP,
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child:
                  Text(
                    viewModel.auth.currentUser?.email ?? "",
                    style: const TextStyle(
                      fontFamily: FontFamily.NotoSansJP,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ValueListenableBuilder<bool>(
            valueListenable: _hasError,
            builder: (context, hasError, child) {
              return Column(
                children: [
                  CupertinoTextField(
                    controller: _emailController,
                    placeholder: TextConstraints
                        .deleteAccountConfirmDialogRequestMail,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hasError
                            ? CupertinoColors.destructiveRed
                            : CupertinoColors.systemGrey3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    style: const TextStyle(
                      fontFamily: FontFamily.NotoSansJP,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  if (hasError)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:  Text(
                          TextConstraints.deleteAccountConfirmDialogErrorText,
                          style: TextStyle(
                            fontFamily: FontFamily.NotoSansJP,
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: CupertinoColors.destructiveRed,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteDialogBottomActionButton({required BuildContext context}) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: CupertinoColors.systemGrey5,
                width: 1,
              ),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      TextConstraints.deleteAccountConfirmDialogCancelText,
                      style: TextStyle(
                          fontFamily: FontFamily.NotoSansJP,
                          color: Colors.blueAccent
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  color: CupertinoColors.systemGrey5,
                ),
                Expanded(
                  child: CupertinoButton(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    onPressed: () {
                      if (_emailController.text.trim() == viewModel.auth.currentUser?.email) {
                        Navigator.of(context).pop();
                        DeleteDialog.deleteDialog(
                            context,
                                () => viewModel.deleteAccount(context)
                        );
                        _hasError.value = false;
                      } else {
                        _hasError.value = true;
                      }
                    },
                    child: const Text(
                      TextConstraints.deleteAccountConfirmDialogDeleteText,
                      style: TextStyle(
                        fontFamily: FontFamily.NotoSansJP,
                        color: CupertinoColors.destructiveRed,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}