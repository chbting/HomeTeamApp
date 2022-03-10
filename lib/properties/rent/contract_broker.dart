import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/ui/custom_im_stepper/custom_icon_stepper.dart';
import 'package:tner_client/utils/keyboard_visibility_builder.dart';
import 'package:tner_client/utils/text_helper.dart';

import 'contract_adjuster.dart';
import 'contract_confirmation.dart';
import 'contract_offer_data.dart';
import 'contract_viewer.dart';
import 'tenant_info.dart';

class ContractBrokerScreen extends StatefulWidget {
  const ContractBrokerScreen({Key? key, required this.property})
      : super(key: key);

  final Property property;

  @override
  State<ContractBrokerScreen> createState() => ContractBrokerScreenState();
}

class ContractBrokerScreenState extends State<ContractBrokerScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  int _activeStep = 0;

  late final ContractOffer _offer = ContractOffer(widget.property);
  final GlobalKey<ContractAdjusterScreenState> adjusterKey =
      GlobalKey<ContractAdjusterScreenState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO backpressed warning: quit scheduling?
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return Scaffold(
            appBar: AppBar(
                title: Text(TextHelper.appLocalizations.negotiate_contract)),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconStepper(
                  icons: [
                    Icon(Icons.edit,
                        color: Theme.of(context).colorScheme.onSecondary),
                    Icon(Icons.contacts,
                        color: Theme.of(context).colorScheme.onSecondary),
                    Icon(Icons.article,
                        color: Theme.of(context).colorScheme.onSecondary),
                    Icon(Icons.check,
                        color: Theme.of(context).colorScheme.onSecondary)
                  ],
                  activeStep: _activeStep,
                  activeStepBorderWidth: 2,
                  activeStepColor: Theme.of(context).colorScheme.secondary,
                  enableNextPreviousButtons: false,
                  enableStepTapping: false,
                  showStepCompleted: true,
                  stepRadius: 24.0,
                  lineColor: Colors.grey,
                  onStepReached: (index) {
                    setState(() {
                      _activeStep = index;
                    });
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(_getStepTitle(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.secondary))),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      //1. Accept/make changes
                      //2. Personal information
                      //3. View the actual contract (aka confirmation page)
                      //4. Sign and submit
                      ContractAdjusterScreen(key: adjusterKey, offer: _offer),
                      TenantInformationScreen(offer: _offer),
                      ContractViewerScreen(offer: _offer),
                      ContractConfirmationScreen(offer: _offer)
                    ],
                  ),
                ),
                _bottomButtons(isKeyboardVisible)
              ],
            ));
      },
    );
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return TextHelper.appLocalizations.accept_or_make_an_offer;
      case 1:
        return TextHelper.appLocalizations.fill_in_personal_information;
      case 2:
        return TextHelper.appLocalizations.sign_the_contract;
      case 3:
        return TextHelper.appLocalizations.confirm_and_submit;
      default:
        return '';
    }
  }

  void _nextStep() {
    if (_activeStep < _totalSteps - 1) {
      setState(() {
        _activeStep++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  void _previousStep() {
    if (_activeStep > 0) {
      setState(() {
        _activeStep--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  void _signWithBiometrics() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    bool canCheckBiometrics, didAuthenticate;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException {
      canCheckBiometrics = false;
    }

    if (canCheckBiometrics) {
      try {
        didAuthenticate = await localAuth.authenticate(
            localizedReason: TextHelper
                .appLocalizations.reason_sign_property_visit_agreement,
            biometricOnly: true);
      } on PlatformException {
        didAuthenticate = false;
      }

      if (didAuthenticate) {
        // case 1: successfully authenticated
        // todo _data.agreementSigned = true;
        _nextStep();
      } else {
        // case 2: authentication failed
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                TextHelper.appLocalizations.biometric_authentication_failed)));
      }
    } else {
      // case 3: biometric authentication unavailable
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(TextHelper
              .appLocalizations.biometric_authentication_unavailable)));
    }
  }

  void _confirm() {
    // todo
  }

  Widget _bottomButtons(bool isKeyboardVisible) {
    if (isKeyboardVisible) {
      return Container();
    } else {
      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton.icon(
                icon: Icon(
                    _activeStep == 0 ? Icons.restart_alt : Icons.arrow_back),
                label: Text(_activeStep == 0
                    ? TextHelper.appLocalizations.reset
                    : TextHelper.appLocalizations.back),
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                    // 48.0 is the height of extended fab
                    shape: const StadiumBorder()),
                onPressed: () {
                  switch (_activeStep) {
                    case 0:
                      adjusterKey.currentState!.reset();
                      break;
                    default:
                      _previousStep();
                      break;
                  }
                },
              ),
              ElevatedButton.icon(
                icon: Icon(_activeStep == 2
                    ? Icons.fingerprint
                    : (_activeStep == 3 ? Icons.check : Icons.arrow_forward)),
                label: Text(_activeStep == 2
                    ? TextHelper.appLocalizations.sign_contract
                    : (_activeStep == 3
                        ? TextHelper.appLocalizations.submit
                        : TextHelper.appLocalizations.next)),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                    shape: const StadiumBorder()),
                onPressed: () {
                  switch (_activeStep) {
                    case 0:
                      if (adjusterKey.currentState!.validate()) {
                        _nextStep();
                      }
                      break;
                    case 2:
                      _signWithBiometrics();
                      break;
                    case 3:
                      _confirm();
                      break;
                    default:
                      _nextStep();
                      break;
                  }
                },
              )
            ],
          ));
    }
  }
}
