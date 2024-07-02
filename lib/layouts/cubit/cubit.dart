import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/models/login_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';

// import 'package:shop_app/models/login/ShopModel.dart';
// import 'package:shop_app/modules/login/states.dart';
// import 'package:shop_app/shared/network/remote/end_points.dart';
import 'package:social_app/modules/login/states.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';

import '../../shared/components/constants.dart';

// import '../../shared/network/remote/dio_helper.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);
  SocialLoginModel? model;

  void getUserData() {
    emit(SocialLoadingState());
    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
      model = SocialLoginModel.formJson(value.data()!);
      emit(SocialSuccessState(model!.uId!));
    }).catchError((error) {
      emit(SocialErrorState(error.toString()));
    });
  }

  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen()
  ];

  List<String> titles = ['Home', 'Chats', 'Users', 'Settings'];

  var currentIndex = 0;

  void changeBottomNav(index) {
    currentIndex = index;
    emit(SocialChangeBottomNavState());
  }
}
