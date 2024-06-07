import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tarea8_crudfirebase/screens/notas_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotasScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
