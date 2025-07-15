import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/art_items.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';


class ArtDetailPage extends StatelessWidget {
  final ArtItem item;

  const ArtDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(item.title),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF8B0000),
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w300,
          color: Colors.white,
          letterSpacing: 1,
          fontFamily: 'Serif',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(_buildFullImageRoute(item.fullImagePath)),
              child: Hero(
                tag: item.id,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(255, 255, 255, 0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AspectRatio(
                      aspectRatio: 1, // 替代固定 300x300
                      child: Image.asset(
                        item.thumbnailPath,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 60),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFF5C3A21),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${item.dynasty} • ${item.category}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Artist: ${item.artist}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Route _buildFullImageRoute(String imagePath) {
    return PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        final TransformationController _transformationController = TransformationController();

        Widget viewer = Hero(
          tag: item.id,
          child: InteractiveViewer(
            transformationController: _transformationController,
            panEnabled: true,
            minScale: 1,
            maxScale: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );

        // 桌面平台加 Listener 来处理鼠标滚轮缩放
        if (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.windows) {
          viewer = Listener(
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                final zoom = event.scrollDelta.dy > 0 ? 0.9 : 1.1;
                final matrix = _transformationController.value.clone()
                  ..scale(zoom);
                _transformationController.value = matrix;
              }
            },
            child: viewer,
          );
        }

        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.5),
            body: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
                Center(child: viewer),
              ],
            ),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

