import 'package:flutter/material.dart';

import '../../domain/index.dart';
import '../../injection/injection.dart';
import '../../route/app_router.dart';
import '../../widget/index.dart';
import '../utils/index.dart';
import 'pin_code_page.dart';
import 'widget/number_pad.dart';
import 'widget/pin_code.dart';

@RoutePage()
class SetUpPinCodePage extends StatefulWidget {
  const SetUpPinCodePage({super.key});

  @override
  State<SetUpPinCodePage> createState() => SetUpPinCodePageState();
}

class SetUpPinCodePageState extends State<SetUpPinCodePage>
    with SingleTickerProviderStateMixin, StateTemplate<SetUpPinCodePage> {
  late final TabController tabController = TabController(length: 2, vsync: this);

  SecurityQuestionEntity? selectedQuestion;
  String answer = '';
  String pin = '';

  final SavePinCodeUseCase savePinCodeUseCase = getIt.get<SavePinCodeUseCase>();

  String get title => 'Set up your security question and pin code';

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return CustomAppBar(title: '');
  }

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: AnimatedBuilder(
            animation: tabController,
            builder: (context, _) {
              return AppStepWidget(
                totalSteps: 2,
                currentStep: tabController.index,
              );
            },
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SetUpQuestionWidget(
                onQuestionAnswered: onQuestionAnswered,
                title: title,
              ),
              SetUpPinCodeWidget(
                onPinCodeSet: onPinCodeSet,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void onQuestionAnswered(SecurityQuestionEntity question, String answer) {
    selectedQuestion = question;
    this.answer = answer;

    tabController.animateTo(1);
  }

  void onPinCodeSet(String pin) {
    this.pin = pin;

    // Save pin code and security question
    savePinCodeUseCase.execute(
      SavePinCodeParamEntity(
        question: selectedQuestion!,
        answer: answer,
        pin: pin,
      ),
    );

    // Navigate to pin code page
    appRouter.goToLoginAtTop();
  }
}

class SetUpQuestionWidget extends StatefulWidget {
  const SetUpQuestionWidget({
    super.key,
    required this.onQuestionAnswered,
    required this.title,
  });

  final String title;

  final Function(SecurityQuestionEntity question, String answer) onQuestionAnswered;

  @override
  State<SetUpQuestionWidget> createState() => _SetUpQuestionWidgetState();
}

class _SetUpQuestionWidgetState extends State<SetUpQuestionWidget> with StateTemplate<SetUpQuestionWidget> {
  final GetSecurityQuestionsUseCase getSecurityQuestionsUseCase = getIt.get<GetSecurityQuestionsUseCase>();

  late final List<SecurityQuestionEntity> questions = getSecurityQuestionsUseCase.execute(null);
  late SecurityQuestionEntity? selectedQuestion = questions.first;

  String answer = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 40),
          Text('Security Question', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<SecurityQuestionEntity>(
              items: questions.map((SecurityQuestionEntity question) {
                return DropdownMenuItem<SecurityQuestionEntity>(
                  value: question,
                  child: Text(question.question),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedQuestion = value;
                });
              },
              value: selectedQuestion,
              isExpanded: true,
            ),
          ),
          const SizedBox(height: 16),
          Text('Answer', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'Input your answer',
            ),
            onChanged: (value) {
              setState(() {
                answer = value;
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isValid()
                ? () {
                    widget.onQuestionAnswered(selectedQuestion!, answer);
                  }
                : null,
            child: const Text(
              'Next',
            ),
          ),
        ],
      ),
    );
  }

  bool isValid() {
    return selectedQuestion != null && answer.isNotEmpty;
  }
}

class SetUpPinCodeWidget extends StatefulWidget {
  const SetUpPinCodeWidget({super.key, required this.onPinCodeSet});

  final Function(String pin) onPinCodeSet;

  @override
  State<SetUpPinCodeWidget> createState() => _SetUpPinCodeWidgetState();
}

class _SetUpPinCodeWidgetState extends State<SetUpPinCodeWidget> with StateTemplate<SetUpPinCodeWidget> {
  final GlobalKey<NumberPadState> _numberPadKey = GlobalKey<NumberPadState>();
  final ValueNotifier<String> _pinNotifier = ValueNotifier<String>('');

  @override
  Widget buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Set up your pin code',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 40),
                ValueListenableBuilder<String>(
                  valueListenable: _pinNotifier,
                  builder: (context, pin, _) {
                    return PinCodeWidget(pin, showPin: true);
                  },
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder<String>(
          valueListenable: _pinNotifier,
          builder: (context, pin, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  // BackButton(),
                  // const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: pin.length < maxPinLength
                          ? null
                          : () {
                              widget.onPinCodeSet(pin);
                            },
                      child: const Text('Finish'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        NumberPad(
          key: _numberPadKey,
          onChanged: _onNumberPressed,
        ),
      ],
    );
  }

  void _onNumberPressed(String number) {
    if (number.length <= maxPinLength) {
      _pinNotifier.value = number;
    } else {}
  }
}
