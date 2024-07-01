import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/states.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterStates> {
  SocialRegisterCubit() : super(SocialRegisterInitialState());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);

  // SocialLoginModel? loginModel;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  })
  {
    // emit(SocialRegisterLoadingState());
    //
    // DioHelper.postData(
    //   path: REGISTER,
    //   data:
    //   {
    //     'name': name,
    //     'email': email,
    //     'password': password,
    //     'phone': phone,
    //   },
    // ).then((value)
    // {
    //   print(value.data);
    //   loginModel = SocialLoginModel.fromJson(value.data);
    //   emit(SocialRegisterSuccessState(loginModel!));
    // }).catchError((error)
    // {
    //   print(error.toString());
    //   emit(SocialRegisterErrorState(error.toString()));
    // });
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
