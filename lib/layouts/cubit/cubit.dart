import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import '../../models/social_user_model.dart';
import '../../modules/new_post/new_post_screen.dart';
import '../../shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  static SocialCubit get(context) => BlocProvider.of(context);
  SocialUserModel? userModel;

  void getUserData() {
    emit(SocialLoadingState());
    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
      userModel = SocialUserModel.formJson(value.data()!);
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
  File?  profileImage;
  ImagePicker profileImagePicker = ImagePicker();

  Future<void> getProfileImage() async {
    final XFile? pickedFile = await profileImagePicker.pickImage(
      source: ImageSource.gallery,
    ).then((value) {
      profileImage = File(value!.path);
      emit(SocialProfileImagePickedSuccessState());
    }).catchError((error){
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    });
  }

  File?  coverImage;
  ImagePicker coverImagePicker = ImagePicker();

  Future<void> getCoverImage() async {
    final XFile? pickedFile = await coverImagePicker.pickImage(
      source: ImageSource.gallery,
    ).then((value) {
      coverImage = File(value!.path);
      emit(SocialCoverImagePickedSuccessState());
    }).catchError((error){
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    });
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value)
      {
        //emit(SocialUploadProfileImageSuccessState());
        print(value);
        updateUser(
          name:name,
          phone:phone,
          bio:bio,
          image:value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  })
  {
    emit(SocialUserUpdateLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverImageSuccessState());
        print(value);
        updateUser(
          name:name,
          phone:phone,
          bio:bio,
          cover:value,
        );
      }).catchError((error)
      {
        emit(SocialUploadCoverImageErrorState());
      });
    }).catchError((error)
    {
      emit(SocialUploadCoverImageErrorState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? cover,
    String? image,
  })
  {
    SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      cover: cover??userModel!.cover,
      image: image??userModel!.image,
      uId: userModel!.uId,
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value)
    {
      getUserData();
    })
        .catchError((error)
    {
      emit(SocialUserUpdateErrorState());
    });
  }


}
