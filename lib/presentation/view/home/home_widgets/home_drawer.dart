import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvideo/business_login/auth_cubit/auth_cubit.dart';
import 'package:mvideo/business_login/theme_cubit/theme_cubit.dart';
import 'package:mvideo/presentation/view/home/home.dart';
import 'package:mvideo/presentation/view/profile/profie.dart';

Widget homeDrawer({required Size size, required BuildContext context}) {
  return Drawer(
      child: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const SizedBox(
          height: 40,
        ),
        ListTile(
          title: Text(
            'Home',
            style: TextStyle(fontSize: size.width * 0.05),
          ),
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Home()),
                (route) => false);
          },
        ),
        ListTile(
          title: Text(
            'Proifle',
            style: TextStyle(fontSize: size.width * 0.05),
          ),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Profile()));
          },
        ),
        ListTile(
          title: Text(
            'Dark Theme',
            style: TextStyle(fontSize: size.width * 0.05),
          ),
          trailing: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: state.isLight! == false,
                  onChanged: (v) {
                    BlocProvider.of<ThemeCubit>(context).themeChange();
                  });
            },
          ),
          onTap: () {},
        ),
        ListTile(
          title: Text(
            'Logout',
            style: TextStyle(fontSize: size.width * 0.05),
          ),
          onTap: () {
            BlocProvider.of<AuthCubit>(context).logout(context);
          },
        ),
      ],
    ),
  ));
}
