import "package:equatable/equatable.dart";

enum LoadingStatus { initial, loading, success, failure }

class LoginState extends Equatable {

  const LoginState({
    this.email = "",
    this.password = "",
    this.status = LoadingStatus.initial,
    this.errorMessage,
  });
  final String email;
  final String password;
  final LoadingStatus status;
  final String? errorMessage;

  LoginState copyWith({
    String? email,
    String? password,
    LoadingStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage];
}
