part of 'edit_last_name_cubit.dart';

class EditLastNameState extends Equatable {
  const EditLastNameState({
    required this.userLastname,
  });

  final String userLastname;

  @override
  List<Object> get props => [userLastname];
}
