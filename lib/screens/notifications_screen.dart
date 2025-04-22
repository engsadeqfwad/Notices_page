import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notices_page/controllers/notification_controller.dart';
import 'package:notices_page/widgets/notification_list_item.dart';
import 'package:notices_page/models/notification_model.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NotificationController controller =
        Get.find<NotificationController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('الإشعارات'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          Obx(() => PopupMenuButton<NotificationType?>(
                icon: Icon(
                  controller.currentFilter.value == null
                      ? Icons.filter_list_outlined
                      : Icons.filter_alt_outlined,
                  size: 26,
                ),
                tooltip: 'تصفية الإشعارات',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onSelected: (NotificationType? result) {
                  controller.setFilter(result);
                },
                itemBuilder: (BuildContext context) {
                  final currentFilterValue = controller.currentFilter.value;
                  return <PopupMenuEntry<NotificationType?>>[
                    PopupMenuItem<NotificationType?>(
                      value: null,
                      child: ListTile(
                        leading: Icon(Icons.clear_all,
                            color: currentFilterValue == null
                                ? Theme.of(context).primaryColor
                                : null),
                        title: Text('عرض الكل',
                            style: TextStyle(
                                fontWeight: currentFilterValue == null
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        selected: currentFilterValue == null,
                        selectedTileColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                    const PopupMenuDivider(),
                    ...NotificationType.values.map((type) {
                      final bool isSelected = currentFilterValue == type;
                      return PopupMenuItem<NotificationType?>(
                        value: type,
                        child: ListTile(
                          leading: Icon(type.icon,
                              size: 22,
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade700),
                          title: Text(type.typeNameAr,
                              style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
                          selected: isSelected,
                          selectedTileColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                      );
                    }).toList(),
                  ];
                },
              )),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 4.0),
            child: Obx(() {
              final unreadCount = controller.unreadCount.value;
              return Badge(
                label: Text('$unreadCount'),
                isLabelVisible: unreadCount > 0,
                backgroundColor: Colors.red.shade600,
                textColor: Colors.white,
                offset: const Offset(-6, 6),
                child: IconButton(
                  icon: Icon(Icons.notifications_outlined, size: 26),
                  tooltip: 'الإشعارات غير المقروءة',
                  onPressed: () {},
                ),
              );
            }),
          ),
        ],
      ),
      body: Obx(() {
        final notifications = controller.filteredNotifications;

        if (notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16),
                Text(
                  controller.currentFilter.value == null
                      ? 'لا توجد إشعارات حالياً.'
                      : 'لا توجد إشعارات من نوع "${controller.currentFilter.value!.typeNameAr}".',
                  style: TextStyle(fontSize: 17, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return NotificationListItem(
                key: ValueKey(notification.id), notification: notification);
          },
        );
      }),
    );
  }
}
