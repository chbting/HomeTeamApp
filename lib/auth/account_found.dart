import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth/firebase_ui_oauth.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/auth/auth_info.dart';

class AccountFoundWidget extends StatelessWidget {
  const AccountFoundWidget({Key? key, required this.providerIDs})
      : super(key: key);

  final List<String> providerIDs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(S.of(context).account_found,
                      style: Theme.of(context).textTheme.titleLarge))),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(S.of(context).sign_in_with_the_following_method,
                      style: Theme.of(context).textTheme.titleMedium))),
          ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              itemCount: providerIDs.length,
              itemBuilder: (context, index) {
                OAuthProvider provider;
                switch (providerIDs[index]) {
                  case 'google.com':
                    provider = GoogleProvider(clientId: AuthInfo.googleClientId);
                    break;
                  case 'facebook.com':
                    provider = FacebookProvider(clientId: AuthInfo.facebookClientId);
                    break;
                  default:
                    provider = GoogleProvider(clientId: AuthInfo.googleClientId);
                    break;
                }

                return AuthStateListener<OAuthController>(
                  child: OAuthProviderButton(
                    provider: provider,
                  ),
                  listener: (oldState, newState, ctrl) {
                    if (newState is SignedIn || newState is UserCreated) {
                      Navigator.of(context).pop(true);
                    }
                    return null;
                  },
                );
              }),
        ],
      ),
    );
  }
}
