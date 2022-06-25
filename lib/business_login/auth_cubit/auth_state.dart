part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final UserModel? userModel;
  final bool? isLoading;
  final XFile? userImageFile;
  final TextEditingController? otpTextCtrl;
  const AuthState(
      {this.userModel, this.isLoading, this.userImageFile, this.otpTextCtrl});

  AuthState copyWith(
      {UserModel? userModel,
      bool? isLoading,
      XFile? userImageFile,
      TextEditingController? otpTextCtrl}) {
    return AuthState(
        userModel: userModel ?? this.userModel,
        isLoading: isLoading ?? this.isLoading,
        userImageFile: userImageFile ?? this.userImageFile,
        otpTextCtrl: otpTextCtrl ?? this.otpTextCtrl);
  }

  @override
  List<Object> get props =>
      [userModel!, isLoading!, userImageFile!, otpTextCtrl!];
}
