part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationRegistered extends AuthenticationState {
  final String userId;
  final String emailAddress;
  final String name;
  final File photo;

  const AuthenticationRegistered({
    required this.userId,
    required this.emailAddress,
    required this.name,
    required this.photo,
  });
}

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

class AuthenticationLogin extends AuthenticationState {
  final String? errorMessage;
  final String? initialEmailValue;

  const AuthenticationLogin({this.errorMessage, this.initialEmailValue});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationLogin &&
        other.errorMessage == errorMessage &&
        other.initialEmailValue == initialEmailValue;
  }

  @override
  int get hashCode => errorMessage.hashCode ^ initialEmailValue.hashCode;
}

class AuthenticationRegister extends AuthenticationState {
  final String? errorMessage;
  final String? initialEmailValue;
  final String? initialNameValue;

  const AuthenticationRegister({
    this.errorMessage,
    this.initialEmailValue,
    this.initialNameValue,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationRegister &&
        other.errorMessage == errorMessage &&
        other.initialEmailValue == initialEmailValue &&
        other.initialNameValue == initialNameValue;
  }

  @override
  int get hashCode => errorMessage.hashCode ^ initialEmailValue.hashCode;
}

class AuthenticationResetPassword extends AuthenticationState {
  final String? initialEmailValue;

  const AuthenticationResetPassword({this.initialEmailValue});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthenticationResetPassword &&
        other.initialEmailValue == initialEmailValue;
  }

  @override
  int get hashCode => initialEmailValue.hashCode;
}

class AuthenicationAwaitingConfirmation extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {}
