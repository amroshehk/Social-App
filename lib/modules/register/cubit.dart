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
        name,email,phone,uId,"Write your bio...",
        "https://www.freepik.com/free-ai-image/3d-illustration-young-business-man-with-funny-expression-his-face_126609697.htm#fromView=search&page=1&position=3&uuid=65ba1883-741f-4900-86d5-bbbb3e5e6467",
        "https://img.freepik.com/free-photo/autumn-leaves-composition_23-2151554997.jpg?t=st=1720136046~exp=1720139646~hmac=74a1a4f3a373c6f5c54e44140470c051ef49658d1f3abda7df18e9b536af9ec3&w=1480"
        ,isEmailVerification
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
