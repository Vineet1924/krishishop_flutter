import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:krishishop/SplashScreen.dart';
import 'package:krishishop/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.blue,
            onPrimary: Colors.blue,
            secondary: Colors.blue,
            onSecondary: Colors.blue,
            error: Colors.red,
            onError: Colors.red,
            background: Colors.grey.shade300,
            onBackground: Colors.grey.shade300,
            surface: Colors.grey.shade900,
            onSurface: Colors.grey.shade900),
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
