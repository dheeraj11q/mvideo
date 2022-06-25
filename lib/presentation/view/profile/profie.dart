import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvideo/business_login/auth_cubit/auth_cubit.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Proifle"),
          centerTitle: true,
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return Center(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: size.height * 0.15,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              '${state.userModel?.imageLink}',
                            ),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  Text('${state.userModel?.name}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontSize: size.width * 0.06)),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Text('${state.userModel?.email}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontSize: size.width * 0.06)),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Text('${state.userModel?.email}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontSize: size.width * 0.06)),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Text('${state.userModel?.phone}',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontSize: size.width * 0.06)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
