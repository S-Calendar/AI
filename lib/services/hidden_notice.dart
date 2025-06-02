// services/hidden_notice.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notice.dart';

class HiddenNotices {
  static final List<Notice> _hidden = [];

  /// 숨긴 공지 목록 (읽기 전용)
  static List<Notice> get all => List.unmodifiable(_hidden);

  /// SharedPreferences에서 숨긴 공지를 불러옴
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList('hidden_notices') ?? [];

    _hidden.clear();
    for (final jsonStr in rawList) {
      final map = json.decode(jsonStr);
      _hidden.add(_fromMap(map));
    }
  }

  /// 공지를 숨김 목록에 추가
  static Future<void> add(Notice notice) async {
    if (!contains(notice)) {
      notice.isHidden = true;
      _hidden.add(notice);
      await _save();
    }
  }

  /// 숨긴 공지에서 제거 (복원)
  static Future<void> remove(Notice notice) async {
    _hidden.removeWhere((n) => _isSameNotice(n, notice));
    await _save();
  }

  /// 숨긴 공지에 포함되어 있는지 확인
  static bool contains(Notice notice) {
    return _hidden.any((n) => _isSameNotice(n, notice));
  }

  /// 저장
  static Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _hidden.map((n) => json.encode(_toMap(n))).toList();
    await prefs.setStringList('hidden_notices', jsonList);
  }

  /// 비교 기준 (title + startDate)
  static bool _isSameNotice(Notice a, Notice b) {
    return a.title == b.title && a.startDate == b.startDate;
  }

  /// Notice → Map
  static Map<String, dynamic> _toMap(Notice n) => {
        'title': n.title,
        'startDate': n.startDate.toIso8601String(),
        'endDate': n.endDate.toIso8601String(),
        'color': n.color.value,
        'url': n.url,
        'memo': n.memo,
        'isHidden': true,
      };

  /// Map → Notice
  static Notice _fromMap(Map<String, dynamic> m) => Notice(
        title: m['title'],
        startDate: DateTime.parse(m['startDate']),
        endDate: DateTime.parse(m['endDate']),
        color: Color(m['color']),
        url: m['url'],
        memo: m['memo'],
        isHidden: true,
      );
}
