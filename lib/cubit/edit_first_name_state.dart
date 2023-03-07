part of 'edit_first_name_cubit.dart';

class EditFirstNameState extends Equatable {
  const EditFirstNameState({
    required this.userFirstname,
  });

  final String userFirstname;

  @override
  List<Object> get props => [userFirstname];
}
