import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/shared/theme/theme.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_agreement.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_confirmation.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_data.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_datepicker.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_sequencer.dart';
import 'package:hometeam_client/utils/format.dart';
import 'package:local_auth/local_auth.dart';

class VisitSchedulingScreen extends StatefulWidget {
  const VisitSchedulingScreen({Key? key, required this.data}) : super(key: key);

  final VisitData data;

  @override
  State<VisitSchedulingScreen> createState() => VisitSchedulingScreenState();
}

class VisitSchedulingScreenState extends State<VisitSchedulingScreen> {
  final StandardStepperController _controller = StandardStepperController();
  final int durationPerProperty = 900; // 15 minutes

  int _activeStep = 0;
  String _subtitle = '';

  @override
  Widget build(BuildContext context) {
    final steps = [
      //todo title overflow
      EasyStep(
          icon: const Icon(Icons.route), title: S.of(context).choose_the_route),
      EasyStep(
          icon: const Icon(Icons.calendar_today),
          title: S.of(context).pick_datetime),
      EasyStep(
          icon: const Icon(Icons.description),
          title: S.of(context).property_visit_agreement),
      EasyStep(icon: const Icon(Icons.check), title: S.of(context).confirm),
    ];
    final pages = [
      VisitSequencerWidget(
          data: widget.data, updateEstimatedTime: _updateEstimatedTime),
      VisitDatePickerWidget(data: widget.data),
      VisitAgreementWidget(data: widget.data),
      VisitConfirmationWidget(data: widget.data)
    ];

    return StandardStepper(
      controller: _controller,
      title: S.of(context).add_property,
      subtitle: _activeStep < 2
          ? Text(_subtitle, style: AppTheme.getStepSubtitleTextStyle(context))
          : null,
      onActiveStepChanged: (activeStep) =>
          setState(() => _activeStep = activeStep),
      steps: steps,
      pages: pages,
      leftButtonIcon: Icon(_activeStep == 0 ? Icons.undo : Icons.arrow_back),
      leftButtonLabel:
          Text(_activeStep == 0 ? S.of(context).reset : S.of(context).back),
      onLeftButtonPressed: () {
        _activeStep == 0 ? _resetToOptimizedPath() : _controller.previousStep();
      },
      showMiddleButton: _activeStep == 2,
      middleButtonIcon: const Icon(Icons.redo),
      middleButtonLabel: Text(S.of(context).skip),
      onMiddleButtonPressed: () => _controller.nextStep(),
      // todo show a dialog telling the user they will sign the agreement on site, recommend them to sign it now
      rightButtonIcon: Icon(_activeStep == 3
          ? Icons.check
          : _activeStep == 2
              ? Icons.fingerprint
              : Icons.arrow_forward),
      rightButtonLabel: Text(_activeStep == 3
          ? S.of(context).submit
          : _activeStep == 2
              ? S.of(context).sign
              : S.of(context).next),
      onRightButtonPressed: () {
        _activeStep == 3
            ? _confirm()
            : _activeStep == 2
                ? _signWithBiometrics()
                : _controller.nextStep();
      },
    );
  }

  void _signWithBiometrics() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    bool canCheckBiometrics = false;
    bool didAuthenticate = false;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException {
      canCheckBiometrics = false;
    } finally {
      if (canCheckBiometrics) {
        try {
          didAuthenticate = await localAuth.authenticate(
              localizedReason:
                  S.of(context).reason_sign_property_visit_agreement,
              options: const AuthenticationOptions(biometricOnly: true));
        } on PlatformException {
          didAuthenticate = false;
        } finally {
          if (didAuthenticate) {
            // case 1: successfully authenticated
            widget.data.agreementSigned = true;
            _controller.nextStep();
          } else {
            // case 2: authentication failed
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(S.of(context).biometric_authentication_failed)));
          }
        }
      } else {
        // case 3: biometric authentication unavailable
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                S.of(context).biometric_authentication_unavailable_agreement)));
        // todo button bar should move up when the snackBar shows
      }
    }
  }

  void _confirm() {
    // todo
  }

  void _resetToOptimizedPath() {
    widget.data.selectedPath.clear();
    widget.data.selectedPath.addAll(widget.data.optimizedPath);
    _updateEstimatedTime();
  }

  /// Return the estimated duration in seconds
  void _updateEstimatedTime() {
    int duration = 0;
    for (int i = 0; i < widget.data.selectedPath.length - 1; i++) {
      Listing origin = widget.data.selectedPath[i];
      Listing destination = widget.data.selectedPath[i + 1];
      duration += widget.data.travelMap[origin]![destination]!;
    }
    duration += durationPerProperty * widget.data.selectedPath.length;

    setState(() {
      _subtitle = '${S.of(context).estimated_duration}: '
          '${Format.formatDuration(Duration(seconds: duration), context)}';
    });
  }
}
