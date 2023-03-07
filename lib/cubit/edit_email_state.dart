part of 'edit_email_cubit.dart';

class EditEmailState extends Equatable {
  const EditEmailState({
    required this.email,
  });

  final String email;

  @override
  List<Object> get props => [email];
}
