import 'package:dream_tech_flutter/commonComponents/TextConstraints.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginViewmodel extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final RxString signInEmail = "".obs;
  final RxBool signInEmailIsError = false.obs;
  final RxString signInEmailErrorText = "".obs;
  final RxString signInPassword = "".obs;
  final RxBool signInPasswordIsError = false.obs;
  final RxString signInPasswordErrorText = "".obs;
  final RxString signInPasswordConfirmation = "".obs;
  final RxBool signInPasswordConfirmationIsError = false.obs;
  final RxString signInPasswordConfirmationErrorText = "".obs;
  final RxString loginEmail = "".obs;
  final RxBool loginEmailIsError = false.obs;
  final RxString loginEmailErrorText = "".obs;
  final RxString loginPassword = "".obs;
  final RxBool loginPasswordIsError = false.obs;
  final RxString loginPasswordErrorText = "".obs;
  final RxString forSendingEmail = "".obs;
  final RxBool forSendingEmailIsError = false.obs;
  final RxString forSendingErrorText = "".obs;
  final RxInt currentScreen = 0.obs; // 0: Login, 1: SignUp, 2: Confirm
  final RxDouble containerHeight = 380.0.obs;
  final RxDouble containerWidth = 500.0.obs;

  void setSignInEmail(String value) => signInEmail.value = value;
  void setSignInPassword(String value) => signInPassword.value = value;
  void setSignInPasswordConfirmation(String value) => signInPasswordConfirmation.value = value;
  void setLoginEmail(String value) => loginEmail.value = value;
  void setLoginPassword(String value) => loginPassword.value = value;
  void setForSendingEmail(String value) => forSendingEmail.value = value;
  void resetAllFields() {
    // すべてのフィールドをリセット
    signInEmail.value = '';
    signInPassword.value = '';
    signInPasswordConfirmation.value = '';
    loginEmail.value = '';
    loginPassword.value = '';
    forSendingEmail.value = '';
    // エラー状態もリセット
    signInEmailIsError.value = false;
    signInPasswordIsError.value = false;
    signInPasswordConfirmationIsError.value = false;
    loginEmailIsError.value = false;
    loginPasswordIsError.value = false;
    forSendingEmailIsError.value = false;
    // エラーメッセージもクリア
    signInEmailErrorText.value = '';
    signInPasswordErrorText.value = '';
    signInPasswordConfirmationErrorText.value = '';
    loginEmailErrorText.value = '';
    loginPasswordErrorText.value = '';
    forSendingErrorText.value = '';
  }
  void resetSignUpFields() {
    signInEmail.value = '';
    signInPassword.value = '';
    signInPasswordConfirmation.value = '';
    signInEmailIsError.value = false;
    signInPasswordIsError.value = false;
    signInPasswordConfirmationIsError.value = false;
    signInEmailErrorText.value = '';
    signInPasswordErrorText.value = '';
    signInPasswordConfirmationErrorText.value = '';
  }
  void resetLoginFields() {
    loginEmail.value = '';
    loginPassword.value = '';
    loginEmailIsError.value = false;
    loginPasswordIsError.value = false;
    loginEmailErrorText.value = '';
    loginPasswordErrorText.value = '';
  }
  void resetPasswordResetFields() {
    forSendingEmail.value = '';
    forSendingEmailIsError.value = false;
    forSendingErrorText.value = '';
  }

  void toggleScreen(int screen) {
    currentScreen.value = screen;
    switch (screen) {
      case 0:
        containerHeight.value = 380.0;
        containerWidth.value = 500.0;
        break;
      case 1:
        // SignInScreenに遷移時に値を初期化
        resetAllFields();
        break;
      case 2:
        containerHeight.value = 380.0;
        containerWidth.value = 500.0;
        break;
      case 3:
        // loginScreenに遷移時に値を初期化
        resetLoginFields();
      case 4:
        resetLoginFields();
        resetPasswordResetFields();
        break;
      default:
        containerHeight.value = 380.0;
        containerWidth.value = 500.0;
        resetAllFields();
    }
  }

  Future<void> checkSignup(BuildContext context) async {
    try {
      if(signInEmail.value.isEmpty){
        signInEmailIsError.value = true;
        signInEmailErrorText.value = TextConstraints.errorEmailText;
      }else{
        signInEmailIsError.value = false;
        signInEmailErrorText.value = "";
      }
      if(signInPassword.value.isEmpty){
        signInPasswordIsError.value = true;
        signInPasswordErrorText.value = TextConstraints.errorPasswordText;
      }else{
        signInPasswordIsError.value = false;
        signInPasswordErrorText.value = "";
      }
      if(signInPasswordConfirmation.isEmpty){
        signInPasswordConfirmationIsError.value = true;
        signInPasswordConfirmationErrorText.value = TextConstraints.errorPasswordConfirmationText;
      }else{
        signInPasswordConfirmationIsError.value = false;
        signInPasswordConfirmationErrorText.value = "";
      }
      if (signInPassword.value.isNotEmpty && signInPasswordConfirmation.value.isNotEmpty) {
        if (signInPassword.value != signInPasswordConfirmation.value) {
          signInPasswordConfirmationIsError.value = true;
          signInPasswordConfirmationErrorText.value = TextConstraints.errorPasswordConfirmationText;
        } else {
          signInPasswordConfirmationIsError.value = false;
          signInPasswordConfirmationErrorText.value = "";
        }
      }
      if(signInEmail.value.isEmpty || signInPassword.value.isEmpty || signInPasswordConfirmation.value.isEmpty){
        return;
      }
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: signInEmail.value,
          password: signInPassword.value
      );
      toggleScreen(0);

      print("User signed up successfully: ${userCredential.user?.uid}");
    } on FirebaseAuthMultiFactorException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
        // メールアドレスにエラーを設定
          signInEmailIsError.value = true;
          signInEmailErrorText.value = TextConstraints.emailAlreadyInUse;
          break;
        case 'invalid-email':
        // メールアドレスにエラーを設定
          signInEmailIsError.value = true;
          signInEmailErrorText.value = TextConstraints.invalidEmail;
          break;
        case 'weak-password':
        // パスワードにエラーを設定
          signInPasswordIsError.value = true;
          signInPasswordErrorText.value = TextConstraints.errorPasswordText;
          break;
        case 'operation-not-allowed':
        // スナックバーを表示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(TextConstraints.notAllowed),
              behavior: SnackBarBehavior.fixed,
            ),
          );
          break;
        case 'too-many-requests':
        // スナックバーを表示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(TextConstraints.tooManyRequests),
              behavior: SnackBarBehavior.fixed,
            ),
          );
          break;
        default:
        // スナックバーを表示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(TextConstraints.failureCreation),
              behavior: SnackBarBehavior.fixed,
            ),
          );
      }
    } catch (e) {
      print('Unexpected error: $e');
      // スナックバーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(TextConstraints.unexpectedError),
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }

  Future<void> checkLogin(BuildContext context) async {
    try {
      if(loginEmail.value.isEmpty){
        loginEmailIsError.value = true;
        loginEmailErrorText.value = TextConstraints.errorEmailText;
      } else {
        loginEmailIsError.value = false;
        loginEmailErrorText.value = "";
      }

      if(loginPassword.value.isEmpty){
        loginPasswordIsError.value = true;
        loginPasswordErrorText.value = TextConstraints.errorPasswordText;
      } else {
        loginPasswordIsError.value = false;
        loginPasswordErrorText.value = "";
      }

      if(loginEmail.value.isEmpty || loginPassword.value.isEmpty){
        return;
      }

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: loginEmail.value,
          password: loginPassword.value
      );
      toggleScreen(0);
      print("User logged in successfully: ${userCredential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      print('Login failed: ${e.code}');

      switch (e.code) {
        case 'invalid-email':
        // メールアドレスにエラーを設定
          loginEmailIsError.value = true;
          loginEmailErrorText.value = TextConstraints.invalidEmail;
          break;
        case 'user-disabled':
        // メールアドレスにエラーを設定
          loginEmailIsError.value = true;
          loginEmailErrorText.value = TextConstraints.invalidAccount;
          break;
        case 'user-not-found':
        // メールアドレスにエラーを設定
          loginEmailIsError.value = true;
          loginEmailErrorText.value = TextConstraints.accountNotFound;
          break;
        case 'wrong-password':
          // パスワードにエラーを設定
          loginPasswordIsError.value = true;
          loginPasswordErrorText.value = TextConstraints.wrongPassword;
          break;
        case 'invalid-credential':
        // メールアドレスとパスワードの両方にエラーを設定
          loginEmailIsError.value = true;
          loginPasswordIsError.value = true;
          loginEmailErrorText.value = TextConstraints.wrongPasswordOrEmail;
          loginPasswordErrorText.value = TextConstraints.wrongPasswordOrEmail;
          break;
        case 'too-many-requests':
        // スナックバーを表示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(TextConstraints.tooManyRequests),
              behavior: SnackBarBehavior.fixed,
            ),
          );
          break;
        default:
        // スナックバーを表示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(TextConstraints.failureCreation),
              behavior: SnackBarBehavior.fixed,
            ),
          );
      }
    } catch (e) {
      print('Unexpected error: $e');
      // スナックバーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(TextConstraints.unexpectedError),
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    try{
      if(forSendingEmail.value.isEmpty){
        forSendingEmailIsError.value = true;
        forSendingErrorText.value = TextConstraints.errorEmailText;
        return;
      }else{
        forSendingEmailIsError.value = false;
        forSendingErrorText.value = "";
      }
      await auth.sendPasswordResetEmail(email: forSendingEmail.trim());
      toggleScreen(2);
    }on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'invalid-email':
          forSendingEmailIsError.value = true;
          forSendingErrorText.value = TextConstraints.invalidEmail;
        case 'user-not-found':
          forSendingEmailIsError.value = true;
          forSendingErrorText.value = TextConstraints.accountNotFound;
        case 'operation-not-allowed':
          forSendingEmailIsError.value = true;
          forSendingErrorText.value = TextConstraints.passwordResetNotAllowed;
        case 'user-disabled':
          forSendingEmailIsError.value = true;
          forSendingErrorText.value = TextConstraints.disableAccount;
        case 'missing-email':
          forSendingEmailIsError.value = true;
          forSendingErrorText.value = TextConstraints.invalidEmail;
        case 'too-many-requests':
        // スナックバーを表示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(TextConstraints.unexpectedError),
              behavior: SnackBarBehavior.fixed,
            ),
          );
        default:
        // スナックバーを表示
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(TextConstraints.failureSendForEmail),
              behavior: SnackBarBehavior.fixed,
            ),
          );
      }
    } catch (e) {
      print('Unexpected error: $e');
      // スナックバーを表示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(TextConstraints.unexpectedError),
          behavior: SnackBarBehavior.fixed,
        ),
      );
    }
  }
}