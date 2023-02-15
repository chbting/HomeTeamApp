import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tner_client/generated/l10n.dart';

class SMSAuthDialog extends StatefulWidget {
  const SMSAuthDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SMSAuthDialogState();
}

class SMSAuthDialogState extends State<SMSAuthDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _showProgressIndicator = false;
  bool _codeSent = false;
  bool _phoneNumberSent = false;
  String _verificationId = '';
  String? _smsCode;
  int? _resendToken;

  @override
  void dispose() {
    _controller.dispose();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).sign_in_with_sms),
            Visibility(
              visible: _showProgressIndicator,
              child: const SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                  )),
            )
          ],
        ),
        content: Row(
          children: [
            Visibility(
              visible: !_codeSent,
              child: Form(
                key: _formKey,
                child: Expanded(
                  child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      maxLength: 8,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).phone_number,
                          helperText: S.of(context).hong_kong_number_only),
                      validator: (value) {
                        return (value == null ||
                                value.isEmpty ||
                                value.length < 8)
                            ? S.of(context).msg_please_input_valid_phone_number
                            : null;
                      }),
                ),
              ),
            ),
            Visibility(
              visible: _codeSent,
              child: Expanded(
                child: PinFieldAutoFill(
                    decoration: UnderlineDecoration(
                        lineStrokeCap: StrokeCap.square,
                        colorBuilder: PinListenColorBuilder(
                            Theme.of(context).colorScheme.primary,
                            Colors.grey.shade500)),
                    onCodeChanged: (code) {
                      _smsCode = code;
                    }, //code changed callback
                    codeLength: 6 //code length, default 6
                    ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text(S.of(context).cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(_codeSent
                ? S.of(context).sign_in
                : S.of(context).send_sms_code),
            onPressed: () {
              if (!_codeSent) {
                if (_formKey.currentState!.validate() && !_phoneNumberSent) {
                  _phoneNumberSent = true;
                  // 1. Hide the keyboard, show Progress Dialog
                  FocusManager.instance.primaryFocus?.unfocus();
                  setState(() {
                    _showProgressIndicator = true;
                  });

                  // 2. Request the SMS code
                  _signInWithPhoneNumber('+852 ${_controller.value.text}');
                }
              } else {
                // Sign in
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: _verificationId, smsCode: _smsCode ?? '');
                _auth.signInWithCredential(credential).then((value) {
                  Navigator.of(context).pop(true);
                });
                //todo onError, e.g. wrong sms code, UI for resend code
              }
            },
          )
        ]);
  }

  /// [phoneNumber] format '+852 12345678'
  void _signInWithPhoneNumber(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      // todo do a timer
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // This handler will only be called on Android devices which support automatic SMS code resolution.
        await _auth.signInWithCredential(credential).then((value) {
          Navigator.of(context).pop(true);
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
        }
        debugPrint('$e');
      },
      codeSent: (String verificationId, int? resendToken) {
        _listenForCode();
        _verificationId = verificationId;
        _resendToken = resendToken;
        setState(() {
          _showProgressIndicator = false;
          _codeSent = true;
          _controller.clear();
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _listenForCode() async {
    await SmsAutoFill().listenForCode();
  }
}
