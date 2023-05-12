import 'package:easy_stepper/easy_stepper.dart';
import 'package:hometeam_client/utils/keyboard_visibility_builder.dart';

class StandardStepper extends StatefulWidget {
  const StandardStepper(
      {Key? key,
      required this.controller,
      required this.title,
      this.subtitle,
      required this.onActiveStepChanged,
      required this.steps,
      required this.pages,
      required this.leftButtonIcon,
      required this.leftButtonLabel,
      required this.onLeftButtonPressed,
      this.middleButtonIcon,
      this.middleButtonLabel,
      this.onMiddleButtonPressed,
      this.showMiddleButton = false,
      required this.rightButtonIcon,
      required this.rightButtonLabel,
      required this.onRightButtonPressed})
      : assert(steps.length == pages.length),
        super(key: key);

  final StandardStepperController controller;
  final String title;
  final Widget? subtitle;
  final ValueChanged<int> onActiveStepChanged;
  final List<EasyStep> steps;
  final List<Widget> pages;
  final Widget leftButtonIcon;
  final Widget leftButtonLabel;
  final VoidCallback onLeftButtonPressed;
  final Widget? middleButtonIcon;
  final Widget? middleButtonLabel;
  final VoidCallback? onMiddleButtonPressed;
  final bool showMiddleButton;
  final Widget rightButtonIcon;
  final Widget rightButtonLabel;
  final VoidCallback onRightButtonPressed;

  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonContainerPadding = 16.0;
  static const buttonBarHeight = buttonHeight + buttonContainerPadding * 2;

  @override
  State<StatefulWidget> createState() => StandardStepperState();

  /// TopPadding and bottomPadding have precedence to verticalPadding
  static Widget getSectionTitle(BuildContext context, String text,
          {double verticalPadding = 8.0,
          double? topPadding,
          double? bottomPadding}) =>
      Padding(
        padding: EdgeInsets.only(
            top: topPadding ?? verticalPadding,
            bottom: bottomPadding ?? verticalPadding),
        child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
      );
}

class StandardStepperState extends State<StandardStepper> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final PageController _pageController = PageController(initialPage: 0);
  final Duration _transitionDuration = const Duration(milliseconds: 250);

  int _activeStep = 0;
  bool _isButtonEnabled = true;

  late Size _buttonSize;

  @override
  void initState() {
    widget.controller.previousStep = _previousStep;
    widget.controller.nextStep = _nextStep;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var buttonCount = widget.showMiddleButton ? 3 : 2;
    var buttonWidth = (MediaQuery.of(context).size.width -
            StandardStepper.buttonContainerPadding * (buttonCount + 1)) /
        buttonCount;
    _buttonSize = Size(buttonWidth, StandardStepper.buttonHeight);

    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return ScaffoldMessenger(
          key: _scaffoldMessengerKey,
          child: Scaffold(
              appBar: AppBar(
                  title: Text(widget.title), leading: const CloseButton()),
              body: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: EasyStepper(
                          steps: widget.steps,
                          activeStep: _activeStep,
                          borderThickness: 8.0,
                          padding: const EdgeInsetsDirectional.symmetric(
                              horizontal: 8.0),
                          enableStepTapping: false,
                          showLoadingAnimation: false,
                          defaultLineColor:
                              Theme.of(context).colorScheme.onSurface,
                          finishedStepIconColor:
                              Theme.of(context).colorScheme.onPrimary,
                          stepAnimationCurve: Curves.bounceOut,
                          stepAnimationDuration: _transitionDuration,
                          onStepReached: (index) =>
                              setState(() => _activeStep = index)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: widget.subtitle,
                    ),
                    const Divider(height: 1.0),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: widget.pages,
                      ),
                    ),
                  ],
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: isKeyboardVisible ? null : _getBottomButtons())
              ])),
        );
      },
    );
  }

  Widget _getBottomButtons() {
    return Container(
        height: StandardStepper.buttonBarHeight,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0)
            ])),
        child: Padding(
            padding:
                const EdgeInsets.all(StandardStepper.buttonContainerPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  icon: widget.leftButtonIcon,
                  label: widget.leftButtonLabel,
                  style: OutlinedButton.styleFrom(
                      minimumSize: _buttonSize,
                      maximumSize: _buttonSize,
                      shape: const StadiumBorder(),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor),
                  onPressed: () {
                    if (_isButtonEnabled) {
                      widget.onLeftButtonPressed();
                    }
                  },
                ),
                Container(
                  child: widget.showMiddleButton
                      ? OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              minimumSize: _buttonSize,
                              maximumSize: _buttonSize,
                              shape: const StadiumBorder(),
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor),
                          onPressed: () {
                            if (_isButtonEnabled) {
                              widget.onMiddleButtonPressed!();
                            }
                          },
                          icon: widget.middleButtonIcon!,
                          label: widget.middleButtonLabel!,
                        )
                      : null,
                ),
                FilledButton.icon(
                  icon: widget.rightButtonIcon,
                  label: widget.rightButtonLabel,
                  style: FilledButton.styleFrom(
                      minimumSize: _buttonSize,
                      maximumSize: _buttonSize,
                      shape: const StadiumBorder()),
                  onPressed: () {
                    if (_isButtonEnabled) {
                      widget.onRightButtonPressed();
                    }
                  },
                )
              ],
            )));
  }

  void _nextStep() {
    if (_activeStep < widget.steps.length - 1) {
      _isButtonEnabled = false;
      setState(() {
        _activeStep++;
        widget.onActiveStepChanged(_activeStep);
      });
      _pageController
          .nextPage(duration: _transitionDuration, curve: Curves.easeIn)
          .whenComplete(() => _isButtonEnabled = true);
    }
  }

  void _previousStep() {
    if (_activeStep > 0) {
      _isButtonEnabled = false;
      setState(() {
        _activeStep--;
        widget.onActiveStepChanged(_activeStep);
      });
      _pageController
          .previousPage(duration: _transitionDuration, curve: Curves.easeIn)
          .whenComplete(() => _isButtonEnabled = true);
    }
  }
}

class StandardStepperController {
  void Function() previousStep = () {};
  void Function() nextStep = () {};
}