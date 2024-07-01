import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/social_layout.dart';
import 'package:social_app/modules/register/states.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'cubit.dart';

class SocialRegisterScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterStates>(
        listener: (context, state) {
          if (state is SocialCreateUserSuccessState) {
            // if (state.loginModel.status!) {
            //   print(state.loginModel.message);
            //   print(state.loginModel.data?.token);
            //
            //   CacheHelper.setData(
            //     key: 'token',
            //     value: state.loginModel.data?.token,
            //   ).then((value) {
            //     token = state.loginModel.data!.token.toString();
            //     navigateToAndFinish(
            //       context,
            //       SocialLayout(),
            //     );
            //   });
            // } else {
            //   print(state.loginModel.message);
            //
              showToast(
                message: "create user successfully".toString(),
                state: ToastStates.SUCCESS,
              );
              navigateToAndFinish(context, SocialLayout());
            // }
          }

          if(state is SocialRegisterErrorState){
            showToast(message: state.error,state: ToastStates.ERROR);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REGISTER',
                          style:
                              Theme.of(context).textTheme.headline4?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        Text(
                          'Register now to communicate with friends',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultTextFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please enter your name';
                            }
                          },
                          labelText: 'User Name',
                          prefixIcon: Icon(Icons.person),
                          context: context,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultTextFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'please enter your email address';
                              }
                            },
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined),
                            context: context),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultTextFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                              onPressed: () {
                                SocialRegisterCubit.get(context)
                                    .changePasswordVisibility();
                              },
                              icon:
                                  Icon(SocialRegisterCubit.get(context).suffix)),
                          obscureText:
                              SocialRegisterCubit.get(context).isPassword,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          context: context,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultTextFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please enter your phone number';
                            }
                          },
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone),
                          context: context,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialRegisterLoadingState,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  SocialRegisterCubit.get(context).userRegister(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              title: 'register',
                              color: defaultColor,
                              radius: 40.0),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
