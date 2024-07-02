import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Text("News Feed"),
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
              )
          ],
        );
          } ,
          fallback: (context) => Center(child: CircularProgressIndicator()),
        ),
      );
    }, listener: (context, state) {

    },);
  }
}
