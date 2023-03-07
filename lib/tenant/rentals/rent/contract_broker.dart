import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/tenant/rentals/property.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_adjuster.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_offer_data.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_viewer.dart';
import 'package:hometeam_client/tenant/rentals/rent/offer_confirmation.dart';
import 'package:hometeam_client/tenant/rentals/rent/tenant_info.dart';
import 'package:hometeam_client/ui/shared/custom_im_stepper/first_stepper/icon_stepper.dart';
import 'package:hometeam_client/utils/keyboard_visibility_builder.dart';

class ContractBrokerScreen extends StatefulWidget {
  const ContractBrokerScreen({Key? key, required this.property})
      : super(key: key);

  final Property property;
  static const stepTitleBarHeight = 40.0;
  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonSpacing = 16.0;
  static const bottomButtonContainerHeight = buttonHeight + buttonSpacing * 2;

  @override
  State<ContractBrokerScreen> createState() => ContractBrokerScreenState();
}

class ContractBrokerScreenState extends State<ContractBrokerScreen> {
  final GlobalKey _stepperKey = GlobalKey();
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  int _activeStep = 0;
  double _stepTitleBarTopMargin = 0.0;
  bool _isButtonEnabled = true;

  late double _buttonWidth;

  late final ContractOffer _offer = ContractOffer(widget.property);
  final GlobalKey<ContractAdjusterScreenState> adjusterKey =
      GlobalKey<ContractAdjusterScreenState>();
  final GlobalKey<TenantInformationScreenState> tenantInfoKey =
      GlobalKey<TenantInformationScreenState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final box = _stepperKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _stepTitleBarTopMargin = box.size.height - 1; // -1 rounding error?
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO backpressed warning: quit scheduling?
    _buttonWidth = (MediaQuery.of(context).size.width -
            ContractBrokerScreen.buttonSpacing * 3) /
        2;

    var stepIconColor = Theme.of(context).colorScheme.onPrimary;
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return Scaffold(
            appBar: AppBar(
                title: Text(S.of(context).negotiate_contract),
                leading: const CloseButton()),
            body: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconStepper(
                    key: _stepperKey,
                    icons: [
                      Icon(Icons.edit_note, color: stepIconColor),
                      Icon(Icons.person, color: stepIconColor),
                      Icon(Icons.draw, color: stepIconColor),
                      Icon(Icons.check, color: stepIconColor)
                    ],
                    activeStep: _activeStep,
                    activeStepBorderWidth: 2,
                    activeStepColor: Theme.of(context).colorScheme.primary,
                    enableNextPreviousButtons: false,
                    enableStepTapping: false,
                    showIsStepCompleted: true,
                    stepRadius: 24.0,
                    lineColor: Colors.grey,
                    onStepReached: (index) {
                      setState(() {
                        _activeStep = index;
                      });
                    },
                  ),
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
                        TenantInformationScreen(
                            key: tenantInfoKey, offer: _offer),
                        ContractViewerScreen(offer: _offer),
                        OfferConfirmationScreen(offer: _offer)
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: ContractBrokerScreen.stepTitleBarHeight,
                margin: EdgeInsets.only(top: _stepTitleBarTopMargin),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: const Alignment(0.0, 0.5),
                        colors: [
                      Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.0),
                      Theme.of(context).scaffoldBackgroundColor
                    ])),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(_getStepTitle(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.secondary))),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: isKeyboardVisible ? null : _getBottomButtons())
            ]));
      },
    );
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return S.of(context).accept_or_make_an_offer;
      case 1:
        return S.of(context).fill_in_personal_information;
      case 2:
        return S.of(context).sign_the_contract;
      case 3:
        return S.of(context).confirm_and_submit;
      default:
        return '';
    }
  }

  void _nextStep() {
    if (_activeStep < _totalSteps - 1) {
      _isButtonEnabled = false;
      setState(() {
        _activeStep++;
      });
      _pageController
          .nextPage(
              duration: const Duration(milliseconds: 250), curve: Curves.easeIn)
          .whenComplete(() => _isButtonEnabled = true);
    }
  }

  void _previousStep() {
    if (_activeStep > 0) {
      _isButtonEnabled = false;
      setState(() {
        _activeStep--;
      });
      _pageController
          .previousPage(
              duration: const Duration(milliseconds: 250), curve: Curves.easeIn)
          .whenComplete(() => _isButtonEnabled = true);
    }
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
              localizedReason: S.of(context).reason_sign_rental_contract,
              options: const AuthenticationOptions(biometricOnly: true));
        } on PlatformException {
          didAuthenticate = false;
        } finally {
          if (didAuthenticate) {
            // case 1: successfully authenticated
            _nextStep();
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

  Widget _getBottomButtons() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0)
            ])),
        child: Padding(
            padding: const EdgeInsets.all(ContractBrokerScreen.buttonSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  icon: Icon(
                      _activeStep == 0 ? Icons.restart_alt : Icons.arrow_back),
                  label: Text(_activeStep == 0
                      ? S.of(context).reset
                      : S.of(context).back),
                  style: OutlinedButton.styleFrom(
                      minimumSize:
                          Size(_buttonWidth, ContractBrokerScreen.buttonHeight),
                      shape: const StadiumBorder(),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor),
                  onPressed: () {
                    if (_isButtonEnabled) {
                      switch (_activeStep) {
                        case 0:
                          adjusterKey.currentState!.reset();
                          break;
                        default:
                          _previousStep();
                          break;
                      }
                    }
                  },
                ),
                FilledButton.icon(
                  icon: Icon(_activeStep == 2
                      ? Icons.fingerprint
                      : (_activeStep == 3 ? Icons.check : Icons.arrow_forward)),
                  label: Text(_activeStep == 2
                      ? S.of(context).sign_contract
                      : (_activeStep == 3
                          ? S.of(context).submit
                          : S.of(context).next)),
                  style: FilledButton.styleFrom(
                      minimumSize:
                          Size(_buttonWidth, ContractBrokerScreen.buttonHeight),
                      shape: const StadiumBorder()),
                  onPressed: () {
                    if (_isButtonEnabled) {
                      switch (_activeStep) {
                        case 0:
                          if (adjusterKey.currentState!.validate()) {
                            _nextStep();
                          }
                          break;
                        case 1:
                          _nextStep();
                          if (tenantInfoKey.currentState!.validate()) {
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
                    }
                  },
                )
              ],
            )));
  }
}
