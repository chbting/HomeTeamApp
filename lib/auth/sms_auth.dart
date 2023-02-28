import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:tner_client/generated/l10n.dart';

class SMSAuthScreen extends StatefulWidget {
  const SMSAuthScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SMSAuthScreenState();
}

class SMSAuthScreenState extends State<SMSAuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _autoRetrievalTimeout = 30;
  bool _showProgressIndicator = false;
  bool _codeRequested = false;
  bool _autofillFailed = false;
  final _horizontalPadding = 24.0;
  final _buttonHeight = 48.0;
  double _buttonWidth = 0.0;
  String _verificationId = '';
  String? _smsCode;

  @override
  void initState() {
    listenForSMSCode();
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
    SmsAutoFill().unregisterListener();
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
                validator: (value) {
                  return (value == null || value.isEmpty || value.length < 8)
                      ? S.of(context).msg_please_input_valid_phone_number
                      : null;
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(_buttonWidth, _buttonHeight),
                    shape: const StadiumBorder()),
                onPressed: () {
                  if (!_codeRequested && _formKey.currentState!.validate()) {
                    setState(() {
                      _codeRequested = true;
                      _showProgressIndicator = true;
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                    _requestSMSCode('+852 ${_controller.value.text}');
                  }
                },
                child: _codeRequested
                    ? const SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 3.0))
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
                Container(width: 16.0),
                Visibility(
                    visible: _showProgressIndicator,
                    child: const SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 3.0)))
              ],
            ),
          ),
          PinInputTextField(
            autoFocus: _autofillFailed,
            decoration: UnderlineDecoration(
              lineStrokeCap: StrokeCap.square,
              colorBuilder: PinListenColorBuilder(
                  Theme.of(context).colorScheme.primary, Colors.grey.shade500),
            ),
            onChanged: (code) => _smsCode = code,
            onSubmit: (code) => _verifySMSCode(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
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
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: _autoRetrievalTimeout),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // ANDROID ONLY!
        // This handler will only be called on Android devices which support automatic SMS code resolution.

        if (mounted) {
          await _auth.signInWithCredential(credential).then((value) {
            Navigator.of(context).pop(true);
          });

          //todo remove
          // debugPrint('verificationCompleted!!');
          // setState(() {
          //   _showProgressIndicator = false;
          //   _autofillFailed = true;
          // });
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (mounted) {
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid.'); //todo
          }
          Navigator.of(context).pop(false);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (mounted) {
          _pageController.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn);
          setState(() {
            _codeRequested = false;
            _controller.clear();
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
    if (_smsCode?.length == 6) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: _smsCode ?? '');
      _auth.signInWithCredential(credential).then((value) {
        Navigator.of(context).pop(true);
      });
    }
    //todo onError, e.g. wrong sms code, expired Verification id
  }

  void listenForSMSCode() async {
    await SmsAutoFill().listenForCode();
  }

  Future<void> sampleRequest() {
    return Future.delayed(
      const Duration(seconds: 4),
      () => debugPrint('Your code is 54321'),
    );
  }
}
