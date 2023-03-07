part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    required this.notifications,
  });

  final List<Map<String, dynamic>> notifications;

  @override
  List<Object> get props => [notifications];
}
