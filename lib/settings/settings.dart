import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:hometeam_client/auth/auth.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/settings/locale_helper.dart';
import 'package:hometeam_client/settings/radio_list_dialog.dart';
import 'package:hometeam_client/settings/theme_mode_setting.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final _avatarRadius = 36.0;
  final _horizontalPadding = 16.0;

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
    return ListView(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.zero,
      children: <Widget>[
        AppBar(
          title: Text(S.of(context).settings),
        ),
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
                    child: FilledButton.tonal(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AuthScreen()));
                        },
                        style: FilledButton.styleFrom(
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
        _getSettingsTitle(context, S.of(context).general_settings),
        ListTile(
            title: Text(S.of(context).language),
            subtitle: Text(LocaleHelper.localeToLabel(
                SharedPreferencesHelper.getLocale())),
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(Icons.language),
            ),
            onTap: () {
              RadioListDialog.show(
                  context: context,
                  values: LocaleHelper.supportedLocales,
                  labels: LocaleHelper.supportedLocales
                      .map((value) => LocaleHelper.getLabel(value))
                      .toList(),
                  defaultValue: LocaleHelper.getString(
                      SharedPreferencesHelper.getLocale()),
                  title: S.of(context).choose_language,
                  onChanged: (value) {
                    SharedPreferencesHelper.setLocale(
                        LocaleHelper.parse(value));
                  });
            }),
        ListTile(
            title: Text(S.of(context).darkMode),
            subtitle: Text(ThemeModeHelper.getThemeModeLabel(
                context, SharedPreferencesHelper.getThemeMode())),
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(Icons.dark_mode),
            ),
            onTap: () {
              RadioListDialog.show(
                  context: context,
                  values: [
                    ThemeMode.light.name,
                    ThemeMode.dark.name,
                    ThemeMode.system.name
                  ],
                  labels: [
                    S.of(context).setting_off,
                    S.of(context).setting_on,
                    S.of(context).use_system_settings
                  ],
                  defaultValue: SharedPreferencesHelper.getThemeMode().name,
                  title: S.of(context).darkMode,
                  onChanged: (value) {
                    SharedPreferencesHelper.setThemeMode(
                        ThemeModeHelper.parseThemeMode(
                            value, ThemeMode.system));
                  });
            }),
        const Divider(
          thickness: 1,
        ),
        _getSettingsTitle(context, S.of(context).app_settings),
        SwitchListTile(
            secondary: const SizedBox(
              height: double.infinity,
              child: Icon(Icons.person),
            ),
            title: Text(S.of(context).landlord_mode),
            subtitle: Text(SharedPreferencesHelper.getLandlordMode()
                ? S.of(context).setting_on
                : S.of(context).setting_off),
            value: SharedPreferencesHelper.getLandlordMode(),
            onChanged: (landlordMode) {
              SharedPreferencesHelper.setLandlordMode(landlordMode);
            }),
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

  static _getSettingsTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 72.0, top: 16.0),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(color: Theme.of(context).colorScheme.secondary)),
    );
  }
}
