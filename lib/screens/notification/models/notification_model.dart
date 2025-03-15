import 'package:flutter/material.dart';

enum NotificationStatus { unread, read }

class NotificationModel {
  final String title;
  final String message;
  final String date;
  final NotificationStatus status;

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
    this.status = NotificationStatus.unread,
  });

// 상태별 색상 매핑
  static final Map<NotificationStatus, Color> statusColors = {
    NotificationStatus.unread: Colors.blue.shade50,
    NotificationStatus.read: Colors.grey.shade200,
  };
}