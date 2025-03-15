import 'package:flutter/material.dart';
import 'package:mooney2/constants/colors.dart';
import '../models/notification_model.dart';
class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: 80,
      decoration: BoxDecoration(
        color: NotificationModel.statusColors[notification.status],

      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle,
              color: notification.status == NotificationStatus.unread ? Colors
                  .blue : Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(notification.message),
              ],
            ),
          ),
          Text(
            "${notification.date}",
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}