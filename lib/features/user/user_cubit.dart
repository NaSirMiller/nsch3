import "dart:async";

import "package:capital_commons/clients/auth_client.dart";
import "package:capital_commons/core/service_locator.dart";
import "package:capital_commons/models/app_user.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "user_cubit.freezed.dart";

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState()) {
    _userChangesSubscription = _authClient.userChanges.listen(_onUserChanged);
  }

  final _authClient = getIt<AuthClient>();
  StreamSubscription<AppUser?>? _userChangesSubscription;

  void _onUserChanged(AppUser? user) {
    emit(state.copyWith(currentUser: user));
  }

  /// New logout method
  Future<void> logout() async {
    await _authClient.logout(); // Call AuthClient logout
    emit(const UserState(currentUser: null)); // Clear local user state
  }

  @override
  Future<void> close() async {
    await _userChangesSubscription?.cancel();
    await super.close();
  }
}

@freezed
sealed class UserState with _$UserState {
  const factory UserState({AppUser? currentUser}) = _UserState;
}
