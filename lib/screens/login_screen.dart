import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:test_sms/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationID = "";

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
    }
  }

  getMobileFormWidget(context) {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Text(
                    "電話番号を入力して",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "認証コードを送信しましょう",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        TextField(
                          controller: phoneController,
                          style: TextStyle(fontSize: 25),
                          // inputFormatters: [
                          //   LengthLimitingTextInputFormatter(11)
                          // ],
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '080 1234 5678',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: '日本国外の携帯電話番号をお持ちの方はこちら',
                                  style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          // TOPに移動,MyApp()を後で修正
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen()));
                                    },
                                )
                              ])),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          '電話番号を入力して送信すると、Firebase powered by Googleから認証SMSが送信されます。通信料金がかかる場合があります。',
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.redAccent),
                                text: 'Google利用規約',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(
                                        'https://policies.google.com/terms?hl=ja');
                                  },
                              ),
                            ),
                            SizedBox(width: 15),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.redAccent),
                                text: 'Googleプライバシーポリシー',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    launch(
                                        'https://policies.google.com/privacy?hl=ja');
                                  },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'SMSのご利用がオプションサービスとなっている機種をご利用の方は、事前に対象サービスをご確認の上ご登録ください。',
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    showLoading = true;
                  });

                  await auth.verifyPhoneNumber(
                    phoneNumber: phoneController.text,
                    verificationCompleted: (phoneAuthCredential) async {
                      setState(() {
                        showLoading = false;
                      });
                    },
                    verificationFailed: (verificationFailed) async {
                      setState(() {
                        showLoading = false;
                      });
                    },
                    codeSent: (verificationId, resendingToken) async {
                      setState(() {
                        showLoading = false;
                        currentState =
                            MobileVerificationState.SHOW_OTP_FORM_STATE;
                        this.verificationID = verificationId;
                      });
                    },
                    codeAutoRetrievalTimeout: (verificationId) async {},
                  );
                },
                child: Text(
                  '送信する',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                ),
              ),
            )
          ],
        ))
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        PinCodeTextField(
          controller: otpController,
          appContext: context,
          length: 6,
          onChanged: (value) {
            print(value);
          },
          keyboardType: TextInputType.phone,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            inactiveColor: Colors.black,
            activeColor: Colors.redAccent,
            selectedColor: Colors.blue,
          ),
        ),
        // TextField(
        //   controller: otpController,
        //   decoration: InputDecoration(
        //     hintText: "Enter OTP",
        //   ),
        //   keyboardType: TextInputType.phone,
        // ),
        SizedBox(
          height: 16,
        ),
        TextButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationID,
                    smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          child: Text("VERIFY"),
        ),
        Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
