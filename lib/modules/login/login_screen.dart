import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:social_app/layouts/shop/SocialLayout.dart';
import 'package:social_app/modules/login/cubit.dart';
import 'package:social_app/modules/login/states.dart';
// import 'package:social_app/modules/register/shop_register_screen.dart';
// import 'package:social_app/shared/components/components.dart';
// import 'package:social_app/shared/styles/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import '../register/register_screen.dart';

// import '../../shared/components/constants.dart';
// import '../../shared/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var errorMessage = "";
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (BuildContext context) => SocialLoginCubit(),
        child: BlocConsumer<SocialLoginCubit, SocialLoginState>(
          builder: (BuildContext context, SocialLoginState state) {
            var cubit = SocialLoginCubit.get(context);
            return Form(
              key: formKey,
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LOGIN",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Login now to communicate with friends',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 40,
                            ),
                            defaultTextFormField(
                                controller: emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Must enter valid email";
                                  } else {
                                    return null;
                                  }
                                },
                                labelText: "E-Mail",
                                prefixIcon: Icon(Icons.email_outlined),
                                type: TextInputType.emailAddress,
                                context: context),
                            const SizedBox(
                              height: 20,
                            ),
                            defaultTextFormField(
                                controller: passwordController,
                                obscureText: cubit.obscureText,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Must enter valid password";
                                  } else {
                                    return null;
                                  }
                                },

                                labelText: "Passwrod",
                                prefixIcon: Icon(Icons.lock_outline),
                                type: TextInputType.visiblePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(cubit.passwordSuffix),
                                  onPressed: () {
                                    cubit.changePassWordVisibility();
                                  },
                                ),
                                context: context),
                            const SizedBox(
                              height: 20,
                            ),
                            ConditionalBuilder(
                              condition: state is! SocialLoginLoadingState,
                              builder: (context) => defaultButton(
                                  title: 'login',
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.userLogin(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  color: defaultColor,
                                  radius: 40.0),
                              fallback: (context) =>
                                  Center(child: CircularProgressIndicator()),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              errorMessage,
                              style: TextStyle(color: Colors.red),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(fontSize: 14.0,color: defaultColor),
                                ),
                                defaultTextButton(
                                    function: () {
                                      navigateTo(context, SocialRegisterScreen());
                                    },
                                    title: 'register')
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          listener: (context, state) {
            if(state is SocialLoginSuccessState){
              // var status = state.loginModel?.status;
              // if(status == true) {
              //   CacheHelper.setData(key: USER_TOKEN, value: state.loginModel?.data?.token).then((value) {
              //     if(value==true){
              //       token = state.loginModel!.data!.token!;
              //       navigateToAndFinish(context, const SocialLayout());
              //     }
              //   });
              //
              //   showToast(message: state.loginModel!.message.toString(),state: ToastStates.SUCCESS);
              // } else {
              //   showToast(message: state.loginModel!.message.toString(),state: ToastStates.ERROR);
              // }
            }
          },
        ),
      ),
    );
  }


}
