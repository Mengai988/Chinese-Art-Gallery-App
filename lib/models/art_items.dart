class ArtItem {
  final String id;
  final String title;
  final String thumbnailPath; // 缩略图
  final String fullImagePath; // 大图
  final String category;
  final String dynasty;
  final String description;
  final String artist;

  const ArtItem({
    required this.id,
    required this.title,
    required this.thumbnailPath,
    required this.fullImagePath,
    required this.category,
    required this.dynasty,
    required this.description,
    required this.artist,
  });
}


final List<ArtItem> artCollection = [
  ArtItem(
    id: 'p1',
    title: 'Travelers Among Mountains and Streams',
    thumbnailPath: 'assets/images/paintings/fan_kuan01_01.jpg',
    fullImagePath: 'assets/images/paintings/fan_kuan01_02.jpg',    
    category: 'Painting',
    dynasty: 'Northern Song Dynasty',
    artist: 'Fan Kuan',
    description: 'This monumental hanging scroll exemplifies the '
        'Northern Song landscape style with its towering central '
        'mountain peak and meticulous detail of nature.',
  ),
  ArtItem(
    id: 'c1',
    title: 'Orchid Pavilion Preface',
    thumbnailPath: 'assets/images/calligraphies/feng_chengsu01_01.jpg',
    fullImagePath: 'assets/images/calligraphies/feng_chengsu01_02.jpg',
    category: 'Calligraphy',
    dynasty: 'Tang Dynasty Copy',
    artist: 'Wang Xizhi (copied by Feng Chengsu)',
    description: 'The most famous work of Chinese calligraphy, '
        'written in 353 CE. This Tang dynasty copy preserves '
        'Wang Xizhi\'s flowing semi-cursive script style.',
  ),
  // Add more artworks here
];
