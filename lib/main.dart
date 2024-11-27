import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foldit/controllers/folderProvider.dart';
import 'package:foldit/controllers/pagesProvider.dart';
import 'package:foldit/screens/home_screen.dart';
import 'controllers/titleProvider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TitleProvider()),
      ChangeNotifierProvider(create: (_) => FolderProvider()),
      ChangeNotifierProvider(create: (_) => PagesProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
