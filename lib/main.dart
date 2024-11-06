import 'package:face_recognization/features/agora/view/choose_role.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Agora Video Call",
      debugShowCheckedModeBanner: false,
      home: RoleSelectionScreen(),
    );
  }
}
