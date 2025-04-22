import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notices_page/models/notification_model.dart';
import 'package:notices_page/controllers/notification_controller.dart';

class NotificationListItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationListItem({Key? key, required this.notification})
      : super(key: key);

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return 'قبل ${difference.inMinutes} د';
    } else if (difference.inHours < 24) {
      return 'قبل ${difference.inHours} س';
    } else if (difference.inDays < 7) {
      return 'قبل ${difference.inDays} ي';
    } else {
      return DateFormat('yyyy/MM/dd', 'ar').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final NotificationController controller =
        Get.find<NotificationController>();
    final bool isUnread = !notification.isRead;
    final Color cardColor =
        isUnread ? Colors.indigo.shade50 : Theme.of(context).cardColor;
    final Color iconBackgroundColor = isUnread
        ? Theme.of(context).primaryColor.withOpacity(0.15)
        : Colors.grey.shade200;
    final Color iconForegroundColor =
        isUnread ? Theme.of(context).primaryColor : Colors.grey.shade700;
    final FontWeight titleFontWeight =
        isUnread ? FontWeight.bold : FontWeight.w600;

    return Card(
      elevation: isUnread ? 2.0 : 1.0,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: cardColor,
      child: Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          controller.deleteNotification(notification.id);
          Get.snackbar(
            'تم الحذف',
            'تم حذف الإشعار: ${notification.title}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.grey.shade700,
            colorText: Colors.white,
            duration: Duration(seconds: 2),
          );
        },
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade800,
            borderRadius: BorderRadius.circular(12.0),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Icon(Icons.delete_outline, color: Colors.white, size: 28),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: () {
            controller.markAsRead(notification.id);
            print('تم النقر على الإشعار: ${notification.title}');
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: iconBackgroundColor,
                  child: Icon(notification.type.icon,
                      color: iconForegroundColor, size: 26),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: titleFontWeight,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              _formatDateTime(notification.dateTime),
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        notification.content,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.grey.shade800,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
