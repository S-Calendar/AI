// favorite_notice.dart
import 'package:flutter/material.dart';
import '../models/notice.dart';
import '../services/notice_data.dart';

class FavoriteItemsPage extends StatefulWidget {
  const FavoriteItemsPage({super.key});

  @override
  State<FavoriteItemsPage> createState() => _FavoriteItemsPageState();
}

class _FavoriteItemsPageState extends State<FavoriteItemsPage> {
  List<Notice> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteItems();
  }

  void _loadFavoriteItems() {
    setState(() {
      favoriteItems = FavoriteNotices.favorites;
    });
  }

  Future<void> _removeFromFavorites(Notice notice) async {
    await FavoriteNotices.toggle(notice);
    _loadFavoriteItems();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('관심 공지에서 제거되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관심 공지'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: favoriteItems.isEmpty
          ? const Center(child: Text('관심 공지가 없습니다.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final notice = favoriteItems[index];
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(notice.title)),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeFromFavorites(notice),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
