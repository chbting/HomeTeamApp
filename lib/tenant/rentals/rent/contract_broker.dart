import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/contract_bid.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_adjuster.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_viewer.dart';
import 'package:hometeam_client/tenant/rentals/rent/offer_confirmation.dart';
import 'package:hometeam_client/tenant/rentals/rent/tenant_info.dart';
import 'package:hometeam_client/ui/shared/standard_stepper.dart';
import 'package:local_auth/local_auth.dart';

class ContractBrokerScreen extends StatefulWidget {
  const ContractBrokerScreen({Key? key, required this.property})
      : super(key: key);

  final Property property;
  static const stepTitleBarHeight = 4.0;
  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonSpacing = 16.0;
  static const bottomButtonContainerHeight = buttonHeight + buttonSpacing * 2;

  @override
  State<ContractBrokerScreen> createState() => ContractBrokerScreenState();
}

class ContractBrokerScreenState extends State<ContractBrokerScreen> {
  final StandardStepperController _controller = StandardStepperController();
  final GlobalKey<ContractAdjusterScreenState> adjusterKey =
      GlobalKey<ContractAdjusterScreenState>();
  final GlobalKey<TenantInformationScreenState> tenantInfoKey =
      GlobalKey<TenantInformationScreenState>();

  int _activeStep = 0;

  late final ContractBid _bid =
      ContractBid(contract: widget.property.contract.copyWith());

  @override
  Widget build(BuildContext context) {
    //1. Accept/make changes
    //2. Personal information
    //3. View the actual contract (aka confirmation page)
    //4. Sign and submit
    final steps = [
      EasyStep(
          icon: const Icon(Icons.edit_note),
          title: S.of(context).accept_or_make_an_offer),
      EasyStep(
          icon: const Icon(Icons.person),
          title: S.of(context).fill_in_personal_information),
      EasyStep(
          icon: const Icon(Icons.draw), title: S.of(context).sign_the_contract),
      EasyStep(
          icon: const Icon(Icons.check),
          title: S.of(context).confirm_and_submit),
    ];
    final pages = [
      ContractAdjusterScreen(
          key: adjusterKey, property: widget.property, bid: _bid),
      TenantInformationScreen(key: tenantInfoKey, offer: _bid),
      ContractViewerScreen(offer: _bid),
      OfferConfirmationScreen(property: widget.property, bid: _bid)
    ];

    return StandardStepper(
      controller: _controller,
      title: S.of(context).negotiate_contract,
      onActiveStepChanged: (activeStep) =>
          setState(() => _activeStep = activeStep),
      steps: steps,
      pages: pages,
      leftButtonIcon: Icon(_activeStep == 0 ? Icons.undo : Icons.arrow_back),
      leftButtonLabel:
          Text(_activeStep == 0 ? S.of(context).reset : S.of(context).back),
      onLeftButtonPressed: () {
        _activeStep == 0
            ? adjusterKey.currentState?.reset()
            : _controller.previousStep();
      },
      rightButtonIcon: Icon(_activeStep == 2
          ? Icons.fingerprint
          : (_activeStep == 3 ? Icons.check : Icons.arrow_forward)),
      rightButtonLabel: Text(_activeStep == 2
          ? S.of(context).sign_contract
          : (_activeStep == 3 ? S.of(context).submit : S.of(context).next)),
      onRightButtonPressed: () {
        switch (_activeStep) {
          case 0:
            if (adjusterKey.currentState!.validate()) {
              _controller.nextStep();
            }
            break;
          case 1:
            if (tenantInfoKey.currentState!.validate()) {
              _controller.nextStep();
            }
            break;
          case 2:
            _signWithBiometrics(context);
            break;
          case 3:
            _confirm();
            break;
          default:
            _controller.nextStep();
            break;
        }
      },
    );
  }

  void _signWithBiometrics(BuildContext context) async {
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
              localizedReason: S.of(context).reason_sign_rental_contract,
              options: const AuthenticationOptions(biometricOnly: true));
        } on PlatformException {
          didAuthenticate = false;
        } finally {
          if (didAuthenticate) {
            // case 1: successfully authenticated
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
            content: Text(S.of(context).biometric_authentication_unavailable)));
      }
      // todo snackbar blocking buttons
    }
  }

  void _confirm() {
    // todo
  }
}
