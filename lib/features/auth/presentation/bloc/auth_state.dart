part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class LoadedUserState extends AuthState {
  final User user;

  LoadedUserState({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class MessageState extends AuthState {
  final String message;

  MessageState({required this.message});

  @override
  List<Object> get props => [message];
}
