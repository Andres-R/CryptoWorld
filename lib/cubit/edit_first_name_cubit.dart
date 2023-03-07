import 'package:bloc/bloc.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_first_name_state.dart';

class EditFirstNameCubit extends Cubit<EditFirstNameState> {
  EditFirstNameCubit({
    required this.userID,
  }) : super(const EditFirstNameState(userFirstname: "")) {
    initializeUserFirstName();
  }

  DataRepository dr = DataRepository();
  String userID;

  void initializeUserFirstName() async {
    String firstName = await dr.getUserFirstNameFromUser(userID);
    emit(EditFirstNameState(userFirstname: firstName));
  }

  void updateUserFirstName(String newFirstName, String userID) async {
    await dr.updateUserFirstName(newFirstName, userID);
    String firstName = await dr.getUserFirstNameFromUser(userID);
    emit(EditFirstNameState(userFirstname: firstName));
  }
}
