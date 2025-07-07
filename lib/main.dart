import 'package:flutter/material.dart';
import 'pages/art_gallery_page.dart';

void main() {
  runApp(const ChineseArtGalleryApp());
}

class ChineseArtGalleryApp extends StatelessWidget {
  const ChineseArtGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chinese Art Gallery',
      debugShowCheckedModeBanner: false, //关闭右上角的“debug”调试标识
      theme: ThemeData(
        primarySwatch: Colors.red,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B0000),
          brightness: Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(8),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF8B0000),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const ArtGalleryPage(),
    );
  }
}
