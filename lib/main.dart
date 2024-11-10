import 'package:dream_tech_flutter/components/LoginScreen/LoginScreen.dart';
import 'package:dream_tech_flutter/components/main/mainViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'commonComponents/TextConstraints.dart';
import 'firebase_options.dart';
import 'components/HomeScreen/HomeScreen.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await initializeDateFormatting("ja_JP").then(
        (_) {
          runApp(MyApp());
    },
  );
}

class MyApp extends StatelessWidget {
  final viewModel = Get.put(MainViewModel());
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: TextConstraints.title,
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      home: Obx(() => viewModel.user == null ? LoginScreen() : const HomeScreen()),
    );
  }
}
