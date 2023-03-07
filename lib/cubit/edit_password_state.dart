part of 'edit_password_cubit.dart';

class EditPasswordState extends Equatable {
  const EditPasswordState({
    required this.password,
  });

  final String password;

  @override
  List<Object> get props => [password];
}
