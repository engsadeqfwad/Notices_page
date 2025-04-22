import 'package:flutter/material.dart';

//  أنواع الإشعارات المختلفة
enum NotificationType {
  compensatoryLecture, // محاضرة تعويضية
  feeDue, // تسليم رسوم
  announcement, // إعلان
  lectureCancellation, // إلغاء محاضرة
  examResult, // نتيجة امتحان
  scheduleChange, // تغيير في الجدول
  importantAlert, // تنبيه مهم
}

// نموذج بيانات الإشعار
class NotificationModel {
  final String id; // معرّف فريد للإشعار
  final String title; // عنوان الإشعار
  final String content; // محتوى الإشعار
  final NotificationType type; // نوع الإشعار
  final DateTime dateTime; // تاريخ ووقت الإشعار
  bool isRead; // حالة الإشعار (مقروء/غير مقروء)

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.dateTime,
    this.isRead = false, // افتراضياً غير مقروء
  });

}

//للحصول على اسم النوع باللغة العربية والأيقونة
extension NotificationTypeExtension on NotificationType {
  String get typeNameAr {
    switch (this) {
      case NotificationType.compensatoryLecture:
        return 'محاضرة تعويضية';
      case NotificationType.feeDue:
        return 'تسديد رسوم';
      case NotificationType.announcement:
        return 'إعلان هام';
      case NotificationType.lectureCancellation:
        return 'إلغاء محاضرة';
      case NotificationType.examResult:
        return 'نتائج الامتحانات';
      case NotificationType.scheduleChange:
        return 'تغيير في الجدول';
      case NotificationType.importantAlert:
        return 'تنبيه إداري';
      default:
        return 'إشعار';
    }
  }

  // دالة للحصول على الأيقونة المناسبة لنوع الإشعار
   IconData get icon {
    switch (this) {
      case NotificationType.compensatoryLecture:
        return Icons.schedule; // أيقونة جدول
      case NotificationType.feeDue:
        return Icons.payment; // أيقونة دفع
      case NotificationType.announcement:
        return Icons.campaign; // أيقونة إعلان
      case NotificationType.lectureCancellation:
        return Icons.event_busy; // أيقونة حدث مشغول
      case NotificationType.examResult:
        return Icons.assessment; // أيقونة تقييم
      case NotificationType.scheduleChange:
        return Icons.edit_calendar; // أيقونة تعديل تقويم
      case NotificationType.importantAlert:
        return Icons.warning_amber_rounded; // أيقونة تحذير
      default:
        return Icons.notifications; // أيقونة إشعار افتراضية
    }
  }
}
