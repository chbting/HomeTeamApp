import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import 'package:tner_client/utils/text_helper.dart';

class SpeechToTextHelper {
  static final _speechToText = SpeechToText();
  static bool _initialized = false;
  static bool _isDialogShowing = false;
  static BuildContext? _context;
  static final SpeechToTextHelper _instance = SpeechToTextHelper._internal();

  factory SpeechToTextHelper() => _instance;

  SpeechToTextHelper._internal();

  static Future<bool> _isInitialized(BuildContext context) async {
    if (!_initialized) {
      _initialized = await _speechToText.initialize(
          finalTimeout: const Duration(seconds: 3),
          onStatus: (status) => _onStatus(status),
          onError: (error) => _onError(error));
    }
    return _initialized;
  }

  static void speechToText(
      BuildContext context, Function(String?) onSpeechToTextResult) async {
    _isInitialized(context).then((initialized) {
      if (!initialized) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                TextHelper.appLocalizations.msg_voice_search_unavailable)));
        onSpeechToTextResult(null);
      } else {
        _context = context;
        String localeId =
            SharedPreferencesHelper().getVoiceRecognitionLocaleId();

        _showSpeechToTextDialog(context, localeId);
        log('${DateTime.now()} begin listening');
        _speechToText.listen(
            localeId: localeId,
            cancelOnError: true,
            onResult: (result) {
              debugPrint('$result');
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
    });
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

  static void _onStatus(String status) {
    log('${DateTime.now()} onStatus:$status');
  }

  static void _onError(SpeechRecognitionError error) {
    log('${DateTime.now()} onError:$error');
    if (_context != null) {
      ScaffoldMessenger.of(_context!).showSnackBar(SnackBar(
          content:
              Text(TextHelper.appLocalizations.msg_cannot_recognize_speech)));
      if (_isDialogShowing) {
        Navigator.pop(_context!);
      }
    }
  }
}
