import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/ui/custom_im_stepper/custom_icon_stepper.dart';
import 'package:tner_client/utils/keyboard_visibility_builder.dart';

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
                title: Text(AppLocalizations.of(context)!.negotiate_contract)),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconStepper(
                  icons: [
                    Icon(Icons.place,
                        color: Theme.of(context).colorScheme.onSecondary),
                    Icon(Icons.calendar_today,
                        color: Theme.of(context).colorScheme.onSecondary),
                    Icon(Icons.description,
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
                      ContractAdjusterScreen(offer: _offer),
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
        return AppLocalizations.of(context)!.accept_or_make_an_offer;
      case 1:
        return AppLocalizations.of(context)!.fill_in_personal_information;
      case 2:
        return AppLocalizations.of(context)!.sign_the_contract;
      case 3:
        return AppLocalizations.of(context)!.confirm_and_submit;
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
            localizedReason: AppLocalizations.of(context)!
                .reason_sign_property_visit_agreement,
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
            content: Text(AppLocalizations.of(context)!
                .biometric_authentication_failed)));
      }
    } else {
      // case 3: biometric authentication unavailable
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!
              .biometric_authentication_unavailable)));
    }
  }

  void _confirm() {
    // todo
  }

  Widget _bottomButtons(bool isKeyboardVisible) {
    if (isKeyboardVisible) {
      return Container();
    } else {
      switch (_activeStep) {
        case 0:
          return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(AppLocalizations.of(context)!.next),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                        shape: const StadiumBorder()),
                    onPressed: () {
                      setState(() {
                        _nextStep();
                      });
                    },
                  )));
        case 2:
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint),
                    label: Text(AppLocalizations.of(context)!.sign_now),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width - 32.0, 48.0),
                        shape: const StadiumBorder()),
                    onPressed: () {
                      _signWithBiometrics();
                    },
                  ),
                  Container(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: Text(AppLocalizations.of(context)!.back),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width / 2 - 24.0,
                                48.0),
                            // 48.0 is the height of extended fab
                            shape: const StadiumBorder()),
                        onPressed: () {
                          _previousStep();
                        },
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.redo),
                        label: Text(AppLocalizations.of(context)!.sign_later),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width / 2 - 24.0,
                                48.0),
                            // 48.0 is the height of extended fab
                            shape: const StadiumBorder()),
                        onPressed: () {
                          // todo _data.agreementSigned = false;
                          _nextStep();
                        },
                      ),
                    ],
                  )
                ],
              ));
        default:
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    label: Text(AppLocalizations.of(context)!.back),
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                        // 48.0 is the height of extended fab
                        shape: const StadiumBorder()),
                    onPressed: () {
                      _previousStep();
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(_activeStep < _totalSteps - 1
                        ? Icons.arrow_forward
                        : Icons.check),
                    label: Text(_activeStep < _totalSteps - 1
                        ? AppLocalizations.of(context)!.next
                        : AppLocalizations.of(context)!.confirm),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                        shape: const StadiumBorder()),
                    onPressed: () {
                      if (_activeStep == _totalSteps - 1) {
                        _confirm();
                      } else {
                        _nextStep();
                      }
                    },
                  )
                ],
              ));
      }
    }
  }
}
