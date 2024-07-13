import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/states.dart';
import '../../models/social_user_model.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  })
  {
    emit(SocialRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      print(value.user?.displayName.toString());
      // emit(SocialRegisterSuccessState());
      createUser(name: name,email: email,phone: phone,uId: value.user?.uid,isEmailVerified: value.user?.emailVerified);
    }).catchError((error){
      emit(SocialRegisterErrorState(error.toString()));
    });
  }


  void createUser({
    required String name,
    required String email,
    required String phone,
    required String? uId,
    required bool? isEmailVerified,
  })
  {
    SocialUserModel model = SocialUserModel(
        name: name,email: email,phone: phone,uId: uId,bio: "Write your bio...",
        image: "https://img.freepik.com/free-photo/3d-illustration-young-business-man-with-funny-expression-his-face_1142-55156.jpg?t=st=1720745457~exp=1720749057~hmac=c771e4c207b1ed73ea54fb7f90586f67ff7a80f858ad425e317df225bd451b84&w=1060",
        cover: "https://img.freepik.com/free-photo/autumn-leaves-composition_23-2151554997.jpg?t=st=1720136046~exp=1720139646~hmac=74a1a4f3a373c6f5c54e44140470c051ef49658d1f3abda7df18e9b536af9ec3&w=1480"
        ,isEmailVerified: isEmailVerified
    );
    // emit(SocialCreateUserLoadingState());
    FirebaseFirestore.instance.collection("users").doc(uId).set(model.toMap()).then((value){
      emit(SocialCreateUserSuccessState());
    }).catchError((error){
      emit(SocialCreateUserErrorState(error));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;

    emit(SocialRegisterChangePasswordVisibilityState());
  }
}
