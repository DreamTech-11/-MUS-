import 'package:dream_tech_flutter/components/LoginScreen/LoginViewModel.dart';
import 'package:dream_tech_flutter/commonComponents/ColorConstraints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../commonComponents/FontFamily.dart';
import '../../commonComponents/ImageFile.dart';
import '../../commonComponents/TextConstraints.dart';

class LoginScreen extends StatelessWidget{
  final LoginViewmodel viewModel = Get.put(LoginViewmodel());

  @override
  Widget build (BuildContext context) {
    return  Scaffold(
      body: GestureDetector(
        onTap: (){
          primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            // 背景のグラデーション
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorConstraints.backgroundGradientTop,
                      ColorConstraints.backgroundGradientBottom,
                    ],
                  )
              ),
            ),
            Positioned(
              top: -30,
              child: Opacity(
                opacity: 0.2,
                child: Image.asset(
                  ImageFile.backgroundStars,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: -20,
              child: Image.asset(
                ImageFile.backgroundLeftCloud,
                width: 250,
              ),
            ),
            Positioned(
              left: 0,
              bottom: -20,
              child: Image.asset(
                ImageFile.backgroundRightCloud ,
                width: 250,
              ),
            ),
            Obx(() {
              return _currentScreen(context);
            }),
          ],
        ),
      )
    );
  }

  Widget _currentScreen(BuildContext context) {
    switch (viewModel.currentScreen.value) {
      case 0:
        return loginHomeScreen(context);
      case 1:
        return signInScreen(context);
      case 2:
        return confirmScreen(context);
      case 3:
        return loginScreen(context);
      case 4:
        return resetPasswordScreen(context);
      default:
        return loginHomeScreen(context);
    }
  }

  Widget loginHomeScreen(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: viewModel.containerWidth.value,
            height: viewModel.containerHeight.value,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        TextConstraints.appTitle,
                        style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontFamily.Aclonica
                        ),
                      ),
                    ),
                    bottomButton(
                      topPadding: 150,
                        buttonColor: ColorConstraints.bottomButtonColor,
                        textColor: Colors.white,
                        buttonWidth: 162,
                        buttonHeight: 46,
                        buttonText: TextConstraints.loginText,
                        toggleFunction: () => viewModel.toggleScreen(3)
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: TextButton(
                            onPressed: () => viewModel.toggleScreen(1),
                            child: const Text(
                              TextConstraints.createAccountText,
                              style: TextStyle(
                                  color: ColorConstraints.bottomTextButtonColor,
                                  fontSize: 17,
                                  fontFamily: FontFamily.NotoSansJP,
                                  fontWeight: FontWeight.normal
                              ),
                            )
                        )
                    )
                  ],
                )
            ),
          )),
            Positioned(
              top: -160,
              left: -50,
              right: 30,
              child: Container(
                width: 300,
                height: 300,
                color: Colors.transparent,
                child: Lottie.asset(
                  ImageFile.sleepingCat,
                  width: 300,
                  height: 300,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget signInScreen(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 15,
                      bottom: 15 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            loginTextField(
                                title: TextConstraints.mailAddressText,
                                subtitle: TextConstraints.mailAddressSubtitleText,
                                hintText: TextConstraints.mailAddressHintText,
                                onChanged: viewModel.setSignInEmail,
                                isPassword: false,
                                isError: viewModel.signInEmailIsError,
                                errorText: viewModel.signInEmailErrorText
                            ),
                            loginTextField(
                                title: TextConstraints.passwordText,
                                subtitle: TextConstraints.passwordSubtitleText,
                                hintText: TextConstraints.passwordHintText,
                                onChanged: viewModel.setSignInPassword,
                                isPassword: true,
                                isError: viewModel.signInPasswordIsError,
                                errorText: viewModel.signInPasswordErrorText
                            ),
                            loginTextField(
                                title: TextConstraints.passwordConfirmationText,
                                subtitle: TextConstraints.passwordSubtitleText,
                                hintText: TextConstraints.passwordHintText,
                                onChanged: viewModel.setSignInPasswordConfirmation,
                                isPassword: true,
                                isError: viewModel.signInPasswordConfirmationIsError,
                                errorText: viewModel.signInPasswordConfirmationErrorText
                            ),

                            const SizedBox(height: 35),
                            bottomButton(
                                buttonColor: ColorConstraints.bottomButtonColor,
                                textColor: Colors.white,
                                buttonWidth: 290,
                                buttonHeight: 40,
                                buttonText: TextConstraints.nextText,
                                toggleFunction: () => viewModel.checkSignup(context)
                            ),
                            bottomButton(
                                topPadding: 15,
                                buttonWidth: 290,
                                buttonHeight: 40,
                                buttonColor: ColorConstraints.greyBottomButtonColor,
                                buttonText: TextConstraints.returnText,
                                textColor: ColorConstraints.greyBottomTextButtonColor,
                                toggleFunction: () => viewModel.toggleScreen(0)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget confirmScreen(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height
          ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 40,
                        right: 40,
                        top: 15,
                        bottom: 15 + MediaQuery.of(context).viewInsets.bottom
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  TextConstraints.sendAuthenticationEmailText,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: FontFamily.NotoSansJP,
                                      fontWeight: FontWeight.w600
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height:20),
                              Container(
                                constraints: const BoxConstraints(maxWidth: 200, maxHeight: 200),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.asset(
                                    ImageFile.sendMessage,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height:20),
                              bottomButton(
                                  topPadding: 15,
                                  buttonColor: ColorConstraints.bottomButtonColor,
                                  textColor: Colors.white,
                                  buttonWidth: 290,
                                  buttonHeight: 40,
                                  buttonText: TextConstraints.returnText,
                                  toggleFunction: () => viewModel.toggleScreen(0)
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget loginScreen(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 15,
                      bottom: 15 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            loginTextField(
                                title: TextConstraints.mailAddressText,
                                subtitle: TextConstraints.mailAddressSubtitleText,
                                hintText: TextConstraints.mailAddressHintText,
                                onChanged: viewModel.setLoginEmail,
                                isPassword: false,
                                isError: viewModel.loginEmailIsError,
                                errorText: viewModel.loginEmailErrorText
                            ),
                            loginTextField(
                                title: TextConstraints.passwordText,
                                subtitle: TextConstraints.passwordSubtitleText,
                                hintText: TextConstraints.passwordHintText,
                                onChanged: viewModel.setLoginPassword,
                                isPassword: true,
                                isError: viewModel.loginPasswordIsError,
                                errorText: viewModel.loginPasswordErrorText
                            ),
                            const SizedBox(height: 10),
                            forgetPasswordButton(
                                toggleFunction: () => viewModel.toggleScreen(4)
                            ),
                            const SizedBox(height: 35),
                            bottomButton(
                                buttonColor: ColorConstraints.bottomButtonColor,
                                textColor: Colors.white,
                                buttonWidth: 290,
                                buttonHeight: 40,
                                buttonText: TextConstraints.nextText,
                                toggleFunction: () => viewModel.checkLogin(context)
                            ),
                            bottomButton(
                                topPadding: 15,
                                buttonWidth: 290,
                                buttonHeight: 40,
                                buttonColor: ColorConstraints.greyBottomButtonColor,
                                buttonText: TextConstraints.returnText,
                                textColor: ColorConstraints.greyBottomTextButtonColor,
                                toggleFunction: () => viewModel.toggleScreen(0)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resetPasswordScreen(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                          left: 40,
                          right: 40,
                          top: 15,
                          bottom: MediaQuery.of(context).viewInsets.bottom
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              )
                            ]
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              forgotPasswordTextField(
                                title: TextConstraints.sendForEmail,
                                subtitle: TextConstraints.sendForEmailAddressSubtitleText,
                                hintText: TextConstraints.mailAddressHintText,
                                onChanged: viewModel.setForSendingEmail,
                                isPassword: false,
                                isError: viewModel.forSendingEmailIsError,
                                errorText: viewModel.forSendingErrorText,
                              ),
                              const SizedBox(height: 35),
                              bottomButton(
                                  buttonColor: ColorConstraints.bottomButtonColor,
                                  textColor: Colors.white,
                                  buttonWidth: 290,
                                  buttonHeight: 40,
                                  buttonText: TextConstraints.nextText,
                                  toggleFunction:() => viewModel.forgotPassword(context)
                              ),
                              bottomButton(
                                  topPadding: 15,
                                  buttonWidth: 290,
                                  buttonHeight: 40,
                                  buttonColor: ColorConstraints.greyBottomButtonColor,
                                  buttonText: TextConstraints.returnText,
                                  textColor: ColorConstraints.greyBottomTextButtonColor,
                                  toggleFunction: () => viewModel.toggleScreen(3)
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget forgetPasswordButton({
    required void Function() toggleFunction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: ColorConstraints.bottomTextButtonColor,
                    width: 1
                )
            )
        ),
        child: Center(
          child: TextButton(
            onPressed: (){
              toggleFunction();
            },
            child: const Text(
              TextConstraints.forgotPassword,
              style: TextStyle(
                color: ColorConstraints.bottomButtonColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginTextField({
    required String title,
    required String subtitle,
    required String hintText,
    required Function(String) onChanged,
    required bool isPassword,
    required RxBool isError,
    required RxString errorText
  }) {

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        child: IgnorePointer(
          ignoring: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 22,
                    fontFamily: FontFamily.NotoSansJP,
                    fontWeight: FontWeight.w800
                ),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              Obx(() =>  Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  onChanged: onChanged,
                  obscureText: isPassword,
                  decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                      errorText: isError.value ? errorText.value : null,
                      errorMaxLines: 2,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1
                          )
                      ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1
                        )
                    )
                  ),
                ),
              ))
            ],
          ),
        )
    );
  }

  Widget forgotPasswordTextField({
    required String title,
    required String subtitle,
    required String hintText,
    required Function(String) onChanged,
    required bool isPassword,
    required RxBool isError,
    required RxString errorText
  }) {

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
        child: IgnorePointer(
          ignoring: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 22,
                    fontFamily: FontFamily.NotoSansJP,
                    fontWeight: FontWeight.w800
                ),
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextField(
                  onChanged: onChanged,
                  obscureText: isPassword,
                  decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: const TextStyle(color: Colors.grey),
                      errorText: isError.value ? errorText.value : null,
                      errorMaxLines: 2,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1
                          )
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1
                          )
                      )
                  ),
                ),
              )            ],
          ),
        )
    );
  }

  Widget bottomButton({
    double topPadding = 0,
    double bottomPadding = 0,
    double leftPadding = 0,
    double rightPadding = 0,
    required Color buttonColor,
    required Color textColor,
    required double buttonWidth,
    required double buttonHeight,
    required String buttonText,
    required void Function() toggleFunction,
}) {
    return Padding(
      padding: EdgeInsets.only(
          top: topPadding,
          bottom: bottomPadding,
          left: leftPadding,
          right: rightPadding
      ),
      child: Align(
        alignment: Alignment.center,
        child: Material(
            borderRadius: BorderRadius.circular(30),
            color:  buttonColor,
            child: InkWell(
              onTap: toggleFunction,
              borderRadius: BorderRadius.circular(30),
              child:  SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: Center(
                    child: Text(
                      buttonText,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 17,
                          fontFamily: FontFamily.NotoSansJP,
                          fontWeight: FontWeight.bold
                      ),
                    )
                ),
              ),
            )
        ),
      )
    );
  }
}