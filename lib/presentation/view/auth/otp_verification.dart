import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvideo/business_login/auth_cubit/auth_cubit.dart';
import 'package:mvideo/presentation/common_widgets/snack_bar.dart';
import 'package:mvideo/services/validations/besic_input_validations.dart';

class OtpVerification extends StatefulWidget {
  final String verificationId;
  final bool login;
  const OtpVerification(
      {Key? key, required this.verificationId, required this.login})
      : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
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
                        "Verify your number !",
                        style: TextStyle(fontSize: size.width * 0.06),
                      ),
                      SizedBox(height: size.height * 0.02),

                      Text(
                        "We have sent an OTP on your number",
                        style: TextStyle(fontSize: size.width * 0.04),
                      ),
                      SizedBox(height: size.height * 0.01),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return Text(
                            "${widget.login ? state.userModel?.phoneTextCtrl2?.text : state.userModel?.phoneTextCtrl?.text}",
                            style: TextStyle(fontSize: size.width * 0.04),
                          );
                        },
                      ),
                      SizedBox(height: size.height * 0.08),

                      // OTP Textfield
                      Form(
                        key: otpFormKey,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: authCubit.state.otpTextCtrl,
                          validator: (v) => InputValidations.required(v!),
                          decoration:
                              const InputDecoration(hintText: "Enter OTP"),
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      // verify button
                      GestureDetector(
                        onTap: () {
                          if (otpFormKey.currentState!.validate()) {
                            authCubit.verifyOtp(
                                context: context,
                                verificationId: widget.verificationId,
                                login: widget.login);
                          }
                        },
                        child: Container(
                          width: size.width,
                          height: size.height * 0.07,
                          color: Theme.of(context).primaryColor,
                          alignment: Alignment.center,
                          child: Text(
                            "Verify",
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
                          authCubit.sendOtpToPhone(context, navigate: false);
                        },
                        child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    color: Colors.black),
                                children: [
                              const TextSpan(text: "didn't get OTP "),
                              TextSpan(
                                text: "Resend",
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
