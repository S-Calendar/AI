// notice_data.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notice.dart';

/// 관심 공지 전역 저장소 (SharedPreferences 연동)
class FavoriteNotices {
  static final List<Notice> _favorites = [];
  
  static List<Notice> get favorites => List.unmodifiable(_favorites);

  static bool contains(Notice notice) => isFavorite(notice);
  
  /// 초기 로드
  static Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('favorite_notices') ?? [];

    _favorites.clear();
    _favorites.addAll(data.map((jsonStr) {
      final map = json.decode(jsonStr);
      return _noticeFromMap(map);
    }));
  }

  /// 저장
  static Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _favorites.map((n) => json.encode(_noticeToMap(n))).toList();
    await prefs.setStringList('favorite_notices', data);
  }

  /// 추가
  static Future<void> add(Notice notice) async {
    if (!_favorites.contains(notice)) {
      notice.isFavorite = true;
      _favorites.add(notice);
      await _saveFavorites();
    }
  }

  /// 제거
  static Future<void> remove(Notice notice) async {
    notice.isFavorite = false;
    _favorites.removeWhere((n) => n.title == notice.title && n.startDate == notice.startDate);
    await _saveFavorites();
  }

  /// 토글
  static Future<void> toggle(Notice notice) async {
    if (isFavorite(notice)) {
      await remove(notice);
    } else {
      await add(notice);
    }
  }

  static bool isFavorite(Notice notice) {
    return _favorites.any((n) => n.title == notice.title && n.startDate == notice.startDate);
  }

  /// Notice → Map
  static Map<String, dynamic> _noticeToMap(Notice n) => {
        'title': n.title,
        'startDate': n.startDate.toIso8601String(),
        'endDate': n.endDate.toIso8601String(),
        'color': n.color.value,
        'url': n.url,
        'memo': n.memo,
        'isHidden': n.isHidden,
      };

  /// Map → Notice
  static Notice _noticeFromMap(Map<String, dynamic> m) => Notice(
        title: m['title'],
        startDate: DateTime.parse(m['startDate']),
        endDate: DateTime.parse(m['endDate']),
        color: Color(m['color']),
        url: m['url'],
        memo: m['memo'],
        isHidden: m['isHidden'] ?? false,
        isFavorite: true,
      );
}

/// JSON 파일에서 Notice 목록 불러오기
class NoticeData {
  static Future<List<Notice>> loadNoticesFromJson(BuildContext context) async {
    final String jsonString = await rootBundle.loadString(
      'assets/임시2_추가_output.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    List<Notice> all = [];

    jsonMap.forEach((category, notices) {
      for (var item in notices) {
        final title = item['제목'] ?? '제목 없음';
        final term = item['신청기간'] ?? item['결과발표일(하는날)'] ?? item['결과발표일'] ?? '';
        final dates = term.split('~').map((s) => s.trim()).toList();

        if (dates.isEmpty || dates.first.isEmpty) continue;

        try {
          final start = DateTime.parse(dates[0].replaceAll('.', '-'));
          final end = (dates.length > 1)
              ? DateTime.parse(dates[1].replaceAll('.', '-'))
              : start;

          Color color;
          if (category == '학사공지') {
            color = const Color(0x83ABC9FF);
          } else if (category == 'ai학과공지') {
            color = const Color(0x83FFABAB);
          } else if (category == '취업공지') {
            color = const Color(0x83A5FAA5);
          } else {
            color = const Color.fromARGB(131, 171, 200, 255);
          }

          all.add(
            Notice(
              title: title,
              startDate: start,
              endDate: end,
              color: color,
              isHidden: false,
            ),
          );
        } catch (_) {
          continue;
        }
      }
    });

    return all;
  }
}
