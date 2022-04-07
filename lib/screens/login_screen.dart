import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_sms/controllers/login_controller.dart';
import 'package:test_sms/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.watch(loginControllerProvider);
    return Scaffold(
        body: Container(
      child: loginController.showLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : MobileFormWidget(),
      padding: const EdgeInsets.all(16),
    ));
  }
}

class MobileFormWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.watch(loginControllerProvider);
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
                          controller: loginController.phoneController,
                          style: TextStyle(fontSize: 25),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11)
                          ],
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
                  loginController.verifyPhoneNumber(context);
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
}

class OtpFormWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginController = ref.watch(loginControllerProvider);
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                child: Row(
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
              ),
              Text(
                '届いた6桁の認証コードを',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '入力してください',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 30, 100, 0),
                child: PinCodeTextField(
                  controller: loginController.otpController,
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
              ),
              Container(
                margin: const EdgeInsets.only(right: 175),
                child: TextButton(
                    onPressed: () {
                      // todo処理を書く
                    },
                    child: Text(
                      '認証コードを再送信する',
                      style: TextStyle(color: Colors.redAccent),
                    )),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: Text('SMSが届かない場合、ご自身の電話番号やSMSの受信設定をご確認ください。'),
              ),
            ],
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
                    loginController.signIn(context);
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
      ),
    );
  }
}
