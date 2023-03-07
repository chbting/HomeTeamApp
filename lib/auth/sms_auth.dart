import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SMSAuthScreen extends StatefulWidget {
  const SMSAuthScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SMSAuthScreenState();
}

class SMSAuthScreenState extends State<SMSAuthScreen> with CodeAutoFill {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final _autoRetrievalTimeout = 30;
  bool _showProgressIndicator = false;
  bool _codeRequested = false;
  bool _autofillFailed = false;
  final _horizontalPadding = 24.0;
  final _buttonHeight = 48.0;
  double _buttonWidth = 0.0;
  String _verificationId = '';
  String? _userInputSmsCode;
  String _phoneErrorMessage = '';
  String _codeErrorMessage = '';

  @override
  void initState() {
    listenForCode();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _buttonWidth =
            MediaQuery.of(context).size.width - _horizontalPadding * 2;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _codeController.dispose();
    unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading: const CloseButton()),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            _getPhoneInputWidget(),
            _getPinInputWidget(),
          ],
        ));
  }

  Widget _getPhoneInputWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(S.of(context).what_is_your_phone_number,
                    style: Theme.of(context).textTheme.titleLarge),
              )),
          Form(
            key: _formKey,
            child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                maxLength: 8,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                    labelText: S.of(context).phone_number,
                    helperText: S.of(context).hong_kong_number_only),
                onChanged: (value) {
                  _phoneErrorMessage = '';
                },
                validator: (value) {
                  if (_phoneErrorMessage.isNotEmpty) {
                    return _phoneErrorMessage;
                  } else if (value == null ||
                      value.isEmpty ||
                      value.length < 8) {
                    return S.of(context).msg_please_input_valid_phone_number;
                  } else {
                    return null;
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FilledButton(
                style: FilledButton.styleFrom(
                    minimumSize: Size(_buttonWidth, _buttonHeight),
                    shape: const StadiumBorder()),
                onPressed: () {
                  if (!_codeRequested && _formKey.currentState!.validate()) {
                    setState(() {
                      _codeRequested = true;
                      _codeErrorMessage = '';
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                    _requestSMSCode('+852 ${_controller.value.text}');
                  }
                },
                child: _codeRequested
                    ? SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            color: Theme.of(context).colorScheme.onPrimary))
                    : Text(S.of(context).send_sms_code)),
          )
        ],
      ),
    );
  }

  Widget _getPinInputWidget() {
    return Padding(
      padding: EdgeInsets.all(_horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Text(
                    !_autofillFailed
                        ? S.of(context).waiting_for_sms_code_autofill
                        : S.of(context).please_manually_enter_sms_code,
                    style: Theme.of(context).textTheme.titleLarge),
                Visibility(
                    visible: _showProgressIndicator,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: CircularProgressIndicator(strokeWidth: 3.0)),
                    ))
              ],
            ),
          ),
          PinInputTextField(
            autoFocus: _autofillFailed,
            controller: _codeController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: UnderlineDecoration(
              lineStrokeCap: StrokeCap.square,
              colorBuilder: PinListenColorBuilder(
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.onBackground),
            ),
            onChanged: (code) => _userInputSmsCode = code,
            onSubmit: (code) => _verifySMSCode(),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                _codeErrorMessage,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: Theme.of(context).colorScheme.error),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: FilledButton(
              style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: Size(_buttonWidth, _buttonHeight)),
              onPressed: () => _verifySMSCode(),
              child: Text(S.of(context).verify),
            ),
          ),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: Size(_buttonWidth, _buttonHeight)),
              onPressed: () {
                _pageController.previousPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeIn);
              },
              child: Text(S.of(context).back))
        ],
      ),
    );
  }

  /// [phoneNumber] format '+852 12345678'
  void _requestSMSCode(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: _autoRetrievalTimeout),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // This handler will only be called on Android devices which support automatic SMS code resolution.
        if (mounted) {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) {
            Navigator.of(context).pop(true);
          });
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) {
          if (e.code == 'invalid-phone-number') {
            _phoneErrorMessage = S.of(context).msg_invalid_phone_number;
          } else {
            _phoneErrorMessage = S.of(context).msg_sms_verification_failed;
          }
          _formKey.currentState!.validate();
          setState(() {
            _codeRequested = false;
          });
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (mounted) {
          _pageController.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn);
          setState(() {
            _codeRequested = false;
            _showProgressIndicator = true;
            _verificationId = verificationId;
          });
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (mounted) {
          setState(() {
            _showProgressIndicator = false;
            _autofillFailed = true;
          });
        }
      },
    );
  }

  void _verifySMSCode() {
    if (_userInputSmsCode?.length == 6) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: _userInputSmsCode ?? '');
      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        Navigator.of(context).pop(true);
      }).catchError((error, stackTrace) {
        setState(() {
          _codeErrorMessage = S.of(context).msg_sms_verification_failed;
        });
      });
    } else {
      setState(() {
        _codeErrorMessage = S.of(context).msg_sms_verification_failed;
      });
    }
  }

  @override
  void codeUpdated() {
    debugPrint('code received:$code');
    if (code != null) {
      _codeController.text = code!;
    }
  }
}
