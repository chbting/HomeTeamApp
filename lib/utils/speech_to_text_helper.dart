import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/settings/locale_helper.dart';

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
          onError: (error) => _onError(error, context));
    }
    return _initialized;
  }

  static void speechToText(
      BuildContext context, Function(String?) onSpeechToTextResult) async {
    _isInitialized(context).then((initialized) {
      if (!initialized) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).msg_voice_search_unavailable)));
        onSpeechToTextResult(null);
      } else {
        _context = context;
        String localeId = LocaleHelper.getVoiceRecognitionLocaleId(context);

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
                      content:
                          Text(S.of(context).msg_cannot_recognize_speech)));
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
              title: Text(S.of(context).voice_search),
              contentPadding: EdgeInsets.zero,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AvatarGlow(
                        glowColor:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                        endRadius: 72.0,
                        child: const CircleAvatar(
                          radius: 40.0,
                          child: Icon(Icons.mic, size: 32.0),
                        ),
                      )),
                  Text(LocaleHelper.getVoiceRecognitionLanguage(
                      localeId, context))
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(S.of(context).cancel),
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

  static void _onError(SpeechRecognitionError error, BuildContext context) {
    log('${DateTime.now()} onError:$error');
    if (_context != null) {
      // todo To safely refer to a widget's ancestor in its dispose() method, save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() in the widget's didChangeDependencies() method.
      ScaffoldMessenger.of(_context!).showSnackBar(
          SnackBar(content: Text(S.of(context).msg_cannot_recognize_speech)));
      if (_isDialogShowing) {
        Navigator.pop(_context!);
      }
    }
  }
}
