import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SignInScreen(
        // headerBuilder: (context, _, shrinkOffset) {
        //   return Text('header');
        // },
        // subtitleBuilder: (context, authAction) {
        //   return Text('subtitle');
        // },
        // footerBuilder: (context, authAction) {
        //   return Text('footer');
        // },
        actions: [
          AuthStateChangeAction<SignedIn>((context, state) {
            Navigator.of(context).pop();
          }),
          EmailLinkSignInAction((context) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EmailLinkSignInScreen(
                      actions: [
                        AuthStateChangeAction<SignedIn>((context, state) {
                          Navigator.of(context).pop();
                        }),
                      ],
                    )));
          }),
          VerifyPhoneAction((context, _) {
            //todo custom phone verification flow
          })
        ],
      ),
    );
  }
}
