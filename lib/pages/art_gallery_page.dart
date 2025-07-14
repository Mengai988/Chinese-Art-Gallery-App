import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/art_items.dart';
import '../widgets/art_card.dart';

class ArtGalleryPage extends StatefulWidget {
  const ArtGalleryPage({super.key});

  @override
  State<ArtGalleryPage> createState() => _ArtGalleryPageState();
}

class _ArtGalleryPageState extends State<ArtGalleryPage> {
  String _selectedCategory = 'All';

  List<String> get _availableCategories => [
        'All',
        ...{for (final item in artCollection) item.category},
      ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedCategory == 'All'
        ? artCollection
        : artCollection.where((item) => item.category == _selectedCategory).toList();

    // Determine columns based on platform
    final crossAxisCount = kIsWeb ? 4 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chinese Art Gallery'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/others/rice_paper_texture.jpg'),
            fit: BoxFit.cover,
            opacity: 0.7,
          ),
        ),
        child: Column(
          children: [
            _buildCategoryFilter(),
            const Divider(height: 1, color: Color(0xFFD9C7B8)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return ArtCard(item: filteredItems[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 1.5),
    child: Center(
      child: Wrap( // Wrap 自动换行，居中布局比 ListView 更适合少量按钮
        alignment: WrapAlignment.center,
        spacing: 8, // 按钮之间的间距
          children: _availableCategories.map((category) {
            final isSelected = _selectedCategory == category;

            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF8B0000) : const Color(0xFFF0E6D6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD9C7B8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF5C3A21),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.check, color: Colors.white, size: 18),
                    ]
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}