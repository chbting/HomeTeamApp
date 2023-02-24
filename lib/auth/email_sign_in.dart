import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/auth/account_found.dart';
import 'package:tner_client/auth/password_sign_in.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/id.dart';

class EmailSignInScreen extends StatefulWidget {
  const EmailSignInScreen({Key? key, required this.fromRegistration})
      : super(key: key);

  final bool fromRegistration;

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

            debugPrint('providers:$providers');
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
      return PasswordSignInWidget(
          email: email, isRegistration: widget.fromRegistration);
    } else if (providerIDs.contains('google.com') ||
        providerIDs.contains('facebook.com')) {
      // Account found page
      return AccountFoundWidget(providerIDs: providerIDs);
    } else {
      //todo notify user to register is it not coming from registration
      var subtitle = email;
      if (!widget.fromRegistration) {
        subtitle += ' ${S.of(context).is_not_registered_prompt_registration}';
      }
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FirebaseUIActions(
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  if (state.user != null) {
                    Navigator.of(context).pop(); //todo
                  }
                }),
              ],
              child: LoginView(
                  showAuthActionSwitch: false,
                  subtitleBuilder: (context, _) => Text(subtitle),
                  providers: [EmailAuthProvider()],
                  email: email,
                  action: AuthAction.signUp),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(children: <Widget>[
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(S.of(context).or,
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                const Expanded(child: Divider()),
              ]),
            ),
            FirebaseUIActions(
              actions: [
                AuthStateChangeAction<SignedIn>((context, state) {
                  if (state.user != null) {
                    Navigator.of(context).pop(); //todo
                  }
                }),
              ],
              child: LoginView(
                  showTitle: false,
                  showAuthActionSwitch: false,
                  providers: [
                    GoogleProvider(clientId: Id.googleClientId),
                    FacebookProvider(clientId: Id.facebookClientId)
                  ],
                  action: AuthAction.signUp),
            ),
          ],
        ),
      );
    }
  }
}
