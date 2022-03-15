import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_sms/screens/login_screen.dart';

import '../screens/home_screen.dart';

final loginControllerProvider =
    ChangeNotifierProvider((ref) => LoginController());

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginController extends ChangeNotifier {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationID = '';

  bool showLoading = false;

  Future<void> signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential, BuildContext context) async {
    showLoading = true;
    notifyListeners();
    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);
      showLoading = false;
      notifyListeners();

      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      showLoading = false;
      notifyListeners();
    }
  }

  void verifyPhoneNumber(BuildContext context) async {
    showLoading = false;
    notifyListeners();
    // _phoneNumController.text.toString()はテキストフィールドに入力された電話番号
    String phone = "+81" + phoneController.text.toString();

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
      showLoading = false;
      notifyListeners();
    };

    final PhoneVerificationFailed verifiedFailed = (verificationFailed) {
      showLoading = false;
      notifyListeners();
    };

    final PhoneCodeSent smsCodeSent = (String verId, resendingToken) {
      // fireBaseのrobotチェック後に呼ばれる

      showLoading = false;
      // currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
      this.verificationID = verId;
      notifyListeners();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OtpFormWidget()));
    };

    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String verId) {
      this.verificationID = verId;
    };

    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifiedFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieval,
      timeout: Duration(seconds: 5),
    );
  }

  signIn(BuildContext context) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);
    await signInWithPhoneAuthCredential(phoneAuthCredential, context);
  }
}
