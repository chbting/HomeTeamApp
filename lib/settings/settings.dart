import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tner_client/auth/auth.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/settings/settings_ui.dart';
import 'package:tner_client/ui/radio_list_dialog.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final List<String> _localeStringList = ['zh_Hant', 'zh_Hans', 'en'];
  final List<String> _languageList = [];
  final _avatarRadius = 36.0;
  final _horizontalPadding = 16.0;
  bool _darkMode = SharedPreferencesHelper.isDarkMode();
  String _localeString = SharedPreferencesHelper.localeToString(
      SharedPreferencesHelper.getLocale());

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    for (var element in _localeStringList) {
      _languageList.add(_localeStringToLanguage(element, context));
    }
    return Column(
      children: [
        AppBar(
          title: Text(S.of(context).settings),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              InkWell(
                onTap: currentUser == null
                    ? null
                    : () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => _getProfileScreen(context)));
                      },
                child: Stack(
                  alignment: AlignmentDirectional.centerStart,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _horizontalPadding, vertical: 8.0),
                        child: _getAvatar()),
                    Padding(
                        padding: EdgeInsets.only(
                            left: (_avatarRadius + _horizontalPadding) * 2),
                        child: Text(currentUser == null
                            ? S.of(context).not_signed_in
                            : currentUser.displayName ??
                                currentUser.phoneNumber ??
                                currentUser.email ??
                                '')),
                    Visibility(
                      visible: currentUser == null,
                      child: Padding(
                        padding: EdgeInsets.only(right: _horizontalPadding),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const AuthScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const StadiumBorder()),
                              child: Text(S.of(context).sign_in)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              SettingsUI.getSettingsTitle(
                  context, S.of(context).general_settings),
              SwitchListTile(
                title: Text(S.of(context).darkMode),
                secondary: const Icon(Icons.dark_mode),
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                    SharedPreferencesHelper.setDarkModeOn(value);
                  });
                },
                value: _darkMode,
              ),
              ListTile(
                  title: Text(S.of(context).language),
                  subtitle:
                      Text(_localeStringToLanguage(_localeString, context)),
                  leading: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.language),
                  ),
                  onTap: () {
                    RadioListDialog.show(
                        context,
                        _localeStringList,
                        _languageList,
                        _localeString,
                        S.of(context).choose_language, (value) {
                      _localeString = value;
                      SharedPreferencesHelper.setLocale(
                          SharedPreferencesHelper.stringToLocale(value));
                    });
                  }),
              const Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ],
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }

  Widget _getAvatar() {
    final currentUser = FirebaseAuth.instance.currentUser;
    final facebookSignedIn =
        currentUser?.providerData[0].providerId == 'facebook.com'
            ? true
            : false;
    return FutureBuilder<Map<String, dynamic>>(
        // todo the profile pic will not be available if the token expired
        future: facebookSignedIn ? FacebookAuth.instance.getUserData() : null,
        builder: (context, snapShot) {
          ImageProvider? foregroundImage;
          String? photoURL = facebookSignedIn
              ? (snapShot.data?['picture']['data']['url'])
              : currentUser?.photoURL;
          if (photoURL != null) {
            foregroundImage = NetworkImage(photoURL);
          }
          return CircleAvatar(
              radius: _avatarRadius,
              foregroundImage: foregroundImage,
              child: currentUser == null || photoURL == null
                  ? Icon(Icons.person, size: _avatarRadius)
                  : null);
        });
  }

  Widget _getProfileScreen(BuildContext context) {
    return ProfileScreen(
      appBar: AppBar(),
      actions: [
        SignedOutAction((context) {
          _signOut().then((success) => success
              ? Navigator.of(context).pop()
              : null); //todo delete account button
        }),
      ],
    );
  }

  Future<bool> _signOut() async {
    await FirebaseUIAuth.signOut();
    return FirebaseAuth.instance.currentUser == null;
  }

  String _localeStringToLanguage(String locale, BuildContext context) {
    switch (locale) {
      case 'en':
        return 'English';
      case 'zh_Hant':
        return '䌓體中文';
      case 'zh_Hans':
        return '简体中文';
      default:
        return 'English';
    }
  }
}
