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
                  constraints: const BoxConstraints(
                    maxHeight: 300,
                    maxWidth: double.infinity,
                  ),
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
                    child: Image.asset(
                      item.thumbnailPath,
                      fit: BoxFit.contain,
                      width: double.infinity,
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
        final transformationController = TransformationController();
        final focusNode = FocusNode();
        Offset? lastFocalPoint;

        Widget viewer = Hero(
          tag: item.id,
          child: InteractiveViewer(
            transformationController: transformationController,
            panEnabled: true,
            minScale: 1,
            maxScale: 5,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            onInteractionStart: (details) {
              if (details.pointerCount > 1) {
                lastFocalPoint = null;
              } else {
                lastFocalPoint = details.focalPoint;
              }
            },
            onInteractionUpdate: (details) {
              if (details.pointerCount > 1) {
                return;
              }
              
              if (lastFocalPoint != null && details.scale != 1.0) {
                // Convert Vector3 translation to Offset
                final translation = transformationController.value.getTranslation();
                final translationOffset = Offset(translation.x, translation.y);
                
                // Calculate the focal point in the coordinate space of the image
                final offset = (lastFocalPoint! - translationOffset) / 
                            transformationController.value.getMaxScaleOnAxis();
                
                // Apply the scale centered on the focal point
                final newMatrix = Matrix4.identity()
                  ..translate(offset.dx, offset.dy)
                  ..scale(details.scale)
                  ..translate(-offset.dx, -offset.dy)
                  ..multiply(transformationController.value);
                
                transformationController.value = newMatrix;
              }
            },
            child: SizedBox.expand(
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

        // Desktop platform mouse wheel zoom handling
        if (defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.windows) {
          viewer = Listener(
            onPointerSignal: (event) {
              if (event is PointerScrollEvent) {
                // 根据滚动方向设定缩放比例
                double scaleDelta = event.scrollDelta.dy > 0 ? 0.9 : 1.1;

                final currentScale = transformationController.value.getMaxScaleOnAxis();
                final newScale = currentScale * scaleDelta;

                // 设置最小和最大缩放比例
                const minScale = 1.0;
                const maxScale = 5.0;

                // 如果已经达到极限，则不再缩放
                if ((newScale < minScale && scaleDelta < 1) ||
                    (newScale > maxScale && scaleDelta > 1)) {
                  return;
                }

                final renderBox = context.findRenderObject() as RenderBox?;
                if (renderBox == null) return;

                final offset = renderBox.globalToLocal(event.position);

                final translation = transformationController.value.getTranslation();
                final translationOffset = Offset(translation.x, translation.y);

                final imageOffset = (offset - translationOffset) /
                    transformationController.value.getMaxScaleOnAxis();

                final newMatrix = Matrix4.identity()
                  ..translate(imageOffset.dx, imageOffset.dy)
                  ..scale(scaleDelta)
                  ..translate(-imageOffset.dx, -imageOffset.dy)
                  ..multiply(transformationController.value);

                transformationController.value = newMatrix;
              }
            },
            child: viewer,
          );
        }

        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Color.lerp(Colors.black, Colors.black, 0.9)!, // Replaced withOpacity with lerp
            body: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black87, Colors.black],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Focus(
                    focusNode: focusNode,
                    child: viewer,
                  ),
                ),
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