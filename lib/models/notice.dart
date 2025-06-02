// notice.dart
import 'package:flutter/material.dart';

class Notice {
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final Color color;
  final String? url;

  bool isFavorite; // 관심 공지 여부
  bool isHidden;   // 숨김 여부
  String? memo;    // 메모 내용

  Notice({
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.color,
    this.url,
    this.isFavorite = false,
    this.isHidden = false,
    this.memo,
  });

  // 신청기간 길이 (띠 우선순위 판단용)
  int get duration => endDate.difference(startDate).inDays + 1;

  // 날짜 포함 여부
  bool includes(DateTime date) {
    return !date.isBefore(startDate) && !date.isAfter(endDate);
  }

  @override
  bool operator ==(Object other) =>
      other is Notice &&
      title == other.title &&
      startDate == other.startDate;

  @override
  int get hashCode => Object.hash(title, startDate);
}
