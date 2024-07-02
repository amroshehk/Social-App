
abstract class SocialState {}

class SocialInitialState extends SocialState {}

class SocialLoadingState extends SocialState {}

class SocialSuccessState extends SocialState {
  final String uId;
  SocialSuccessState(this.uId);
}

class SocialErrorState extends SocialState {
  final String error;
  SocialErrorState(this.error);
}


class SocialChangeBottomNavState extends SocialState {

}