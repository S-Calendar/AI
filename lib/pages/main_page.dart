// main_page.dart
import 'package:flutter/material.dart';
import '../widgets/custom_calendar.dart';
import '../models/notice.dart';
import '../services/notice_data.dart';
import '../widgets/notice_modal.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final int baseYear = 2024;
  late final PageController _pageController;
  late int _selectedIndex;
  late int _todayIndex;
  late List<Notice> allNotices = [];

  @override
  void initState() {
    super.initState();
    final DateTime today = DateTime.now();
    _todayIndex = (today.year - baseYear) * 12 + (today.month - 1);
    _selectedIndex = _todayIndex;
    _pageController = PageController(initialPage: _todayIndex);

    _loadNotices();
  }

  Future<void> _loadNotices() async {
    await FavoriteNotices.loadFavorites(); 
    final notices = await NoticeData.loadNoticesFromJson(context);

    for (final n in notices) {
      final matched = FavoriteNotices.favorites.firstWhere(
        (f) => f.title == n.title && f.startDate == n.startDate,
        orElse: () => n,
      );
      n.isHidden = matched.isHidden;
      n.memo = matched.memo;
      n.isFavorite = matched.isFavorite;
    }

    setState(() {
      allNotices = notices.where((n) => !n.isHidden).toList();
    });
  }

  Future<void> _navigateAndRefresh(String routeName) async {
    await Navigator.pushNamed(context, routeName);
    await _loadNotices();
  }

  @override
  Widget build(BuildContext context) {
    final int year = baseYear + (_selectedIndex ~/ 12);
    final int month = (_selectedIndex % 12) + 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 25, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _navigateAndRefresh('/settings'),
                    child: Image.asset('assets/setting_icon.png', width: 32),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = _todayIndex;
                        _pageController.jumpToPage(_todayIndex);
                      });
                    },
                    child: Image.asset('assets/today_icon.png', width: 70),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$month월',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _navigateAndRefresh('/search'),
                    child: Image.asset('assets/search_icon.png', width: 30),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => _navigateAndRefresh('/filter'),
                    child: Image.asset(
                      'assets/colorfilter_icon.png',
                      width: 44,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final year = baseYear + (index ~/ 12);
                  final month = (index % 12) + 1;
                  final currentMonth = DateTime(year, month);

                  return CustomCalendar(
                    month: currentMonth,
                    notices: allNotices,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

