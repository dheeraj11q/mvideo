import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvideo/business_login/auth_cubit/auth_cubit.dart';
import 'package:mvideo/business_login/home_cubit/home_cubit.dart';
import 'package:mvideo/business_login/theme_cubit/theme_cubit.dart';
import 'package:mvideo/presentation/theme/dark.dart';
import 'package:mvideo/presentation/theme/light.dart';
import 'package:mvideo/presentation/view/auth/login.dart';
import 'package:mvideo/presentation/view/home/home.dart';
import 'package:mvideo/services/local_notification_api.dart';
import 'package:mvideo/services/sharedpreference.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final ImagePicker _picker = ImagePicker();
final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationApi.init();
  Sharedpreference.prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthCubit(
                firebaseAuth: firebaseAuth,
                userCollection: userCollection,
                picker: _picker)),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MVideo',
              // state.isLight! ? themeLight :
              theme: state.isLight! ? themeLight : themeDark,
              home: Sharedpreference.prefs?.getString(ShareKeys.userId) != null
                  ? const Home()
                  : const Login());
        },
      ),
    );
  }
}
