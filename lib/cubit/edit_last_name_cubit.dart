import 'package:bloc/bloc.dart';
import 'package:crypto_world/data/repository/data_repository.dart';
import 'package:equatable/equatable.dart';

part 'edit_last_name_state.dart';

class EditLastNameCubit extends Cubit<EditLastNameState> {
  EditLastNameCubit({
    required this.userID,
  }) : super(const EditLastNameState(userLastname: "")) {
    initializeUserLastName();
  }

  DataRepository dr = DataRepository();
  String userID;

  void initializeUserLastName() async {
    String lastName = await dr.getUserLastNameFromUser(userID);
    emit(EditLastNameState(userLastname: lastName));
  }

  void updateUserLastName(String newLastName, String userID) async {
    await dr.updateUserLastName(newLastName, userID);
    String lastName = await dr.getUserLastNameFromUser(userID);
    emit(EditLastNameState(userLastname: lastName));
  }
}
