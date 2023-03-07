import 'package:bloc/bloc.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_email_state.dart';

class EditEmailCubit extends Cubit<EditEmailState> {
  EditEmailCubit({
    required this.userID,
  }) : super(const EditEmailState(email: "")) {
    initializeUserEmail();
  }

  DataRepository dr = DataRepository();
  String userID;

  void initializeUserEmail() async {
    String email = await dr.getUserEmailFromUser(userID);
    emit(EditEmailState(email: email));
  }

  void updateUserEmail(String newEmail, String userID) async {
    await dr.updateUserEmail(newEmail, userID);
    String email = await dr.getUserEmailFromUser(userID);
    emit(EditEmailState(email: email));
  }
}
