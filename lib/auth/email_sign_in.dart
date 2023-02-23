import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/auth/account_found.dart';
import 'package:tner_client/auth/password.dart';

class EmailSignInScreen extends StatefulWidget {
  const EmailSignInScreen({Key? key, required this.isRegistration})
      : super(key: key);

  final bool isRegistration;

  @override
  State<StatefulWidget> createState() => EmailSignInScreenState();
}

class EmailSignInScreenState extends State<EmailSignInScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  String email = '';
  List<String> providerIDs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          UniversalEmailSignInScreen(onProvidersFound: (email, providers) {
            // Close the keyboard
            FocusManager.instance.primaryFocus?.unfocus();
            this.email = email;

            if (providers.contains('google.com') ||
                providers.contains('facebook.com')) {
            } else {
              if (widget.isRegistration) {
                // todo ask for pw
              } else {
                // todo enter pw or email magic link
              }
            }
            setState(() {
              providerIDs = providers;
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn);
            });
          }),
          Container(
            child: (providerIDs.contains('google.com') ||
                    providerIDs.contains('facebook.com'))
                ? AccountFoundWidget(providerIDs: providerIDs)
                : PasswordWidget(
                    email: email, isRegistration: widget.isRegistration),
          ),
        ],
      ),
    );
  }
}
