// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:test_sms/screens/home_screen.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';

// class PhoneAuthPage extends StatefulWidget {
//   @override
//   _PhoneAuthPageState createState() => _PhoneAuthPageState();
// }

// class _PhoneAuthPageState extends State<PhoneAuthPage> {
//   final _phoneNumController = TextEditingController();
//   String iphone = '';
//   String smsCode = '';
//   String verificationId = '';

//   bool showLoading = false;

//   final fireBaseAuth = FirebaseAuth.instance;

//   void signInWithPhoneAuthCredential(
//       PhoneAuthCredential phoneAuthCredential) async {
//     setState(() {
//       showLoading = true;
//     });

//     try {
//       final authCredential =
//           await fireBaseAuth.signInWithCredential(phoneAuthCredential);

//       setState(() {
//         showLoading = false;
//       });

//       if (authCredential.user != null) {
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => HomeScreen()));
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() {
//         showLoading = false;
//       });
//     }
//   }

//   void _verifyPhoneNumber(BuildContext context) async {
//     // _phoneNumController.text.toString()はテキストフィールドに入力された電話番号
//     String phone = "+81" + _phoneNumController.text.toString();

//     final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String verId) {
//       this.verificationId = verId;
//     };

//     final PhoneCodeSent smsCodeSent = (String verId, resendingToken) {
//       // fireBaseのrobotチェック後に呼ばれる
//       this.verificationId = verId;
//       smsCodeDialog(context).then((value) {
//         print('sign in');
//       });
//     };

//     final PhoneVerificationCompleted verifiedSuccess = (AuthCredential user) {
//       print('verified');
//     };

//     final PhoneVerificationFailed verifiedFailed = (verificationFailed) {
//       print('miss');
//     };

//     await fireBaseAuth.verifyPhoneNumber(
//       phoneNumber: phone,
//       timeout: Duration(seconds: 5),
//       verificationCompleted: verifiedSuccess,
//       verificationFailed: verifiedFailed,
//       codeSent: smsCodeSent,
//       codeAutoRetrievalTimeout: autoRetrieval,
//     );
//   }

//   smsCodeDialog(BuildContext context) {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext content) {
//           return AlertDialog(
//             title: Text('確認コードを入力してください'),
//             content: TextField(
//               keyboardType: TextInputType.number,
//               onChanged: (String value) {
//                 this.smsCode = value;
//               },
//             ),
//             contentPadding: EdgeInsets.all(10),
//             actions: <Widget>[
//               ElevatedButton(
//                   child: Text(
//                     "完了",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     signIn();
//                   }),
//             ],
//           );
//         });
//   }

//   signIn() {
//     PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
//         verificationId: verificationId, smsCode: smsCode);
//     signInWithPhoneAuthCredential(phoneAuthCredential);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text(
//           "電話番号ログイン",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Center(
//         child: Align(
//           alignment: Alignment.center,
//           child: Container(
//               padding: EdgeInsets.only(
//                 left: 30,
//                 right: 30,
//                 top: 100,
//                 bottom: 100,
//               ),
//               child: _phoneNumWidget(context)),
//         ),
//       ),
//     );
//   }

//   Widget _phoneNumWidget(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           "電話番号を入力してください。",
//           style: TextStyle(
//               fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
//         ),
//         Padding(
//           padding: EdgeInsets.only(top: 20),
//         ),
//         TextField(
//           controller: _phoneNumController,
//           keyboardType: TextInputType.phone,
//           onChanged: (String value) {
//             this.iphone = value;
//           },
//         ),
//         Padding(
//           padding: EdgeInsets.only(top: 20),
//         ),
//         Container(
//           width: 250,
//           child: RaisedButton(
//               child: Text(
//                 "電話番号ではじめる",
//                 style: TextStyle(color: Colors.white),
//               ),
//               color: Colors.orange,
//               shape: StadiumBorder(),
//               onPressed: () {
//                 _verifyPhoneNumber(context);
//               }),
//         ),
//       ],
//     );
//   }
// }
