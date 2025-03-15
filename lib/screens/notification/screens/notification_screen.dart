import 'package:flutter/material.dart';
import '../widgets/notification_item.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationModel> notifications = [
      NotificationModel(title: '지출 초과 위험', message: '확인하세요!', date: '1월 30일', status: NotificationStatus.unread),
      NotificationModel(title: '예산 사용 알림', message: '이번 달 예산 사용 현황입니다.', date: '2월 1일', status: NotificationStatus.read),
      NotificationModel(title: '지출 초과 위험', message: '확인하세요!', date: '1월 30일', status: NotificationStatus.unread),
      NotificationModel(title: '예산 사용 알림', message: '이번 달 예산 사용 현황입니다.', date: '2월 1일', status: NotificationStatus.read),
      NotificationModel(title: '지출 초과 위험', message: '확인하세요!', date: '1월 30일', status: NotificationStatus.unread),

    ];


    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            ...notifications.map((notification) => NotificationItem(notification: notification)).toList(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                '받은 알림은 30일 동안 보관됩니다.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),)
            ),
          ],
        ),
      ),
    );
  }
}