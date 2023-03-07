import 'package:bloc/bloc.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required this.userID,
    required this.screenID,
  }) : super(const NotificationsState(notifications: [])) {
    initializeNotifications();
  }

  DataRepository dataRepository = DataRepository();
  String userID;
  String screenID;

  void initializeNotifications() async {
    List<Map<String, dynamic>> notifications =
        await dataRepository.getNotificationSettings(userID, screenID);
    emit(NotificationsState(notifications: notifications));
  }

  void addNotificationSetting(
    String name,
    String symbol,
    String criteria,
    double criteriaPercent,
    String userID,
    String screenID,
  ) async {
    await dataRepository.addNotificationSetting(
        name, symbol, criteria, criteriaPercent, userID, screenID);
    List<Map<String, dynamic>> notifications =
        await dataRepository.getNotificationSettings(userID, screenID);
    emit(NotificationsState(notifications: notifications));
  }

  void deleteNotificationByID(String id, String userID, String screenID) async {
    await dataRepository.deleteNotificationSettingByID(id);
    List<Map<String, dynamic>> notifications =
        await dataRepository.getNotificationSettings(userID, screenID);
    emit(NotificationsState(notifications: notifications));
  }
}
