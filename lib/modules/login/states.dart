
abstract class SocialLoginState {}

class SocialLoginInitialState extends SocialLoginState {}

class SocialLoginLoadingState extends SocialLoginState {}

class SocialLoginSuccessState extends SocialLoginState {
}

class SocialLoginErrorState extends SocialLoginState {
  final String error;
  SocialLoginErrorState(this.error);
}

class SocialChangePassWordVisibilityState extends SocialLoginState {}