import 'package:bloc/bloc.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_password_state.dart';

class EditPasswordCubit extends Cubit<EditPasswordState> {
  EditPasswordCubit({
    required this.userID,
  }) : super(const EditPasswordState(password: "")) {
    initializeUserPassword();
  }

  DataRepository dr = DataRepository();
  String userID;

  void initializeUserPassword() async {
    String password = await dr.getUserPasswordFromUser(userID);
    emit(EditPasswordState(password: password));
  }

  void updateUserPassword(String newPassword, String userID) async {
    await dr.updateUserPassword(newPassword, userID);
    String password = await dr.getUserPasswordFromUser(userID);
    emit(EditPasswordState(password: password));
  }
}
