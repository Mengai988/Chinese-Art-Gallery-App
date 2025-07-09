import 'package:flutter/material.dart';
import 'models/art_items.dart';
import 'pages/art_gallery_page.dart';
import 'pages/art_detail_page.dart';

void main() {
  runApp(const ChineseArtGalleryApp());
}

class ChineseArtGalleryApp extends StatelessWidget {
  const ChineseArtGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chinese Art Gallery',
      debugShowCheckedModeBanner: false,
      theme: _buildThemeData(),
      home: const ArtGalleryPage(),
      routes: {
        '/detail': (context) {
          final item = ModalRoute.of(context)!.settings.arguments as ArtItem;
          return ArtDetailPage(item: item);
        },
      },
    );
  }

  ThemeData _buildThemeData() {
    const Color richRed = Color(0xFF8B0000);
    
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: richRed,
        brightness: Brightness.light,
        primary: richRed,
        secondary: const Color(0xFFD32F2F),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF8B0000),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 1,
          fontFamily: 'Serif',
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}