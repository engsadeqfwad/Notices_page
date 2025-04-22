import 'package:get/get.dart';
import 'package:notices_page/models/notification_model.dart';
import 'dart:math'; // لاستخدام Random

class NotificationController extends GetxController {
  // قائمة الإشعارات الأصلية (غير تفاعلية مباشرة، تستخدم كمصدر)
  final List<NotificationModel> _allNotifications = [];

  // قائمة الإشعارات المعروضة (تفاعلية باستخدام RxList)
  final RxList<NotificationModel> filteredNotifications =
      <NotificationModel>[].obs;

  // نوع التصفية الحالي (تفاعلي باستخدام Rx)
  final Rx<NotificationType?> currentFilter = Rx<NotificationType?>(null);

  // عدد الإشعارات غير المقروءة (تفاعلي باستخدام RxInt)
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _generateInitialNotifications();
    _applyFilter(); // تطبيق الفلتر الأولي
    _updateUnreadCount(); // حساب العدد الأولي
  }

  // دالة لإنشاء بيانات إشعارات أولية للتجربة
  void _generateInitialNotifications() {
    final random = Random();
    final now = DateTime.now();
    _allNotifications.addAll(List.generate(20, (index) {
      final typeValues = NotificationType.values;
      final randomType = typeValues[random.nextInt(typeValues.length)];
      final randomMinutesAgo = random.nextInt(60 * 24 * 3); // خلال آخر 3 أيام
      final dateTime = now.subtract(Duration(minutes: randomMinutesAgo));
      final isRead = random.nextBool(); // حالة قراءة عشوائية

      return NotificationModel(
        id: 'notif_$index',
        title: '${randomType.typeNameAr} #${index + 1}',
        content:
            'هذا هو محتوى الإشعار رقم ${index + 1} من نوع ${randomType.typeNameAr}. يرجى الانتباه للتفاصيل المذكورة.',
        type: randomType,
        dateTime: dateTime,
        isRead: isRead,
      );
    }));

    // ترتيب الإشعارات حسب الأحدث أولاً
    _allNotifications.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  // دالة لتحديث عدد الإشعارات غير المقروءة
  void _updateUnreadCount() {
    unreadCount.value = _allNotifications.where((n) => !n.isRead).length;
  }

  // دالة لتطبيق التصفية على قائمة الإشعارات
  void _applyFilter() {
    if (currentFilter.value == null) {
      filteredNotifications.assignAll(_allNotifications); // عرض الكل
    } else {
      filteredNotifications.assignAll(_allNotifications
          .where((n) => n.type == currentFilter.value)
          .toList());
    }
  }

  // دالة لتغيير نوع التصفية
  void setFilter(NotificationType? filterType) {
    currentFilter.value = filterType;
    _applyFilter();
  }

  // دالة لوضع علامة مقروء على إشعار معين
  void markAsRead(String notificationId) {
    final index = _allNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1 && !_allNotifications[index].isRead) {
      _allNotifications[index].isRead = true;

      final filteredIndex =
          filteredNotifications.indexWhere((n) => n.id == notificationId);
      if (filteredIndex != -1) {
        var updatedNotification = filteredNotifications[filteredIndex];
        updatedNotification.isRead = true; // تغيير الحالة
        filteredNotifications[filteredIndex] = updatedNotification;
      }

      _updateUnreadCount(); // تحديث عدد غير المقروء
    }
  }

  // دالة لحذف إشعار معين
  void deleteNotification(String notificationId) {
    _allNotifications.removeWhere((n) => n.id == notificationId);
    _applyFilter(); //
    _updateUnreadCount();
  }
}
