import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unsolved_qb/screens/addData.dart';
import 'package:unsolved_qb/screens/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unsolved_qb/screens/pdfViewScreen.dart';
import 'package:unsolved_qb/utils/colors.dart';
import 'package:unsolved_qb/utils/globalData.dart';

// void main() {
//   runApp(const MyApp());
// }

Future main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    statusBarColor: backgroundColor,
    systemStatusBarContrastEnforced: true,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unsolved QB',
      initialRoute: "home_screen",
      routes: {
        // "PDF_view_screen": (context) => (pdfViewScreen(pdfName: "",)),
        "home_screen": (context) => (homeScreen()),
        "add_data": (context) => const addData(),
      },
    );
  }
}
