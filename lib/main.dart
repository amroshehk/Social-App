import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit_observer.dart';
import 'package:social_app/shared/shared_preferences.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'firebase_options.dart';
import 'layouts/social_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();
  Bloc.observer = AppBlocObserver();
  Widget startWidget;
  uId = CacheHelper.getData(key: USER_ID);
  if (uId == null) {
    startWidget = LoginScreen();
  } else {
    startWidget = SocialLayout();
  }
  runApp(MyApp(startWidget));
}

class MyApp extends StatelessWidget {
  late Widget widget;

  MyApp(this.widget, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) => SocialCubit()..getUserData())
        ],
        child: BlocConsumer<SocialCubit, SocialStates>(
          builder: (BuildContext context, SocialStates state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: lightTheme(),
              darkTheme: darkTheme(),
              home: widget,
            );
          },
          listener: (context, state) {},
        ));
  }
}
