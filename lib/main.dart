import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layouts/cubit/cubit.dart';
import 'package:social_app/layouts/cubit/states.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit_observer.dart';
import 'package:social_app/shared/shared_preferences.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'firebase_options.dart';
import 'layouts/social_layout.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  print('on background message');
  print(message.data.toString());

  await showToast(message: 'on background message', state: ToastStates.SUCCESS,);
}


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
  FirebaseMessaging.instance.requestPermission(
      alert: true, badge: true, provisional: true, sound: true);

  var token = await FirebaseMessaging.instance.getToken();

  print(token);
  // foreground fcm
  FirebaseMessaging.onMessage.listen((event)
  {
    print('on message');
    print(event.data.toString());

    showToast(message: 'on message', state: ToastStates.SUCCESS,);
  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print('on message opened app');
    print(event.data.toString());

    showToast(message: 'on message opened app', state: ToastStates.SUCCESS,);
  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

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
              create: (BuildContext context) => SocialCubit()..getUserData()..getPosts())
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
