
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shop_app/models/login/ShopLoginModel.dart';
// import 'package:shop_app/modules/login/states.dart';
// import 'package:shop_app/shared/network/remote/end_points.dart';
import 'package:social_app/modules/login/states.dart';

// import '../../shared/network/remote/dio_helper.dart';

class SocialLoginCubit extends Cubit<SocialLoginState>{
  SocialLoginCubit():super(SocialLoginInitialState());

  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    // emit(ShopLoginLoadingState());
    // DioHelper.postData(path: LOGIN, data: {
    //   'email': email,
    //   'password': password,
    // }).then((value) {
    //   loginModel= ShopLoginModel.fromJson(value.data);
    //   print(loginModel?.message);
    //   emit(ShopLoginSuccessState(loginModel));
    // }).catchError((error) {
    //   print(error);
    //   emit(ShopLoginErrorState(error));
    // });
  }

  IconData? passwordSuffix =  Icons.visibility_off;
  var obscureText = true;

  void changePassWordVisibility() {
    obscureText = !obscureText;
    passwordSuffix = obscureText
        ? Icons.visibility_off
        : Icons.visibility;
    print(obscureText);
    emit(SocialChangePassWordVisibilityState());
  }
}