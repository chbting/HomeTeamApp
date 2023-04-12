import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_adjuster.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker_inherited_data.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_viewer.dart';
import 'package:hometeam_client/tenant/rentals/rent/offer_confirmation.dart';
import 'package:hometeam_client/tenant/rentals/rent/tenant_info.dart';
import 'package:hometeam_client/ui/standard_stepper.dart';
import 'package:local_auth/local_auth.dart';

class ContractBrokerScreen extends StatefulWidget {
  const ContractBrokerScreen({Key? key}) : super(key: key);

  static const stepTitleBarHeight = 4.0;
  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonSpacing = 16.0;
  static const bottomButtonContainerHeight = buttonHeight + buttonSpacing * 2;

  @override
  State<ContractBrokerScreen> createState() => ContractBrokerScreenState();
}

class ContractBrokerScreenState extends State<ContractBrokerScreen> {
  final StandardStepperController _controller = StandardStepperController();
  final ContractAdjusterScreenController _contractAdjusterScreenController =
      ContractAdjusterScreenController();
  final TenantInfoScreenController _tenantInfoScreenController =
      TenantInfoScreenController();
  int _activeStep = 0;

  @override
  Widget build(BuildContext context) {
    //1. Accept/make changes
    //2. Personal information
    //3. View the actual contract (aka confirmation page)
    //4. Sign and submit
    final steps = [
      EasyStep(
          icon: const Icon(Icons.edit_note),
          title: S.of(context).accept_or_offer),
      EasyStep(
          icon: const Icon(Icons.person), title: S.of(context).tenant_info),
      EasyStep(
          icon: const Icon(Icons.draw), title: S.of(context).sign_contract),
      EasyStep(icon: const Icon(Icons.check), title: S.of(context).confirm),
    ];
    final pages = [
      ContractAdjusterScreen(controller: _contractAdjusterScreenController),
      TenantInfoScreen(controller: _tenantInfoScreenController),
      const ContractViewerScreen(),
      const OfferConfirmationScreen()
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
            ? _contractAdjusterScreenController.reset()
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
          // todo disabled for debugging
          // case 0:
          //   if (_contractAdjusterScreenController.validate()) {
          //     _controller.nextStep();
          //   }
          //   break;
          // case 1:
          //   if (_tenantInfoScreenController.validate()) {
          //     _controller.nextStep();
          //   }
          //   break;
          // case 2:
          //   _signWithBiometrics(context);
          //   break;
          case 3:
            _submit();
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

  //todo disable the button until result returns
  void _submit() {
    var propertyId =
        ContractBrokerInheritedData.of(context)!.bid.biddingTerms.propertyId;
    var listingId = propertyId;
    var address = PropertyHelper.getFromId(propertyId).address;

    debugPrint('submitting');
    DatabaseReference ref = FirebaseDatabase.instance.ref('offer/$listingId/');

    ref.set(address.toJson()).onError((error, stackTrace) {
      debugPrint('error $error');
    }).then((value) {
      //todo show snackBar and pop, show the property in "offer pending"
      debugPrint('submitted');
    });
  }
}
