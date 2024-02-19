import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';

class Time {
  void timeCalculator(DateTime newsDateTime) {
    DateTime currentTime = DateTime.now();
    print('##### now : $currentTime');

// 현재 날짜 년월일만 입력하기
    DateTime date1 = DateTime(2023, 8, 25);
    print('##### date1 : $date1');

// 시간 비교하기
    Duration diffTime = currentTime.difference(newsDateTime);
    print('##### diffTime 일 비교 : ${diffTime.inDays}');
    print('##### diffTime 시 비교 : ${diffTime.inHours}');
    print('##### diffTime 분 비교 : ${diffTime.inMinutes}');
  }

  DateTime getFormttedTime(String responseBody) {
    final document = html_parser.parse(responseBody);
    final timeMetaTag = document.head?.querySelector('meta[property="article:published_time"]');
    if (timeMetaTag != null) {
      String dateTimeString = timeMetaTag.attributes['content']!;
      DateTime dateTime = DateTime.parse(dateTimeString);
      return dateTime;
    } else {
      return DateTime.now();
    }
  }
}
