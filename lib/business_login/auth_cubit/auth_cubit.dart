import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvideo/data/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mvideo/presentation/common_widgets/snack_bar.dart';
import 'package:mvideo/presentation/view/auth/login.dart';
import 'package:mvideo/presentation/view/auth/otp_verification.dart';
import 'package:mvideo/presentation/view/home/home.dart';
import 'package:mvideo/services/sharedpreference.dart';
part 'auth_state.dart';

UploadTask? uploadTask;

class AuthCubit extends Cubit<AuthState> {
  FirebaseAuth? firebaseAuth;
  CollectionReference? userCollection;
  ImagePicker? picker;
  AuthCubit(
      {required this.firebaseAuth,
      required this.picker,
      required this.userCollection})
      : super(AuthState(
            userImageFile: XFile(""),
            userModel: UserModel(
                nameTextCtrl: TextEditingController(),
                emailTextCtrl: TextEditingController(),
                dobTextCtrl: TextEditingController(),
                phoneTextCtrl: TextEditingController(),
                phoneTextCtrl2: TextEditingController()),
            isLoading: false,
            otpTextCtrl: TextEditingController()));

// < OTP Verification with firebase

  void sendOtpToPhone(BuildContext context,
      {bool login = false, bool navigate = true}) async {
    emit(state.copyWith(isLoading: true));
    if (!login) {
      if (await isUserExist(phone: state.userModel!.phoneTextCtrl!.text) ==
          true) {
        appSnack(context, "Your phone number already exist!");
        emit(state.copyWith(isLoading: false));
        return;
      }
    }

    if (login) {
      if (await isUserExist(phone: state.userModel!.phoneTextCtrl2!.text) ==
          false) {
        appSnack(context, "You phone is not exist!");
        emit(state.copyWith(isLoading: false));
        return;
      }
    }

    firebaseAuth?.verifyPhoneNumber(
        phoneNumber: login
            ? state.userModel!.phoneTextCtrl2!.text
            : state.userModel!.phoneTextCtrl!.text,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await firebaseAuth?.signInWithCredential(phoneAuthCredential);
          if (login) {
            loginUser(context);
          } else {
            register(context);
          }

          emit(state.copyWith(isLoading: false));
        },
        verificationFailed: (verificationFailed) async {
          emit(state.copyWith(isLoading: false));
        },
        timeout: const Duration(seconds: 20),
        codeSent: (verificationId, resendToken) async {
          emit(state.copyWith(isLoading: false));

          if (navigate) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpVerification(
                          verificationId: verificationId,
                          login: login,
                        )));
          }
        },
        codeAutoRetrievalTimeout: (verificationId) {
          emit(state.copyWith(isLoading: false));
        });
  }

  void verifyOtp(
      {required BuildContext context,
      required String verificationId,
      bool login = false}) async {
    emit(state.copyWith(isLoading: true));
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: state.otpTextCtrl!.text);

    try {
      await firebaseAuth?.signInWithCredential(phoneAuthCredential);

      emit(state.copyWith(isLoading: false));

      if (login) {
        loginUser(context);
      } else {
        register(context);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      appSnack(context, "Wrong OTP");
    }
  }

  // < account check

  Future<bool> isUserExist({required String phone}) async {
    var data = await userCollection?.doc(phone).get();

    return data!.exists;
  }

  void loginUser(BuildContext context) {
    Sharedpreference.prefs
        ?.setString(ShareKeys.userId, state.userModel!.phoneTextCtrl2!.text);
    onClose();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }

// < all registration methods

  void register(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    String imageLink = await uploadImage();
    state.userModel?.imageLink = imageLink;

    userCollection
        ?.doc(state.userModel!.phoneTextCtrl!.text)
        .set(state.userModel?.formData());
    emit(state.copyWith(isLoading: false));
    Sharedpreference.prefs
        ?.setString(ShareKeys.userId, state.userModel!.phoneTextCtrl!.text);

    onClose();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }

  void pickImage() async {
    final XFile? image = await picker?.pickImage(source: ImageSource.gallery);
    if (image != null) {
      emit(state.copyWith(userImageFile: image));
    }
  }

  Future<String> uploadImage() async {
    final path = "images/${state.userImageFile?.name}";
    File imageFile = File(state.userImageFile!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(imageFile);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }

//<
  void getProfile() async {
    String? phone = Sharedpreference.prefs?.getString(ShareKeys.userId);

    var data = await userCollection?.doc(phone).get();

    if (data!.exists) {
      emit(state.copyWith(userModel: UserModel.fromObject(data)));
    }
  }

  void logout(BuildContext context) async {
    firebaseAuth?.signOut();
    Sharedpreference.prefs?.clear();
    onClose();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false);
  }

  void onClose() {
    emit(AuthState(
        userImageFile: XFile(""),
        userModel: UserModel(
            nameTextCtrl: TextEditingController(),
            emailTextCtrl: TextEditingController(),
            dobTextCtrl: TextEditingController(),
            phoneTextCtrl: TextEditingController(),
            phoneTextCtrl2: TextEditingController()),
        isLoading: false,
        otpTextCtrl: TextEditingController()));
  }
}
