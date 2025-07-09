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
            opacity: 0.3,
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
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _availableCategories.length,
        itemBuilder: (context, index) {
          final category = _availableCategories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedCategory = category),
              backgroundColor: const Color(0xFFF0E6D6),
              selectedColor: const Color(0xFF8B0000),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF5C3A21),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFD9C7B8)),
              ),
            ),
          );
        },
      ),
    );
  }
}