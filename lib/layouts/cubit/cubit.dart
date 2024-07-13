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
import '../../models/message_model.dart';
import '../../models/post_model.dart';
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
      userModel = SocialUserModel.fromJson(value.data()!);
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

    if(index == 1) {
      getUsers();
    }
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

  File? postImage;
  ImagePicker postImagePicker = ImagePicker();
  Future<void> getPostImage() async {
    final pickedFile = await postImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorState());
    }
  }

  void removePostImage()
  {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  })
  {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value)
      {
        print(value);
        createPost(
          text: text,
          dateTime: dateTime,
          postImage: value,
        );
      }).catchError((error)
      {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error)
    {
      emit(SocialCreatePostErrorState());
    });
  }

  void createPost({
    required String dateTime,
    required String text,
    String? postImage,
  })
  {
    emit(SocialCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      image: userModel!.image,
      uId: userModel!.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage??'',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value)
    {
      emit(SocialCreatePostSuccessState());
    })
        .catchError((error)
    {
      emit(SocialCreatePostErrorState());
    });
  }

  List<PostModel> posts = [];
  List<String> postsId = [];
  List<int> likes = [];
  List<String> comments = [];

  void getPosts()
  {
    FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((value)
    {
      value.docs.forEach((element)
      {
        element.reference
            .collection('likes')
            .get()
            .then((value)
        {
          likes.add(value.docs.length);
          postsId.add(element.id);
          posts.add(PostModel.fromJson(element.data()));
        });
      });

      emit(SocialGetPostsSuccessState());
    })
        .catchError((error){
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postId){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void commentPost(String postId, String comment){
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(userModel!.uId)
        .set({
      'comment': comment,
    }).then((value) {
      emit(SocialCommentOnPostSuccessState());
    }).catchError((error) {
      emit(SocialCommentOnPostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];

  void getUsers()
  {
    if(users.length == 0)
    FirebaseFirestore.instance.collection('users').get().then((value)
    {
      value.docs.forEach((element)
      {
        if(element.data()['uId'] != userModel!.uId)
        users.add(SocialUserModel.fromJson(element.data()));
      });

      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

  void sendMessage({
    required String receiverId,
    required String dateTime,
    required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel!.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });

    // set receiver chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> messages = [];

  void getMessages({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime' )
        .snapshots()
        .listen((event) {
      messages = [];

      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });

      emit(SocialGetMessagesSuccessState());
    });
  }
}
