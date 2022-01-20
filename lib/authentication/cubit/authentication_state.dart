part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationLoaded extends AuthenticationState {
  final User user;

  const AuthenticationLoaded(this.user);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationLoaded && other.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}

class AuthenticationLogin extends AuthenticationState {}

class AuthenticationRegister extends AuthenticationState {}

class AuthenticationResetPassword extends AuthenticationState {}

class AuthenicationAwaitingConfirmation extends AuthenticationState {}

class AuthenicationPasswordSent extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
