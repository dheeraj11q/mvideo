import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mvideo/business_login/auth_cubit/auth_cubit.dart';
import 'package:mvideo/presentation/common_widgets/snack_bar.dart';
import 'package:mvideo/services/validations/besic_input_validations.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            return state.isLoading!
                ? loadingBox(size)
                : Container(
                    padding: const EdgeInsets.all(16),
                    width: size.width,
                    child: Form(
                      key: registerFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SizedBox(height: size.height * 0.04),
                          // Text(
                          //   "Register",
                          //   style: TextStyle(fontSize: size.width * 0.06),
                          // ),
                          SizedBox(height: size.height * 0.05),

                          // image

                          GestureDetector(
                            onTap: () {
                              authCubit.pickImage();
                            },
                            child: BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return state.userImageFile?.path != ""
                                    ? SizedBox(
                                        height: size.height * 0.1,
                                        width: size.width * 0.2,
                                        child: Image.file(
                                          File(state.userImageFile!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        height: size.height * 0.1,
                                        width: size.width * 0.2,
                                        decoration: const BoxDecoration(
                                          color: Colors.grey,
                                        ),
                                        child: const Icon(Icons.image),
                                      );
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            "Choose Image",
                            style: TextStyle(fontSize: size.width * 0.04),
                          ),

                          // name

                          TextFormField(
                            controller: authCubit.state.userModel?.nameTextCtrl,
                            validator: (v) => InputValidations.name(v!),
                            decoration:
                                const InputDecoration(hintText: "Username"),
                          ),
                          SizedBox(height: size.height * 0.02),

                          // email

                          TextFormField(
                            controller:
                                authCubit.state.userModel?.emailTextCtrl,
                            validator: (v) => InputValidations.email(v!),
                            decoration:
                                const InputDecoration(hintText: "Email"),
                          ),
                          SizedBox(height: size.height * 0.02),

                          // dob

                          TextFormField(
                            controller: authCubit.state.userModel?.dobTextCtrl,
                            validator: (v) => InputValidations.required(v!),
                            readOnly: true,
                            decoration: const InputDecoration(
                                hintText: "Date of Birth"),
                            onTap: () async {
                              DateTime? date = DateTime(1900);

                              date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));

                              authCubit.state.userModel?.dobTextCtrl?.text =
                                  DateFormat.yMMMMd().format(date!);
                            },
                          ),
                          SizedBox(height: size.height * 0.02),

                          // phone

                          TextFormField(
                            controller:
                                authCubit.state.userModel?.phoneTextCtrl,
                            keyboardType: TextInputType.phone,
                            validator: (v) => InputValidations.phone(v!),
                            decoration:
                                const InputDecoration(hintText: "Phone"),
                          ),
                          SizedBox(height: size.height * 0.03),

                          // register button
                          GestureDetector(
                            onTap: () {
                              if (authCubit.state.userImageFile == null) {
                                appSnack(context, "Please Choose Image");
                              } else {
                                if (registerFormKey.currentState!.validate()) {
                                  authCubit.sendOtpToPhone(context);
                                  // authCubit.register(context);
                                  // authCubit.accountCheck();
                                }
                              }
                            },
                            child: Container(
                              width: size.width,
                              height: size.height * 0.07,
                              color: Theme.of(context).primaryColor,
                              alignment: Alignment.center,
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.04),
                              ),
                            ),
                          ),

                          SizedBox(height: size.height * 0.03),

                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        color: Colors.black),
                                    children: [
                                  const TextSpan(text: "Already have account "),
                                  TextSpan(
                                    text: "Login",
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
        ),
      ),
    );
  }
}
