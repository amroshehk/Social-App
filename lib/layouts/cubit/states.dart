
abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialLoadingState extends SocialStates {}

class SocialSuccessState extends SocialStates {
  final String uId;
  SocialSuccessState(this.uId);
}

class SocialErrorState extends SocialStates {
  final String error;
  SocialErrorState(this.error);
}


class SocialChangeBottomNavState extends SocialStates {

}

class SocialAddNewPostState extends SocialStates {

}