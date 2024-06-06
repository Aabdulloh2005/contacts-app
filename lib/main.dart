import 'package:contact_app/views/screens/contact_screen.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MainRunner());
}

class MainRunner extends StatelessWidget {
  const MainRunner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.dark,
      home: ContactScreen(),
    );
  }
}
