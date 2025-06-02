// favorite_notices_page.dart
import 'package:flutter/material.dart';
import 'services/notice_data.dart';
import 'models/notice.dart';

class FavoriteNoticesPage extends StatefulWidget {
  const FavoriteNoticesPage({super.key});

  @override
  State<FavoriteNoticesPage> createState() => _FavoriteNoticesPageState();
}

class _FavoriteNoticesPageState extends State<FavoriteNoticesPage> {
  @override
  void initState() {
    super.initState();
    FavoriteNotices.loadFavorites().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final List<Notice> favoriteItems = FavoriteNotices.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('관심 공지 편집'),
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
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () async {
                          await FavoriteNotices.remove(notice);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
