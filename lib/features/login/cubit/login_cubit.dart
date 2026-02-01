import "package:bloc/bloc.dart";
import "package:capital_commons/core/service_locator.dart";
import "login_state.dart";
import "package:capital_commons/clients/auth_client.dart";

class LoginCubit extends Cubit<LoginState> {

  LoginCubit() : super(const LoginState());
  final _authClient = getIt<AuthClient>();

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(email: email, password: password));
    emit(state.copyWith(status: LoadingStatus.loading));
    emit(state.copyWith(status: LoadingStatus.loading, errorMessage: null)); 
    try {
      await _authClient.signInWithEmailAndPassword(email: email, password: password);
      emit(state.copyWith(status: LoadingStatus.success));
    } on AuthClientException catch (e) {
      // Pass the readable message to the state
      emit(state.copyWith(
        status: LoadingStatus.failure,
        errorMessage: "Error: ${e.message}", // <-- use e.message
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoadingStatus.failure,
        errorMessage: "Error: ${e.toString()}",
      ));
    }

  }

  void updateEmail(String email) => emit(state.copyWith(email: email));
  void updatePassword(String password) => emit(state.copyWith(password: password));
}
