import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/states.dart';
import '../../models/login_model.dart';

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
      createUser(name: name,email: email,phone: phone,uId: value.user?.uid,isEmailVerification: value.user?.emailVerified);
    }).catchError((error){
      emit(SocialRegisterErrorState(error.toString()));
    });
  }


  void createUser({
    required String name,
    required String email,
    required String phone,
    required String? uId,
    required bool? isEmailVerification,
  })
  {
    SocialLoginModel model = SocialLoginModel(
        name,email,phone,uId,isEmailVerification
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
