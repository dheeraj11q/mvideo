import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvideo/business_login/auth_cubit/auth_cubit.dart';
import 'package:mvideo/presentation/common_widgets/snack_bar.dart';
import 'package:mvideo/presentation/view/auth/register.dart';
import 'package:mvideo/services/validations/besic_input_validations.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        return SafeArea(
          child: state.isLoading!
              ? loadingBox(size)
              : Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.04),
                      Text(
                        "Welcome to Mvideo",
                        style: TextStyle(fontSize: size.width * 0.06),
                      ),
                      SizedBox(height: size.height * 0.02),

                      Text(
                        "Enter your phone number below to log in we will send OTP on your phone.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: size.width * 0.04),
                      ),

                      SizedBox(height: size.height * 0.09),

                      // OTP Textfield
                      Form(
                        key: loginFormKey,
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          controller: authCubit.state.userModel?.phoneTextCtrl2,
                          validator: (v) => InputValidations.phone(v!),
                          decoration:
                              const InputDecoration(hintText: "Phone Number"),
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      // verify button
                      GestureDetector(
                        onTap: () {
                          if (loginFormKey.currentState!.validate()) {
                            authCubit.sendOtpToPhone(context, login: true);
                          }
                        },
                        child: Container(
                          width: size.width,
                          height: size.height * 0.07,
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.center,
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size.width * 0.04),
                          ),
                        ),
                      ),

                      // resend otp

                      SizedBox(height: size.height * 0.03),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Register()));
                        },
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    color: Colors.black),
                                children: [
                              const TextSpan(text: "don't have account "),
                              TextSpan(
                                text: "Register",
                                style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    color: Theme.of(context).primaryColor),
                              )
                            ])),
                      ),
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
