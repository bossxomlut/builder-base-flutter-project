import 'package:flutter/material.dart';

import '../../domain/index.dart';
import '../../injection/injection.dart';
import '../../route/app_router.dart';
import '../../widget/toast.dart';
import '../utils/index.dart';
import 'set_up_pin_code_page.dart';

@RoutePage()
class ForgotPinCodePage extends SetUpPinCodePage {
  const ForgotPinCodePage({super.key});

  @override
  State<SetUpPinCodePage> createState() => _ForgotPinCodePageState();
}

class _ForgotPinCodePageState extends SetUpPinCodePageState {
  final CheckSecurityQuestionUseCase checkSecurityQuestionUseCase = getIt.get<CheckSecurityQuestionUseCase>();

  @override
  String get title => 'Forgot pin code';

  @override
  void onQuestionAnswered(SecurityQuestionEntity question, String answer) {
    selectedQuestion = question;
    this.answer = answer;
    checkSecurityQuestionUseCase
        .execute(CheckSecurityQuestionParamEntity(
      question: selectedQuestion!,
      answer: this.answer,
    ))
        .then((value) {
      if (value) {
        tabController.animateTo(1);
      } else {
        showError(message: 'Security question is incorrect');
      }
    });
  }

  @override
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

    showSuccess(message: 'Pin code has been reset successfully');

    // Navigate to pin code page
    appRouter.goToLoginAtTop();
  }
}
