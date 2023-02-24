import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/auth/account_found.dart';
import 'package:tner_client/auth/password_auth.dart';

class EmailCheckScreen extends StatefulWidget {
  const EmailCheckScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EmailCheckScreenState();
}

class EmailCheckScreenState extends State<EmailCheckScreen> {
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
            setState(() {
              providerIDs = providers;
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeIn);
            });
          }),
          _getNextPage(),
        ],
      ),
    );
  }

  Widget _getNextPage() {
    if (providerIDs.contains('password')) {
      return PasswordAuthWidget(email: email, showRegistrationUI: false);
    } else if (providerIDs.contains('google.com') ||
        providerIDs.contains('facebook.com')) {
      return AccountFoundWidget(providerIDs: providerIDs);
    } else {
      return PasswordAuthWidget(email: email, showRegistrationUI: true);
    }
  }
}
