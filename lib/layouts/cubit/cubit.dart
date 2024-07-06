import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../../shared/components/constants.dart';


class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);
  SocialLoginModel? userModel;

  void getUserData() {
    emit(SocialLoadingState());
    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
      userModel = SocialLoginModel.formJson(value.data()!);
      emit(SocialSuccessState(userModel!.uId!));
    }).catchError((error) {
      emit(SocialErrorState(error.toString()));
    });
  }

  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    NewPostsScreen(),
    UsersScreen(),
    SettingsScreen()
  ];

  List<String> titles = ['Home', 'Chats', 'Post', 'Users', 'Settings'];

  var currentIndex = 0;

  void changeBottomNav(index) {

    if(index == 2) {
      emit(SocialAddNewPostState());
    } else {
      currentIndex = index;
      emit(SocialChangeBottomNavState());
    }

  }
}
