import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

import '../shared/styles/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);
    return BlocConsumer<SocialCubit,SocialState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text(cubit.titles[cubit.currentIndex]),
          actions: [
            IconButton(onPressed: () {

            }, icon: Icon(IconBroken.Notification)),
            IconButton(onPressed: () {

            }, icon: Icon(IconBroken.Search))
          ],
        ),
        body:ConditionalBuilder(
      condition: SocialCubit.get(context).model != null,
          builder: (context) {
            var model = SocialCubit.get(context).model!;
        return Column(
          children: [

            if(FirebaseAuth.instance.currentUser?.emailVerified == false)
              Container(
                color: Colors.amber.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,color: Colors.black,),
                      SizedBox(width: 10.8),
                      Expanded(child: Text('Please verifiy your email',style: TextStyle(fontSize: 14),)),
                      defaultTextButton(title: 'Send', function: () {
                        FirebaseAuth.instance.currentUser?.sendEmailVerification().then((value) {
                          showToast(message: "Please check your mail.",state: ToastStates.SUCCESS);
                        }).catchError((error){
                          showToast(message: error.toString(),state: ToastStates.ERROR);
                        });
                      },)

                    ],
                  ),
                ),
              ),
            cubit.screens[cubit.currentIndex]
          ],
        );
          } ,
          fallback: (context) => Center(child: CircularProgressIndicator()),
        ),
        bottomNavigationBar: BottomNavigationBar(items: [
          BottomNavigationBarItem(icon: Icon(IconBroken.Home),label: cubit.titles[0]),
          BottomNavigationBarItem(icon: Icon(IconBroken.Chat),label: cubit.titles[1]),
          BottomNavigationBarItem(icon: Icon(IconBroken.Location),label: cubit.titles[2]),
          BottomNavigationBarItem(icon: Icon(IconBroken.Setting),label: cubit.titles[3]),
        ],
        currentIndex: cubit.currentIndex,
        onTap: (value) {
          cubit.currentIndex = value;
          cubit.changeBottomNav(value);
        },
        ),
      );
    }, listener: (context, state) {

    },);
  }
}
