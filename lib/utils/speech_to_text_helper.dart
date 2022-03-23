import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import 'package:tner_client/utils/text_helper.dart';

class SpeechToTextHelper {
  static final _speechToText = SpeechToText();
  static bool _initialized = false;
  static bool _isDialogShowing = false;
  static final SpeechToTextHelper _instance = SpeechToTextHelper._internal();

  factory SpeechToTextHelper() => _instance;

  SpeechToTextHelper._internal();

  static Future<bool> _isInitialized(BuildContext context) async {
    if (!_initialized) {
      _initialized = await _speechToText.initialize(
        finalTimeout: const Duration(seconds: 5), //todo
        onStatus: (status) {
          debugPrint('${DateTime.now()} onStatus:$status');
        },
        onError: (error) {
          debugPrint('${DateTime.now()} onError:$error');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  TextHelper.appLocalizations.msg_cannot_recognize_speech)));
          if (_isDialogShowing) {
            Navigator.pop(context);
          }
        },
      );
    }
    return _initialized;
  }

  static void speechToText(
      BuildContext context, Function(String?) onSpeechToTextResult) async {
    bool initialized = await _isInitialized(context);
    if (!initialized) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(TextHelper.appLocalizations.msg_voice_search_unavailable)));
      onSpeechToTextResult(null);
    } else {
      // todo make sure the 3 locales always work/ handle error
      String localeId = SharedPreferencesHelper().getVoiceRecognitionLocaleId();

      _showSpeechToTextDialog(context, localeId);
      await _speechToText.listen(
          localeId: localeId,
          cancelOnError: true,
          onResult: (result) {
            if (result.finalResult) {
              if (_isDialogShowing) {
                Navigator.pop(context);
              }
              if (result.confidence > 0.0) {
                onSpeechToTextResult(result.recognizedWords);
              } else {
                onSpeechToTextResult(null);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(TextHelper
                        .appLocalizations.msg_cannot_recognize_speech)));
              }
            }
          });
    }
  }

  static void _showSpeechToTextDialog(BuildContext context, String localeId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          _isDialogShowing = true;
          return AlertDialog(
              title: Text(TextHelper.appLocalizations.voice_search),
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AvatarGlow(
                        glowColor: Theme.of(context).colorScheme.secondary,
                        endRadius: 72.0,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          radius: 40.0,
                          child: const Icon(Icons.mic, size: 32.0),
                        ),
                      )),
                  Text(SharedPreferencesHelper.getVoiceRecognitionLanguage(
                      localeId))
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(TextHelper.appLocalizations.cancel,
                      style: AppTheme.getDialogTextButtonTextStyle(context)),
                  onPressed: () {
                    _speechToText.isListening ? _speechToText.stop() : null;
                    if (_isDialogShowing) {
                      Navigator.pop(context);
                    }
                  },
                )
              ]);
        }).then((value) {
      // make sure speech to text stops
      _isDialogShowing = false;
      _speechToText.isListening ? _speechToText.stop() : null;
    });
  }
}
